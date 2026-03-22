use hashbrown::{HashMap, HashSet};
use lsp_types::{SemanticToken, Uri};
use ropey::Rope;
use tree_sitter::{Tree, TreeCursor};
use compact_str::{CompactString, ToCompactString};
use fast_radix_trie::StringRadixMap;
use std::fs;
use std::path::{Path, PathBuf};
use url::Url;
use std::collections::BTreeMap;
use std::rc::Rc;
use std::cell::RefCell;

pub const ANONYMOUS_OBJ: &str = "$anonymous$";

/// Normalize a name to lowercase for case-insensitive comparison
#[inline]
fn normalize_name(name: &str) -> String {
    name.to_lowercase()
}

#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct NormalizedName(String);

impl NormalizedName {
    #[inline]
    pub fn new(name: &str) -> Self {
        Self(normalize_name(name))
    }
}

impl From<&str> for NormalizedName {
    #[inline]
    fn from(name: &str) -> Self {
        Self::new(name)
    }
}

impl From<String> for NormalizedName {
    #[inline]
    fn from(name: String) -> Self {
        Self::new(&name)
    }
}

impl std::ops::Deref for NormalizedName {
    type Target = str;

    #[inline]
    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl std::borrow::Borrow<str> for NormalizedName {
    #[inline]
    fn borrow(&self) -> &str {
        &self.0
    }
}

impl std::borrow::Borrow<String> for NormalizedName {
    #[inline]
    fn borrow(&self) -> &String {
        &self.0
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum TokenType {    // @@ need to sync with SemanticTokensLegend
    RedFunction,
    RedVariable,
    RedKeyword,
    RedCtx,
}

pub struct Document {
    pub content: Rope,
    pub tree: Option<Tree>,
    pub root_object: Rc<RefCell<ObjectNode>>,
}

/// Path completion item
#[derive(Debug, Clone)]
pub struct PathCompletionItem {
    pub label: String,
    pub is_dir: bool,
}

/// Object member type
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum MemberType {
    Value,      // Regular value (numbers, strings, etc.)
    Function,   // Function
    Object,     // Nested object (context)
    Native,
    Action,
    Routine,
}

impl MemberType {
    pub fn as_str(&self) -> &'static str {
        match self {
            MemberType::Value    => "value",
            MemberType::Function => "func",
            MemberType::Object   => "obj",
            MemberType::Native   => "native",
            MemberType::Action   => "action",
            MemberType::Routine  => "routine",
        }
    }
}

/// Object member - uses CompactString for name storage
#[derive(Debug, Clone)]
pub struct ObjectMember {
    pub name: CompactString,
    pub member_type: MemberType,
    /// If function, stores its spec content (parameters and refinements)
    pub spec_content: Option<String>,
    /// Byte range of member definition (start, end)
    pub byte_range: Option<(usize, usize)>,
    /// Object path (scope_path) where member is defined
    pub object_path: Option<String>,
}

/// Object node, represents a context object
#[derive(Debug, Default, Clone)]
pub struct ObjectNode {
    pub name: String,                    // Object name (e.g., "a")
    pub scope_path: String,              // Full scope path (e.g., "a/b/a")
    pub members: SymbolsMap<ObjectMember>,  // Case-insensitive member lookup
    pub byte_range: (usize, usize),      // Byte range of object in source code
    pub file_path: String,
    pub include_obj: Option<Rc<RefCell<ObjectNode>>>    // link to another object
}

impl ObjectNode {
    pub fn new() -> Self {
        Self {
            name: String::new(),
            scope_path: String::new(),
            members: SymbolsMap::new(),
            ..Default::default()
        }
    }

    /// Get member with case-insensitive lookup
    pub fn get_member(&self, name: &str) -> Option<ObjectMember> {
        self.members.get(name)
    }

    /// Check if object has a member with the given name
    pub fn has_member(&self, name: &str) -> bool {
        self.members.contains_key(name)
    }
}

/// Object graph, stores all defined objects and their members
#[derive(Debug)]
pub struct ObjectGraph {
    /// Scope path -> Object node
    pub objects: HashMap<String, Rc<RefCell<ObjectNode>>>,
    /// Normalized object name -> All scope paths for that name (uses HashSet for fast removal)
    pub name_to_scopes: HashMap<NormalizedName, HashSet<String>>,
    /// File path -> range_map for that file (start_byte -> scope_path)
    file_range_maps: HashMap<String, BTreeMap<usize, String>>,
    /// File path -> All scope paths in that file, for fast removal
    file_to_scopes: HashMap<String, Vec<String>>,
    /// Scope path -> Object name, for fast removal from name_to_scopes
    scope_to_name: HashMap<String, NormalizedName>,
}

impl ObjectGraph {
    pub fn new() -> Self {
        Self {
            objects: HashMap::new(),
            name_to_scopes: HashMap::new(),
            file_range_maps: HashMap::new(),
            file_to_scopes: HashMap::new(),
            scope_to_name: HashMap::new(),
        }
    }

    pub fn get(&self, path: &str) -> Option<&Rc<RefCell<ObjectNode>>> {
        self.objects.get(path)
    }

    /// Find a member function by name across all objects
    pub fn find_function(&self, name: &str) -> Option<ObjectMember> {
        // Search all objects for a member with the given name
        for (_, obj) in &self.objects {
            if let Some(member) = obj.borrow().get_member(name) {
                if is_any_func(member.member_type.clone()) {
                    return Some(member);
                }
            }
        }
        None
    }

    /// Get a function member from a specific object path
    pub fn get_function_from_object(&self, name: &str, object_path: &str) -> Option<ObjectMember> {
        // Get the object directly using object_path
        if let Some(obj) = self.objects.get(object_path) {
            if let Some(member) = obj.borrow().get_member(name) {
                if is_any_func(member.member_type.clone()) {
                    return Some(member);
                }
            }
        }
        None
    }

    /// Add object
    pub fn add_object(&mut self, name: &String, scope_path: String, obj: ObjectNode) {
        let mut obj = obj;
        obj.scope_path = scope_path.clone();
        obj.name = name.clone();
        let file_path = obj.file_path.clone();

        // Record name to scope mapping (using HashSet) - normalize name for case-insensitive comparison
        let normalized_name = NormalizedName::from(name.as_str());
        self.name_to_scopes.entry(normalized_name.clone()).or_insert_with(HashSet::new).insert(scope_path.clone());
        // Also insert into the file's range_map for fast lookup
        self.file_range_maps
            .entry(file_path.clone())
            .or_insert_with(BTreeMap::new)
            .insert(obj.byte_range.0, scope_path.clone());
        // Record file to scope mapping for fast removal
        self.file_to_scopes.entry(file_path).or_insert_with(Vec::new).push(scope_path.clone());
        // Record scope to name mapping for fast removal from name_to_scopes
        self.scope_to_name.insert(scope_path.clone(), normalized_name);
        self.objects.insert(scope_path, Rc::new(RefCell::new(obj)));
    }

    /// Find current scope at byte position (from inner to outer)
    pub fn find_scopes_at_position(&self, byte_pos: usize, file_path: &str) -> Vec<&Rc<RefCell<ObjectNode>>> {
        // Use the file's range_map for fast lookup
        let Some(range_map) = self.file_range_maps.get(file_path) else {
            return Vec::new();
        };

        // Find all scopes with start_byte <= byte_pos
        // Then filter out those with end_byte >= byte_pos
        // range(..=byte_pos).rev() iterates from back to front, inner scopes first, no need to sort
        range_map
            .range(..=byte_pos)
            .rev()
            .filter_map(|(_, scope_path)| {
                self.objects.get(scope_path).filter(|obj| byte_pos <= obj.borrow().byte_range.1)
            })
            .collect()
    }

    /// Remove all objects related to a file - O(k) time complexity, where k is the number of objects in that file
    pub fn remove_objects_by_file(&mut self, file_path: &str) {
        // Directly get all scopes for this file from file_to_scopes
        let scopes_to_remove = match self.file_to_scopes.remove(file_path) {
            Some(scopes) => scopes,
            None => return,  // File does not exist, return directly
        };

        // Remove objects and remove from name_to_scopes
        for scope_path in &scopes_to_remove {
            self.objects.remove(scope_path);
            // Directly find the corresponding name through scope_to_name, then remove from name_to_scopes
            if let Some(name) = self.scope_to_name.remove(scope_path) {
                if let Some(scopes) = self.name_to_scopes.get_mut(&name) {
                    scopes.remove(scope_path);
                    // If there are no more scopes under this name, delete the entry
                    if scopes.is_empty() {
                        self.name_to_scopes.remove(&name);
                    }
                }
            }
        }

        // Remove the range_map for this file
        self.file_range_maps.remove(file_path);
    }

    /// Parse object path and find the corresponding object
    /// path: "a" or "a/b", etc.
    /// current_scope: The current scope object
    pub fn resolve_object_path(&self, path: &str, current_scope: &Rc<RefCell<ObjectNode>>) -> (Rc<RefCell<ObjectNode>>, bool, Option<String>) {
        // Split the path into parts
        let parts: Vec<&str> = path.split('/').filter(|s| !s.is_empty()).collect();
        log::info!("resolve_object_path, parts {:?}", parts);
        if parts.is_empty() {
            return (current_scope.clone(), false, None);
        }

        // Start searching from the current scope
        let mut current_obj = current_scope.clone();

        if parts.len() == 1 {
            // check if it's a member of current scope
            let ctx = current_scope.borrow().include_obj.clone().unwrap_or_else(|| current_scope.clone());
            if let Some(member) = ctx.borrow().get_member(parts.first().unwrap()) && member.member_type != MemberType::Object {
                return (current_scope.clone(), false, Some(parts.first().unwrap().to_string()));
            }
        }

        for (i, part) in parts.iter().enumerate() {
            // Find an object named part under the current path

            let ctx = current_obj.borrow().include_obj.clone().unwrap_or_else(|| current_obj.clone());
            let found = self.find_child_object(&ctx, part);

            if let Some(obj) = found {
                log::info!("resolve_object_path find: {} - {}", part, i);
                let obj = obj.borrow().include_obj.clone().unwrap_or_else(|| obj.clone());
                if i == parts.len() - 1 {
                    // Last part, return the object
                    return (obj, true, None);
                }
                current_obj = obj;
            } else {
                // part might be a function
                return (current_obj, false, Some(part.to_string()));
            }
        }

        (current_obj, false, None)
    }

    /// Find child object under the specified scope
    fn find_child_object(&self, parent_scope: &Rc<RefCell<ObjectNode>>, child_name: &str) -> Option<&Rc<RefCell<ObjectNode>>> {
        // Use normalized name for case-insensitive lookup
        let normalized_name = NormalizedName::from(child_name);
        let scope_path = format!("{}/{}", parent_scope.borrow().scope_path, child_name);
log::info!("find_child_obj scope_path {}", scope_path);
        // First try exact match
        if let Some(obj) = self.objects.get(&scope_path) {
            return Some(obj);
        }

        // Try case-insensitive lookup via name_to_scopes
        if let Some(scopes) = self.name_to_scopes.get(&normalized_name) {
            let parent_path = &parent_scope.borrow().scope_path;
            for scope in scopes {
                // Check if this scope is a direct child of parent
                if let Some(parent_end) = scope.rfind('/') {
                    let parent = &scope[..parent_end];
                    if parent == parent_path {
                        return self.objects.get(scope);
                    }
                } else if parent_path.is_empty() {
                    // Top-level object
                    return self.objects.get(scope);
                }
            }
        }

        None
    }
}

pub struct Ctx {
    pub parser: tree_sitter::Parser,
    pub documents: HashMap<Uri, Document>,  // all opened files
    pub symbols: Symbols,
    pub functions: HashSet<CompactString>,
    pub include_cache: HashMap<Uri, Rc<RefCell<ObjectNode>>>,
    pub object_graph: ObjectGraph,  // object graph
    /// Node type ID cache, avoid repeated string comparisons
    pub node_kind_ids: HashMap<&'static str, u16>,
    pub builtin_ctx: Rc<RefCell<ObjectNode>>,
    pub current_uri: Option<Uri>
}

impl Ctx {
    pub fn new() -> Self {
        let mut parser = tree_sitter::Parser::new();
        let lang = tree_sitter_red::LANGUAGE;
        parser.set_language(&lang.into()).expect("Failed to set language");

        // Pre-fetch all node type kind_ids
        let mut node_kind_ids = HashMap::new();
        let lang: tree_sitter::Language = lang.into();
        for kind_name in [
            "issue", "file", "make", "word", "set_word", "function", "does", "context",
            "block", "path", "set_path", "refinement"] {
            node_kind_ids.insert(kind_name, lang.id_for_node_kind(kind_name, true));
        }

        Self {
            parser,
            documents: HashMap::new(),
            symbols: Symbols::new(),
            functions: HashSet::new(),
            include_cache: HashMap::new(),
            object_graph: ObjectGraph::new(),
            node_kind_ids,
            builtin_ctx: Rc::new(RefCell::new(ObjectNode::new())),
            current_uri: None
        }
    }

    /// Quickly get node type ID
    #[inline]
    fn get_kind_id(&self, kind_name: &str) -> u16 {
        *self.node_kind_ids.get(kind_name).unwrap_or(&0)
    }

    /// Get refinements from definition position
    fn get_refinements_from_member(&self, def: &ObjectMember) -> Option<Vec<ObjectMember>> {
        log::info!("member spec: {:?}", def.spec_content);
        if let Some(spec) = &def.spec_content {
            let mut parser = tree_sitter::Parser::new();
            let lang = tree_sitter_red::LANGUAGE;
            parser.set_language(&lang.into()).expect("Failed to set language");

            if let Some(tree) = parser.parse(spec, None) {
                return self.extract_refinements_from_block(spec, tree.root_node());
            }
        }
        None
    }

    /// Extract refinements from spec block
    fn extract_refinements_from_block(&self, source_code: &str, block_node: tree_sitter::Node) -> Option<Vec<ObjectMember>> {
        let mut cursor = block_node.walk();
        let kind_refinement = self.get_kind_id("refinement");
        if cursor.goto_first_child() {
            let mut results = Vec::new();
            loop {
                let node = cursor.node();
                if node.kind_id() == kind_refinement {
                    if let Some(text) = get_node_text(source_code, &node) {
                        let ref_name = text.trim_start_matches('/');
                        if !ref_name.is_empty() && ref_name != "local" {
                            results.push(ObjectMember {
                                name: CompactString::from(ref_name),
                                member_type: MemberType::Value,
                                spec_content: None,
                                byte_range: Some((node.start_byte(), node.end_byte())),
                                object_path: None
                            });
                        }
                    }
                }

                if !cursor.goto_next_sibling() {
                    break;
                }
            }
            if results.is_empty() {
                return None;
            } else {
                return Some(results);
            }
        }
        None
    }
}

fn get_node_text<'a>(source_code: &'a str, node: &tree_sitter::Node) -> Option<&'a str> {
    let start_byte = node.start_byte();
    let end_byte = node.end_byte();

    if start_byte <= source_code.len() && end_byte <= source_code.len() && start_byte <= end_byte {
        Some(&source_code[start_byte..end_byte])
    } else {
        None
    }
}

impl Ctx {
    /// Get path completion suggestions (read from file system in real-time)
    pub fn get_path_completions(&self, prefix: &str, file_uri: &Uri) -> Vec<PathCompletionItem> {
        // Get the directory where the file is located
        let current_dir = Url::parse(file_uri.as_str())
            .ok()
            .and_then(|url| url.to_file_path().ok())
            .and_then(|path| path.parent().map(|p| p.to_path_buf()))
            .unwrap_or_else(|| PathBuf::from("."));

        // Parse prefix, remove % prefix and get base path and the part to complete
        let (base_path, partial) = Self::parse_path_prefix(prefix, &current_dir);

        log::info!("base path {:?}, partial {}", base_path, partial);
        // Read directly from the file system
        Self::collect_from_filesystem(&base_path, &partial)
    }

    /// Find object member completions
    pub fn find_members(&self, object_path: &str, current_byte_pos: usize, prefix: &str, file_path: &str) -> Vec<ObjectMember> {
        // First find the current scope at the cursor position
        let scopes = self.object_graph.find_scopes_at_position(current_byte_pos, file_path);
log::info!("find scopes: {:?}", scopes);
        // Try to resolve object path from the current scope
        for scope in &scopes {
            match self.get_members_or_refiments(object_path, prefix, scope) {
                Some(results) => return results,
                None => break,
            }
        }
        // find in global scope
        Vec::new()
    }

    /// Helper function to process resolve_object_path result
    fn process_resolve_result(obj: &Rc<RefCell<ObjectNode>>, is_found: bool, member_name: Option<String>) -> (Option<Rc<RefCell<ObjectNode>>>, Option<ObjectMember>) {
        let obj = obj.borrow().include_obj.clone().unwrap_or_else(|| obj.clone());
        if is_found {
            let member = member_name.and_then(|name| {
                obj.as_ref().borrow().get_member(&name)
            });
            return (Some(obj.clone()), member);
        } else {
            if let Some(name) = member_name && let Some(member) = obj.borrow().get_member(&name) {
                return (None, Some(member));
            }
        }
        (None, None)
    }

    /// Find the definition position of an object member
    /// Returns: (object node, member info)
    pub fn find_obj(&self, word: &str, start_byte: usize, file_path: &str) -> (Option<Rc<RefCell<ObjectNode>>>, Option<ObjectMember>) {
        // First search from object_graph
        // First find the current scope at the cursor position
        let scopes = self.object_graph.find_scopes_at_position(start_byte, file_path);

        // Try to resolve object path from the current scope
        for scope in &scopes {
            let (obj, is_found, member_name) = self.object_graph.resolve_object_path(word, scope);
            let obj = obj.borrow().include_obj.clone().unwrap_or_else(|| obj.clone());
            log::info!("find_obj find? : {}", is_found);
            if is_found {
                let member = member_name.and_then(|name| {
                    obj.as_ref().borrow().get_member(&name)
                });
                return (Some(obj.clone()), member);
            } else {
                if let Some(name) = member_name && let Some(member) = obj.borrow().get_member(&name) {
                    log::info!("find_obj find member: {}", word);
                    return (None, Some(member));
                }
            }
        }

        // Search from document's root_object
        log::info!("find_obj current file");
        if let Some(uri) = &self.current_uri {
            if let Some(document) = self.documents.get(uri) {
                let root_obj = document.root_object.clone();
                let (obj, is_found, member_name) = self.object_graph.resolve_object_path(word, &root_obj);
                let (obj, member) = Self::process_resolve_result(&obj, is_found, member_name);
                if obj.is_some() || member.is_some() {return (obj, member)}
            }
        }

        // Search from builtin_ctx
        log::info!("find_obj in builtin: {}", word);
        let builtin = self.builtin_ctx.clone();
        let (obj, is_found, member_name) = self.object_graph.resolve_object_path(word, &builtin);
        let (obj, member) = Self::process_resolve_result(&obj, is_found, member_name);
        if obj.is_some() || member.is_some() {return (obj, member)}

        log::info!("find_obj in name_to_scopes {}", word);
        let parts: Vec<&str> = word.split('/').filter(|s| !s.is_empty()).collect();
        if let Some(start_word) = parts.first() {
            let normalized_name = NormalizedName::from(start_word.to_string());
            if let Some(scopes) = self.object_graph.name_to_scopes.get(&normalized_name) {
                for scope in scopes {
                    if let Some(obj) = self.object_graph.objects.get(scope) {
                        let mut current_ctx = obj.clone();
                        for (i, part) in parts.iter().enumerate() {
                            if parts.len() == 1 {
                                return (Some(current_ctx), None);
                            }
                            if i == 0 {continue;}

                            let ctx = current_ctx.borrow().include_obj.clone().unwrap_or_else(|| current_ctx.clone());
                            let found = self.object_graph.find_child_object(&ctx, part);

                            if let Some(obj2) = found {
                                let obj2 = obj2.borrow().include_obj.clone().unwrap_or_else(|| obj2.clone());
                                if i == parts.len() - 1 {
                                    // Last part, return the object
                                    return (Some(obj2), None);
                                }
                                current_ctx = obj2;
                            } else {
                                // part might be a function
                                return Self::process_resolve_result(&current_ctx, false, Some(part.to_string()));
                            }
                        }
                    }
                }
            }
        }
        (None, None)
    }

    /// Get object member completions
    pub fn get_object_completions(&self, object_path: &str, current_byte_pos: usize, prefix: &str, file_uri: &Uri) -> Vec<ObjectMember> {
        log::info!("get_object_completions: {} - {}", object_path, prefix);
        // First search from object_graph
        let file_path = file_uri.to_string();
        let results = self.find_members(object_path, current_byte_pos, prefix, &file_path);
        if !results.is_empty() {
            return results;
        }

        // Search from document's root_object
        log::info!("get from opened file");
        if let Some(document) = self.documents.get(file_uri) {
            let root_obj = document.root_object.clone();
            if let Some(results) = self.get_members_from_object(object_path, prefix, &root_obj) {
                log::info!("current doc result: {:?}", results);
                return results;
            }
        }

        // Search from builtin_ctx
        log::info!("get from builtin");
        let builtin = self.builtin_ctx.clone();
        if let Some(results) = self.get_members_from_object(object_path, prefix, &builtin) {
            log::info!("builtin result: {:?}", results);
            return results;
        }

        Vec::new()
    }

    /// Collect members from an object or its included object
    fn collect_members_from_object(&self, obj_ref: &ObjectNode, prefix: &str, result: &mut Vec<ObjectMember>, seen_names: &mut HashSet<CompactString>) {
        let results : Vec<ObjectMember> = if prefix.is_empty() {
            if let Some(obj) = &obj_ref.include_obj {
                obj.borrow().members.values()
            } else {
                obj_ref.members.values()
            }
        } else {
            if let Some(obj) = &obj_ref.include_obj {
                obj.borrow().members.find_by_prefix(prefix)
            } else {
                obj_ref.members.find_by_prefix(prefix)
            }
        };
        for member in results {
            if seen_names.insert(member.name.clone()) {
                result.push(member);
            }
        }
    }

    pub fn get_symbol_completions(&self, current_byte_pos: usize, prefix: &str, file_uri: &Uri) -> Vec<ObjectMember> {
        let mut result = Vec::new();
        let mut seen_names = HashSet::new();

        // First search from object_graph
        let file_path = file_uri.to_string();
        // First find the current scope at the cursor position
        let scopes = self.object_graph.find_scopes_at_position(current_byte_pos, &file_path);
        // Try to resolve object path from the current scope
        for scope in &scopes {
            match self.get_members_or_refiments("", prefix, scope) {
                Some(results) => {
                    for member in results {
                        if seen_names.insert(member.name.clone()) {
                            result.push(member);
                        }
                    }
                },
                None => continue,
            }
        }

        // Search from document's root_object
        if let Some(document) = self.documents.get(file_uri) {
            let root_obj = document.root_object.clone();
            self.collect_members_from_object(&root_obj.borrow(), prefix, &mut result, &mut seen_names);
        }

        // Search from builtin_ctx
        log::info!("get from builtin");
        let builtin = self.builtin_ctx.clone();
        self.collect_members_from_object(&builtin.borrow(), prefix, &mut result, &mut seen_names);

        // search from symbols
        let symbols = self.symbols.find_by_prefix(prefix);
        for symbol in symbols {
            if seen_names.insert(symbol.to_compact_string()) {
                result.push(
                    ObjectMember {
                        name: symbol.to_compact_string(),
                        member_type: MemberType::Value,
                        spec_content: None,
                        byte_range: None,
                        object_path: None
                    });
            }
        }
        result
    }

    /// Get member completions from the specified object
    fn get_members_from_object(&self, object_path: &str, prefix: &str, root_object: &Rc<RefCell<ObjectNode>>) -> Option<Vec<ObjectMember>> {
        let parts: Vec<&str> = object_path.split('/').filter(|s| !s.is_empty()).collect();
        let name = parts.first().unwrap_or(&prefix);
        let ctx = root_object.borrow().include_obj.clone().unwrap_or_else(|| root_object.clone());
        if ctx.borrow().members.contains_key(name) {
            if let Some(results) = self.get_members_or_refiments(object_path, prefix, &ctx) {
                return Some(results);
            } else {
                // try to find it in root_object
                log::info!("finding it in root");
                if let Some(member) = ctx.borrow().get_member(name) {
                    if is_any_func(member.member_type.clone()) {
                        return self.get_refinements_from_member(&member);
                    }
                }
            }
        }
        None
    }

    fn get_members_or_refiments(&self, object_path: &str, prefix: &str, scope: &Rc<RefCell<ObjectNode>>) -> Option<Vec<ObjectMember>> {
        log::info!("get_members_or: {} -- {}", object_path, scope.borrow().scope_path);
        let (obj, is_found, word) = self.object_graph.resolve_object_path(object_path, scope);
        log::info!("is found?: {}", is_found);
        if is_found || word.is_none() {
            let obj_ref = obj.borrow();
            if let Some(obj) = &obj_ref.include_obj {
                let results : Vec<ObjectMember> = if prefix.is_empty() {
                    obj.borrow().members.values()
                } else {
                    obj.borrow().members.find_by_prefix(prefix)
                };
                return Some(results);
            } else {
                let results : Vec<ObjectMember> = if prefix.is_empty() {
                    obj_ref.members.values()
                } else {
                    obj_ref.members.find_by_prefix(prefix)
                };
                return Some(results);
            }
        } else {
            // obj is the last object found
            if let Some(part) = word {
                log::info!("finding function in object: {}", obj.borrow().name);
                let obj_ref = obj.borrow();
                if let Some(inc_obj) = &obj_ref.include_obj {
                    let inc_obj_ref = inc_obj.borrow();
                    if let Some(member) = inc_obj_ref.get_member(&part) {
                        if is_any_func(member.member_type.clone()) {
                            return self.get_refinements_from_member(&member);
                        }
                    }
                } else {
                    if let Some(member) = obj_ref.get_member(&part) {
                        if is_any_func(member.member_type.clone()) {
                            return self.get_refinements_from_member(&member);
                        }
                    }
                }
            }
        }
        None
    }

    fn parse_path_prefix(prefix: &str, current_dir: &Path) -> (PathBuf, String) {
        // Remove % prefix
        let prefix = prefix.trim_start_matches('%').trim_matches('"');
        if prefix.is_empty() {
            return (current_dir.to_path_buf(), String::new());
        }
        if prefix.ends_with("/") {
            let path = Self::red_path_to_pathbuf(prefix);
            if path.is_absolute() {
                return (path, String::new());
            } else {
                return (current_dir.join(path), String::new());
            }
        }

        // Handle Red language path format
        // %folder/file.red or %/C/folder/file.red (Windows)
        let path = Self::red_path_to_pathbuf(prefix);

        // Separate the directory part and the last part's name
        let partial = path.file_name()
            .unwrap_or_default()
            .to_string_lossy()
            .to_string();

        if path.is_absolute() {
            let base = path.parent()
                .unwrap_or(Path::new("/"))
                .to_path_buf();
            (base, partial)
        } else {
            let base = path.parent().unwrap_or(Path::new(""));
            (current_dir.join(base), partial)
        }
    }

    /// Convert Red language path format to Rust PathBuf
    /// Red paths start with % and use forward slashes
    ///
    /// On Windows:
    /// - `%/C/folder/file.red` → `C:\folder\file.red` (drive letter)
    /// - `%folder/file.red` → `folder\file.red` (relative)
    ///
    /// On Unix:
    /// - `%folder/file.red` → `folder/file.red` (relative)
    /// - `%/home/user/file.red` → `/home/user/file.red` (absolute)
    fn red_path_to_pathbuf(red_path: &str) -> PathBuf {
        // Remove leading slashes to normalize
        let path_str = red_path.trim_start_matches('/');

        // Check if this is a Windows drive letter path
        #[cfg(windows)]
        {
            if path_str.len() >= 1
                && path_str.chars().next().map(|c| c.is_ascii_alphabetic()).unwrap_or(false)
                && path_str.chars().nth(1) == Some('/')
            {
                // Drive letter without colon: C/folder → C:\folder
                let drive = path_str.chars().next().unwrap_or('C');
                let rest = &path_str[2..];
                let mut path = PathBuf::new();
                path.push(format!("{}:", drive));
                if !rest.is_empty() {
                    path.push(rest.replace('/', "\\"));
                }
                return path;
            } else {
                PathBuf::from(path_str.replace('/', "\\"))
            }
        }

        #[cfg(not(windows))]
        {
            // On Unix, preserve leading slash for absolute paths
            if red_path.starts_with('/') {
                PathBuf::from(red_path)
            } else {
                PathBuf::from(path_str)
            }
        }
    }

    fn collect_from_filesystem(base_path: &Path, partial: &str) -> Vec<PathCompletionItem> {
        let mut results = Vec::new();

        if let Ok(entries) = fs::read_dir(base_path) {
            for entry in entries.flatten() {
                let path = entry.path();
                let name = path.file_name().unwrap_or_default().to_string_lossy().to_string();

                // Skip hidden files
                if name == "." || name == ".." {
                    continue;
                }

                if partial.is_empty() || name.starts_with(partial) {
                    results.push(PathCompletionItem {
                        label: name.clone(),
                        is_dir: path.is_dir(),
                    });
                }
            }
        }

        results
    }

    fn red_file_to_uri(include_path: &Path, base_dir: &Path) -> (Option<Uri>, PathBuf) {
        // Resolve relative path
        let full_path = if include_path.is_absolute() {
            include_path.to_path_buf()
        } else {
            base_dir.join(include_path)
        };

        log::debug!("Attempting to parse include file: {:?}", full_path);

        let file_url = url::Url::from_file_path(&full_path).ok();
        if let Some(url) = file_url {
            let uri = serde_json::from_str::<lsp_types::Uri>(&format!("\"{}\"", url.as_str())).ok();
            return (uri, full_path);
        }
        (None, full_path)
    }

    /// Parse an include file and cache its content
    fn parse_include_file(&mut self, include_path: &Path, base_dir: &Path) -> Option<Uri> {
        let (uri, full_path) = Self::red_file_to_uri(include_path, base_dir);

        if let Some(uri) = uri {
            // Check if already cached or opened
            if self.include_cache.contains_key(&uri) {
                return Some(uri.clone());
            }
            if let Some(doc) = self.documents.get(&uri) {  // opened but not in include cache
                self.include_cache.insert(uri.clone(), doc.root_object.clone());
                return Some(uri.clone());
            }

            // Read and parse the file
            let content = match fs::read_to_string(&full_path) {
                Ok(content) => content,
                Err(e) => {
                    log::warn!("Failed to read include file {:?}: {}", full_path, e);
                    return None;
                }
            };

            let tree = self.parser.parse(&content, None);

            if tree.is_none() {
                log::warn!("Failed to parse include file: {:?}", full_path);
                return None;
            }

            log::debug!("Successfully parsed include file: {:?}", full_path);

            // Create a file URI from the path for collect_identifiers
            let obj = self.collect_identifiers(&content, &tree, &uri);
            self.include_cache.insert(uri.clone(), obj);
            return Some(uri);
        }
        None
    }

    // Recursive function to collect identifiers from the tree
    pub fn walk_tree(&mut self, source_code: &str, cursor: &mut TreeCursor, base_path: Option<&Path>) {
        // Pre-fetch node type IDs
        let kind_issue = self.get_kind_id("issue");
        let kind_file = self.get_kind_id("file");
        let kind_word = self.get_kind_id("word");
        let kind_set_word = self.get_kind_id("set_word");
        let kind_function = self.get_kind_id("function");
        let kind_does = self.get_kind_id("does");

        loop {
            let node = cursor.node();
            let kind_id = node.kind_id();

            // Check for include/import directives
            if kind_id == kind_issue && get_node_text(source_code, &node).unwrap_or("") == "#include" {
                if let Some(filepath) = node.next_sibling() {
                    if filepath.kind_id() == kind_file {
                        if let Some(include_path) = Self::extract_include_path(source_code, &filepath) {
                            log::debug!("include path: {:?}", include_path);
                            if let Some(base_dir) = base_path.and_then(|p| p.parent()) {
                                self.parse_include_file(&include_path, base_dir);
                            }
                        }
                    }
                }
            }

            // Check if this node is an identifier or function name
            if kind_id == kind_word || kind_id == kind_set_word {
                let mut text = get_node_text(source_code, &node).unwrap_or("");
                if kind_id == kind_set_word {
                    text = text.trim_end_matches(':');
                }
                self.symbols.insert(text);
            }

            // Highlight function definitions
            if kind_id == kind_function || kind_id == kind_does {
                if let Some(name_node) = node.child(0) {
                    if name_node.kind_id() == kind_set_word {
                        if let Some(text) = get_node_text(source_code, &name_node) {
                            let name = text.trim_end_matches(':');
                            self.functions.insert(CompactString::from(name));
                        }
                    }
                }
            }

            // Recurse into children
            if cursor.goto_first_child() {
                self.walk_tree(source_code, cursor, base_path);
                cursor.goto_parent();
            }

            if !cursor.goto_next_sibling() {
                break;
            }
        }
    }

    /// Extract the file path from an include directive node
    fn extract_include_path(source_code: &str, node: &tree_sitter::Node) -> Option<PathBuf> {
        if let Some(text) = get_node_text(source_code, node) {
            // Remove quotes and % prefix from Red path literals
            let path_str = text.trim_matches(|c| c == '"' || c == '%');
            return Some(Self::red_path_to_pathbuf(path_str));
        }
        None
    }

    pub fn collect_identifiers(&mut self, source_code: &str, tree: &Option<Tree>, file_uri: &Uri) -> Rc<RefCell<ObjectNode>> {
        if let Some(tree) = tree {
            let mut cursor = tree.walk();
            // Convert Uri to file path
            let base_path = Url::parse(file_uri.as_str())
                .ok()
                .and_then(|url| url.to_file_path().ok());

            self.walk_tree(source_code, &mut cursor, base_path.as_deref());

            // Reset cursor to collect object definitions
            cursor.reset(tree.root_node());

            // Collect object definitions
            self.collect_objects(source_code, &mut cursor, file_uri)
        } else {
            Rc::new(RefCell::new(ObjectNode::new()))
        }
    }

    /// Traverse syntax tree to collect object (context) definitions
    pub fn collect_objects(&mut self, source_code: &str, cursor: &mut TreeCursor, file_uri: &Uri) -> Rc<RefCell<ObjectNode>> {
        let obj = if let Some(old_obj) = self.include_cache.get(file_uri) {
            old_obj.clone()
        } else {
            Rc::new(RefCell::new(ObjectNode::new()))
        };
        {
            let mut obj_borrow = obj.borrow_mut();
            obj_borrow.members.clear();
            obj_borrow.byte_range = (0, source_code.len());
            let file_path = file_uri.to_string();
            obj_borrow.file_path = file_path.clone();
            obj_borrow.scope_path = file_path.clone();
            obj_borrow.name = file_path.clone();
            if cursor.goto_first_child() {
                let mut scope_stack: Vec<String> = Vec::new();
                scope_stack.push(file_path.clone());
                self.parse_object_body(source_code, file_uri, cursor , &mut scope_stack, &mut *obj_borrow);
            }
            self.object_graph.objects.insert(file_path, obj.clone());
        }
        obj
    }

    /// Extract member name from node's name field
    fn extract_member_name(source_code: &str, node: &tree_sitter::Node) -> String {
        let name_node = node.child_by_field_name("name").unwrap();
        let name = get_node_text(source_code, &name_node).unwrap();
        name.trim().trim_end_matches(':').to_string()
    }

    /// Traverse tree to collect objects and members
    /// scope_stack: Current scope stack, from outer to inner
    fn parse_object_body(
        &mut self,
        source_code: &str,
        uri: &Uri,
        cursor: &mut TreeCursor,
        scope_stack: &mut Vec<String>,
        scope: &mut ObjectNode
    ) {
        // Pre-fetch node type IDs
        let kind_make = self.get_kind_id("make");
        let kind_block = self.get_kind_id("block");
        let kind_word = self.get_kind_id("word");
        let kind_path = self.get_kind_id("path");
        let kind_set_word = self.get_kind_id("set_word");
        let kind_function = self.get_kind_id("function");
        let kind_does = self.get_kind_id("does");
        let kind_context = self.get_kind_id("context");
        let kind_issue = self.get_kind_id("issue");
        let kind_file = self.get_kind_id("file");

        loop {
            let node = cursor.node();
            let kind_id = node.kind_id();
            let mut member_type = MemberType::Value;
            let mut member_name = String::new();
            let mut spec_content = None;

            if kind_id == kind_set_word {
                let name = get_node_text(source_code, &node).unwrap();
                member_name = name.trim().trim_end_matches(':').to_string();
                if let Some(issue_node) = node.next_sibling() && issue_node.kind_id() == kind_issue &&
                    get_node_text(source_code, &issue_node).unwrap_or("") == "#include" &&
                    let Some(filepath) = issue_node.next_sibling() && filepath.kind_id() == kind_file &&
                    let Some(include_path) = Self::extract_include_path(source_code, &filepath) {
                    let base_path = Url::parse(uri.as_str())
                        .ok()
                        .and_then(|url| url.to_file_path().ok());
                    let base_dir = base_path.as_ref().and_then(|p| p.parent()).unwrap_or(Path::new("/"));
                    let (include_uri, _) = Self::red_file_to_uri(&include_path, base_dir);
                    scope_stack.push(member_name.clone());
                    let include_obj = if let Some(include_uri) = include_uri {
                        log::info!("get include obj: {}", format!("{}/{}", include_uri.as_str(), ANONYMOUS_OBJ));
                        let xx = self.object_graph.get(&format!("{}/{}", include_uri.as_str(), ANONYMOUS_OBJ));
                        log::info!("get include obj2: {:?}", xx);
                        xx.cloned()
                    } else {None};
                    self.object_graph.add_object(&member_name, scope_stack.join("/"),
                        ObjectNode {
                            name: member_name.clone(),
                            scope_path: scope_stack.join("/"),
                            byte_range: (node.start_byte(), filepath.end_byte()),
                            file_path: uri.to_string(),
                            include_obj,
                            ..Default::default()
                        });
                    member_type = MemberType::Object;
                    scope_stack.pop();
                    cursor.goto_next_sibling();
                    cursor.goto_next_sibling();
                }

            } else if kind_id == kind_make {
                member_name = Self::extract_member_name(source_code, &node);

                if let Some(spec) = node.next_sibling() && (spec.kind_id() == kind_word || spec.kind_id() == kind_path) {
                    let text = get_node_text(source_code, &spec).unwrap();
                    if let Some(blk) = spec.next_sibling() && blk.kind_id() == kind_block {
                        if self.object_graph.name_to_scopes.contains_key(text) || text == "object!" {
                            let mut obj = ObjectNode::new();
                            obj.byte_range = (node.start_byte(), blk.end_byte());
                            obj.file_path = uri.to_string();
                            scope_stack.push(member_name.clone());
                            obj.scope_path = scope_stack.join("/");
                            let mut body_cursor = blk.walk();
                            if body_cursor.goto_first_child() {
                                self.parse_object_body(source_code, uri, &mut body_cursor, scope_stack, &mut obj);
                            }
                            self.object_graph.add_object(&member_name, scope_stack.join("/"), obj);
                            member_type = MemberType::Object;
                            scope_stack.pop();
                        } else {
                            match text {
                                "function!" => member_type = MemberType::Function,
                                "native!" => member_type = MemberType::Native,
                                "action!" => member_type = MemberType::Action,
                                "routine!" => member_type = MemberType::Routine,
                                _ => member_type = MemberType::Value,
                            }
                            if member_type != MemberType::Value {
                                spec_content = get_node_text(source_code, &blk).map(|s| trim_brackets(s.trim()).to_string());
                            }
                        }
                        cursor.goto_next_sibling();
                        cursor.goto_next_sibling();
                    }
                }
            } else if kind_id == kind_function || kind_id == kind_does {
                member_name = Self::extract_member_name(source_code, &node);
                member_type = MemberType::Function;
                if let Some(spec_node) = node.child_by_field_name("spec") {
                    if spec_node.kind() == "block" {
                        spec_content = get_node_text(source_code, &spec_node).map(|s| trim_brackets(s.trim()).to_string());
                    }
                }
            } else if kind_id == kind_context {
                let mut obj = ObjectNode::new();
                obj.byte_range = (node.start_byte(), node.end_byte());
                obj.file_path = uri.to_string();

                member_name = Self::extract_member_name(source_code, &node);
                scope_stack.push(member_name.clone());
                obj.scope_path = scope_stack.join("/");

                if let Some(body_node) = node.child_by_field_name("body") {
                    let mut body_cursor = body_node.walk();
                    if body_cursor.goto_first_child() {
                        self.parse_object_body(source_code, uri, &mut body_cursor, scope_stack, &mut obj);
                    }
                }
                self.object_graph.add_object(&member_name, scope_stack.join("/"), obj);
                member_type = MemberType::Object;
                scope_stack.pop();
            } else if kind_id == kind_issue && get_node_text(source_code, &node).unwrap_or("") == "#include" &&
                let Some(file_node) = node.next_sibling() && file_node.kind_id() == kind_file &&
                let Some(include_path) = Self::extract_include_path(source_code, &file_node) {
                // add file content into current context
                let base_path = Url::parse(uri.as_str())
                    .ok()
                    .and_then(|url| url.to_file_path().ok());
                let base_dir = base_path.as_ref().and_then(|p| p.parent()).unwrap_or(Path::new("/"));
                let (include_uri, _) = Self::red_file_to_uri(&include_path, base_dir);
                if let Some(include_uri) = include_uri {
                     if let Some(obj) = self.include_cache.get(&include_uri) {
                         let borrowed = obj.borrow();
                         for (key, value) in borrowed.members.iter() {
                             if value.member_type == MemberType::Object {
                                 scope_stack.push(key.clone());
                                 let empty_scope = Rc::new(RefCell::new(ObjectNode::new()));
                                 let include_obj = self.object_graph.find_child_object(&empty_scope, &key).cloned();
                                 self.object_graph.add_object(&key, scope_stack.join("/"),
                                     ObjectNode {
                                         name: member_name.clone(),
                                         scope_path: scope_stack.join("/"),
                                         byte_range: (node.start_byte(), file_node.end_byte()),
                                         file_path: include_uri.to_string(),
                                         include_obj,
                                         ..Default::default()
                                     });
                                 scope_stack.pop();
                             }
                             scope.members.insert(&key, value.clone());
                         }
                     }
                 }
                 cursor.goto_next_sibling();
            } else if kind_id == kind_word && let Some(blk) = node.next_sibling() && blk.kind_id() == kind_block {
                // case: object []
                let name = get_node_text(source_code, &node).unwrap_or("");
                if name == "context" || name == "object" {
                    let mut obj = ObjectNode::new();
                    obj.byte_range = (node.start_byte(), blk.end_byte());
                    obj.file_path = uri.to_string();
                    member_name = ANONYMOUS_OBJ.to_string();
                    scope_stack.push(member_name.clone());
                    obj.scope_path = scope_stack.join("/");
                    let mut body_cursor = blk.walk();
                    if body_cursor.goto_first_child() {
                        self.parse_object_body(source_code, uri, &mut body_cursor, scope_stack, &mut obj);
                    }
                    log::info!("add anonymous obj {}", scope_stack.join("/"));
                    self.object_graph.add_object(&member_name, scope_stack.join("/"), obj);
                    member_type = MemberType::Object;
                    scope_stack.pop();
                    cursor.goto_next_sibling();
                }
            }

            if !member_name.is_empty() {
                let name = CompactString::from(&member_name);
                let node_start = node.start_byte();
                let node_end = node.end_byte();

                if let Some(spec) = &spec_content && spec.is_empty() {
                    spec_content = None;
                }
                // Insert with case-insensitive key, store object_path for fast lookup in resolve
                scope.members.insert(
                    &member_name,
                    ObjectMember {
                        name,
                        member_type,
                        spec_content,
                        byte_range: Some((node_start, node_end)),
                        object_path: Some(scope.scope_path.clone())
                    }
                );
            }
            if !cursor.goto_next_sibling() {
                break;
            }
        }
    }

    pub fn get_semantic_tokens(&self, content: &Rope, tree: &Option<Tree>) -> Vec<SemanticToken> {
        self.get_semantic_tokens_in_range(content, tree, None)
    }

    pub fn get_semantic_tokens_in_range(
        &self,
        content: &Rope,
        tree: &Option<Tree>,
        range: Option<lsp_types::Range>,
    ) -> Vec<SemanticToken> {
        let mut tokens: Vec<(u32, u32, u32, u32, u32)> = Vec::new();

        if let Some(tree) = tree {
            let source_code = content.to_string();
            let mut cursor = tree.walk();
            self.collect_function_tokens(&source_code, &mut cursor, &mut tokens, range);
        }

        encode_semantic_tokens(tokens)
    }

    fn collect_function_tokens(
        &self,
        source_code: &str,
        cursor: &mut TreeCursor,
        tokens: &mut Vec<(u32, u32, u32, u32, u32)>,
        range: Option<lsp_types::Range>,
    ) {
        let kind_word = self.get_kind_id("word");
        let kind_path = self.get_kind_id("path");
        loop {
            let node = cursor.node();
            let kind_id = node.kind_id();
            let mut should_goto_child = true;

            // Handle path nodes: obj/func/ref
            if kind_id == kind_path {
                // Skip if outside requested range
                if let Some(r) = range {
                    let start_line = node.start_position().row as u32;
                    if start_line < r.start.line || start_line > r.end.line {
                        if !cursor.goto_next_sibling() {
                            break;
                        }
                        continue;
                    }
                }
                if let Some(path) = &self.current_uri {
                   self.highlight_path_nodes(source_code, &node, tokens, path.as_str());
                }
                should_goto_child = false;
            }

            // Also highlight word nodes as references
            if kind_id == kind_word {
                if let Some(text) = get_node_text(source_code, &node) {
                    let start_line = node.start_position().row as u32;

                    // Skip if outside requested range
                    if let Some(r) = range {
                        if start_line < r.start.line || start_line > r.end.line {
                            if !cursor.goto_next_sibling() {
                                break;
                            }
                            continue;
                        }
                    }

                    let start_col = node.start_position().column as u32;
                    let end_line = node.end_position().row as u32;
                    let end_col = node.end_position().column as u32;

                    // Check if this word is a known function
                    let normalized = CompactString::from(text.to_lowercase());
                    if self.functions.contains(&normalized) {
                        // Token type index: 0 = FUNCTION (matches legend order in capabilities)
                        let token_type = 0u32;
                        let token_modifiers = 0u32;
                        let length = if start_line == end_line {
                            end_col - start_col
                        } else {
                            1
                        };
                        tokens.push((start_line, start_col, length, token_type, token_modifiers));
                    }
                }
            }

            // Recurse into children
            if should_goto_child && cursor.goto_first_child() {
                self.collect_function_tokens(source_code, cursor, tokens, range);
                cursor.goto_parent();
            }

            if !cursor.goto_next_sibling() {
                break;
            }
        }
    }

    /// Highlight each word in a path node with appropriate semantic token type
    /// Path format: obj1/obj2/func/ref
    fn highlight_path_nodes(
        &self,
        source_code: &str,
        path_node: &tree_sitter::Node,
        tokens: &mut Vec<(u32, u32, u32, u32, u32)>,
        file_path: &str,
    ) {
        let mut cursor = path_node.walk();
        if !cursor.goto_first_child() {
            return;
        }

        let path_start = cursor.node();
        let start_word = get_node_text(source_code, &path_start).unwrap_or("");
log::info!("highlight Path node: start_word {}", start_word);
        let (obj, member) = self.find_obj(start_word, path_start.start_byte(), file_path);
        if let Some(xx) = &obj {
        log::info!("highlight Path node: obj {}", xx.borrow().name);
        }else {
            if let Some(yy) = &member {
                log::info!("highlight path member: {}", yy.name);
            } else {
                log::info!("highlight path none")
            }
        }
        let start_col = path_start.start_position().column as u32;
        let end_col = path_start.end_position().column as u32;
        let length = end_col - start_col - 1; // remove last "/"
        if let Some(m) = &member {
            log::info!("highlight path member2: {:?}", m);
            if is_any_func(m.member_type.clone()) {
                tokens.push((path_start.start_position().row as u32, start_col, length, TokenType::RedFunction as u32, 0));
                return;
            }
        }
        // Collect all word nodes in the path
        let kind_word = self.get_kind_id("word");
        let mut path_parts: Vec<(tree_sitter::Node, String)> = Vec::new();

        loop {
            let node = cursor.node();
            log::info!("node kind: {}", node.kind());
            if node.kind_id() == kind_word {
                if let Some(text) = get_node_text(source_code, &node) {
                    path_parts.push((node, text.to_string()));
                }
            }
            if !cursor.goto_next_sibling() {
                break;
            }
        }

        if path_parts.is_empty() {
            log::info!("empty path_parts!!!!!!!!!!!");
            return;
        }

        if let Some(obj) = obj {
            // Use include_obj if available, otherwise use obj
            let mut ctx = obj.borrow().include_obj.clone().unwrap_or_else(|| obj.clone());
            //tokens.push((path_start.start_position().row as u32, start_col, length, TokenType::RedCtx as u32, 0));
            let mut check = true;
            for (part_node, part) in path_parts.iter() {
                let mut token_type = TokenType::RedVariable;
                log::info!("highlight path part: {}", part);
                if check && let Some(member) = ctx.borrow().get_member(part) {
                    log::info!("highlight path member3: {:?}", member);
                    match member.member_type {
                        MemberType::Function => token_type = TokenType::RedFunction,
                        MemberType::Object => token_type = TokenType::RedCtx,
                        MemberType::Native => token_type = TokenType::RedKeyword,
                        MemberType::Action => token_type = TokenType::RedKeyword,
                        MemberType::Routine => token_type = TokenType::RedKeyword,
                        MemberType::Value => token_type = TokenType::RedVariable,
                    }
                }

                let start_col = part_node.start_position().column as u32;
                let end_col = part_node.end_position().column as u32;
                let length = end_col - start_col;

                if token_type == TokenType::RedCtx {
                    log::info!("highlight check: {}", format!("{}/{}", ctx.borrow().scope_path, part));
                    if let Some(obj) = self.object_graph.get(&format!("{}/{}", ctx.borrow().scope_path, part)) {
                        ctx = obj.borrow().include_obj.clone().unwrap_or_else(|| obj.clone());
                    } else {
                        check = false;
                    }
                    token_type = TokenType::RedVariable;
                }
                if token_type == TokenType::RedFunction {
                    check = false;
                }
                tokens.push((part_node.start_position().row as u32, start_col, length, token_type.clone() as u32, 0));
            }
        }
    }
}

#[derive(Debug, Clone)]
pub enum Symbol {
    /// Zero extra heap allocation: uses the key already in the Trie
    SameAsKey,
    /// Stores a different casing (e.g. "Abc") inline if <= 24 chars
    Different(CompactString),
    /// Heap-allocated only when 3+ variations exist
    Multiple(Box<Vec<CompactString>>),
}

impl Symbol {
    fn add(&mut self, word: &str, key: &str) {
        match self {
            Symbol::SameAsKey if word != key => {
                let mut list = Vec::with_capacity(2);
                list.push(CompactString::from(key));
                list.push(CompactString::from(word));
                *self = Symbol::Multiple(Box::new(list));
            }
            Symbol::Different(existing) if existing != word => {
                let mut list = Vec::with_capacity(2);
                list.push(existing.clone());
                list.push(CompactString::from(word));
                *self = Symbol::Multiple(Box::new(list));
            }
            Symbol::Multiple(list) => {
                if !list.iter().any(|s| s == word) {
                    list.push(CompactString::from(word));
                }
            }
            _ => {}
        }
    }

    /// Get the original word from the symbol
    fn get_word(&self, key: &str) -> String {
        match self {
            Symbol::SameAsKey => key.to_string(),
            Symbol::Different(s) => s.to_string(),
            Symbol::Multiple(list) => list.first().map(|s| s.to_string()).unwrap_or_else(|| key.to_string()),
        }
    }
}

/// Symbol table with case-insensitive lookup for string storage
#[derive(Debug, Clone)]
pub struct Symbols {
    map: StringRadixMap<Symbol>,
}

impl Symbols {
    pub fn new() -> Self {
        Self {
            map: StringRadixMap::new(),
        }
    }

    pub fn insert(&mut self, word: &str) {
        let key = word.to_lowercase();
        self.map
            .entry(key.clone())
            .and_modify(|v| v.add(word, &key))
            .or_insert_with(|| {
                if word == key {
                    Symbol::SameAsKey
                } else {
                    Symbol::Different(CompactString::from(word))
                }
            });
    }

    /// Get value by exact or case-insensitive match (returns the original word)
    pub fn get(&self, word: &str) -> Option<String> {
        let key = word.to_lowercase();
        self.map.get(&key).map(|s| s.get_word(&key))
    }

    /// Check if key exists (case-insensitive)
    pub fn contains_key(&self, word: &str) -> bool {
        let key = word.to_lowercase();
        self.map.contains_key(&key)
    }

    /// Find all values by prefix (case-insensitive)
    pub fn find_by_prefix(&self, prefix: &str) -> Vec<String> {
        let normalized = prefix.to_lowercase();
        let mut results = Vec::new();

        for (key, symbol) in self.map.iter_prefix(&normalized) {
            results.push(symbol.get_word(&key));
        }
        results
    }

    /// Get all values (returns original words)
    pub fn values(&self) -> Vec<String> {
        self.map.iter().map(|(k, s)| s.get_word(&k)).collect()
    }

    /// Clear all entries
    pub fn clear(&mut self) {
        self.map.clear();
    }
}

impl Default for Symbols {
    fn default() -> Self {
        Self::new()
    }
}

/// Generic symbol map with case-insensitive lookup and value storage
#[derive(Debug, Clone)]
pub struct SymbolsMap<T> {
    map: StringRadixMap<(Symbol, T)>,
}

impl<T: Clone> SymbolsMap<T> {
    pub fn new() -> Self {
        Self {
            map: StringRadixMap::new(),
        }
    }

    pub fn insert(&mut self, word: &str, value: T) {
        let key = word.to_lowercase();
        self.map
            .entry(key.clone())
            .and_modify(|(sym, _)| sym.add(word, &key))
            .or_insert_with(|| {
                let sym = if word == key {
                    Symbol::SameAsKey
                } else {
                    Symbol::Different(CompactString::from(word))
                };
                (sym, value)
            });
    }

    /// Get value by exact or case-insensitive match
    pub fn get(&self, word: &str) -> Option<T> {
        let key = word.to_lowercase();
        self.map.get(&key).map(|(_, v)| v.clone())
    }

    /// Check if key exists (case-insensitive)
    pub fn contains_key(&self, word: &str) -> bool {
        let key = word.to_lowercase();
        self.map.contains_key(&key)
    }

    /// Find all values by prefix (case-insensitive)
    pub fn find_by_prefix(&self, prefix: &str) -> Vec<T> {
        let normalized = prefix.to_lowercase();
        self.map
            .iter_prefix(&normalized)
            .map(|(_, (_, v))| v.clone())
            .collect()
    }

    /// Get all values
    pub fn values(&self) -> Vec<T> {
        self.map.values().map(|(_, v)| v.clone()).collect()
    }

    /// Iterate over all entries, returning (original_word, value) pairs
    pub fn iter(&self) -> Vec<(String, T)> {
        self.map.iter().map(|(k, (s, v))| (s.get_word(&k), v.clone())).collect()
    }

    /// Clear all entries
    pub fn clear(&mut self) {
        self.map.clear();
    }
}

impl<T: Clone> Default for SymbolsMap<T> {
    fn default() -> Self {
        Self::new()
    }
}

fn encode_semantic_tokens(tokens: Vec<(u32, u32, u32, u32, u32)>) -> Vec<SemanticToken> {
    // LSP semantic tokens use delta encoding:
    // Each token is 5 u32 values: delta_line, delta_start, length, token_type, token_modifiers
    // delta_line = token_line - previous_token_line
    // delta_start = token_start - previous_token_start (if same line, else just token_start)

    let mut result: Vec<SemanticToken> = Vec::with_capacity(tokens.len());
    let mut prev_line = 0u32;
    let mut prev_start = 0u32;

    for (start_line, start_col, length, token_type, token_modifiers) in tokens {
        let delta_line = start_line - prev_line;
        let delta_start = if delta_line == 0 {
            start_col - prev_start
        } else {
            start_col
        };

        result.push(SemanticToken {
            delta_line,
            delta_start,
            length,
            token_type,
            token_modifiers_bitset: token_modifiers,
        });

        prev_line = start_line;
        prev_start = start_col;
    }

    result
}

pub fn is_any_func(t: MemberType) -> bool {
    t == MemberType::Action || t == MemberType::Function || t == MemberType::Native || t == MemberType::Routine
}

pub fn trim_brackets(s: &str) -> &str {
    let mut start = 0;
    let mut end = s.len();

    // Count leading '['
    let leading = s.chars().take_while(|&c| c == '[').count();

    // Advance start
    start += leading;

    // Reduce end by same number of trailing ']'
    let trailing = s.chars().rev().take_while(|&c| c == ']').count();
    let remove = leading.min(trailing);
    end -= remove;

    &s[start..end]
}
