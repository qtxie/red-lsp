use hashbrown::{HashMap, HashSet};
use lsp_types::{SemanticToken, Uri};
use ropey::Rope;
use tree_sitter::{Tree, TreeCursor};
use compact_str::CompactString;
use fast_radix_trie::StringRadixMap;
use std::fs;
use std::path::{Path, PathBuf};
use url::Url;
use std::collections::BTreeMap;
use std::rc::Rc;
use std::cell::RefCell;

pub const ANONYMOUS_OBJ: &str = "$anonymous$";

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

/// 路径补全项
#[derive(Debug, Clone)]
pub struct PathCompletionItem {
    pub label: String,
    pub is_dir: bool,
}

/// 对象成员类型
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum MemberType {
    Value,      // 普通值（数字、字符串等）
    Function,   // 函数
    Object,     // 嵌套对象（context）
    Native,
    Action,
    Routine,
}

/// 对象成员 - 使用 CompactString 存储名称
#[derive(Debug, Clone)]
pub struct ObjectMember {
    pub name: CompactString,
    pub member_type: MemberType,
    /// 如果是函数，存储其 spec 内容（参数和 refinements）
    pub spec_content: Option<String>,
}

/// 对象节点，表示一个 context 对象
#[derive(Debug, Default, Clone)]
pub struct ObjectNode {
    pub name: String,                    // 对象名称（如 "a"）
    pub scope_path: String,              // 完整作用域路径（如 "a/b/a"）
    pub members: StringRadixMap<ObjectMember>,
    pub byte_range: (usize, usize),      // 对象在源代码中的字节范围
    pub file_path: String,
    pub include_obj: Option<Rc<RefCell<ObjectNode>>>    // link to another object
}

impl ObjectNode {
    pub fn new() -> Self {
        Self {
            name: String::new(),
            scope_path: String::new(),
            members: StringRadixMap::new(),
            ..Default::default()
        }
    }
}

/// 对象图，存储所有定义的对象及其成员
#[derive(Debug)]
pub struct ObjectGraph {
    /// 作用域路径 -> 对象节点
    pub objects: HashMap<String, Rc<RefCell<ObjectNode>>>,
    /// 对象名称 -> 该名称的所有对象作用域路径 (使用 HashSet 加速移除)
    pub name_to_scopes: HashMap<String, HashSet<String>>,
    /// 有序映射，用于快速查找字节位置所在的作用域 (start_byte -> scope_path)
    range_map: BTreeMap<usize, String>,
    /// 文件路径 -> 该文件中的所有对象作用域路径，用于快速移除
    file_to_scopes: HashMap<String, Vec<String>>,
    /// 作用域路径 -> 对象名称，用于快速从 name_to_scopes 中移除
    scope_to_name: HashMap<String, String>,
}

impl ObjectGraph {
    pub fn new() -> Self {
        Self {
            objects: HashMap::new(),
            name_to_scopes: HashMap::new(),
            range_map: BTreeMap::new(),
            file_to_scopes: HashMap::new(),
            scope_to_name: HashMap::new(),
        }
    }

    pub fn get(&self, path: &str) -> Option<&Rc<RefCell<ObjectNode>>> {
        self.objects.get(path)
    }
    /// 添加对象
    pub fn add_object(&mut self, name: &String, scope_path: String, obj: ObjectNode) {
        let mut obj = obj;
        obj.scope_path = scope_path.clone();
        obj.name = name.clone();
        let file_path = obj.file_path.clone();

        // 记录名称到作用域的映射 (使用 HashSet)
        self.name_to_scopes.entry(name.clone()).or_insert_with(HashSet::new).insert(scope_path.clone());
        // 同时插入到 range_map 中，用于快速查找
        self.range_map.insert(obj.byte_range.0, scope_path.clone());
        // 记录文件到作用域的映射，用于快速移除
        self.file_to_scopes.entry(file_path).or_insert_with(Vec::new).push(scope_path.clone());
        // 记录作用域到名称的映射，用于快速从 name_to_scopes 中移除
        self.scope_to_name.insert(scope_path.clone(), name.clone());
        self.objects.insert(scope_path, Rc::new(RefCell::new(obj)));
    }

    /// 根据字节位置查找当前所在的作用域（从内到外）
    pub fn find_scopes_at_position(&self, byte_pos: usize) -> Vec<&Rc<RefCell<ObjectNode>>> {
        // 使用 range_map 快速查找：找到所有 start_byte <= byte_pos 的作用域
        // 然后过滤出 end_byte >= byte_pos 的作用域
        // range(..=byte_pos).rev() 从后往前遍历，已经是内层作用域在前，无需再排序
        self.range_map
            .range(..=byte_pos)
            .rev()
            .filter_map(|(_, scope_path)| {
                self.objects.get(scope_path).filter(|obj| byte_pos <= obj.borrow().byte_range.1)
            })
            .collect()
    }

    /// 移除文件相关的所有对象 - O(k) 时间复杂度，k 为该文件的对象数量
    pub fn remove_objects_by_file(&mut self, file_path: &str) {
        // 直接从 file_to_scopes 获取该文件的所有作用域
        let scopes_to_remove = match self.file_to_scopes.remove(file_path) {
            Some(scopes) => scopes,
            None => return,  // 文件不存在，直接返回
        };

        // 移除对象并从 name_to_scopes 中移除
        for scope_path in &scopes_to_remove {
            self.objects.remove(scope_path);
            // 通过 scope_to_name 直接找到对应的名称，然后从 name_to_scopes 中移除
            if let Some(name) = self.scope_to_name.remove(scope_path) {
                if let Some(scopes) = self.name_to_scopes.get_mut(&name) {
                    scopes.remove(scope_path);
                    // 如果该名称下没有作用域了，删除该条目
                    if scopes.is_empty() {
                        self.name_to_scopes.remove(&name);
                    }
                }
            }
        }

        // 重建 range_map
        self.rebuild_range_map();
    }

    /// 重建 range_map
    fn rebuild_range_map(&mut self) {
        self.range_map.clear();
        for (scope_path, obj) in &self.objects {
            self.range_map.insert(obj.borrow().byte_range.0, scope_path.clone());
        }
    }

    /// 解析对象路径并找到对应的对象
    /// path: "a" 或 "a/b" 等
    /// current_scope: 当前所在的作用域路径
    pub fn resolve_object_path(&self, path: &str, current_scope: &str) -> (Option<&Rc<RefCell<ObjectNode>>>, bool, Option<String>) {
        // 将路径分割为部分
        let parts: Vec<&str> = path.split('/').filter(|s| !s.is_empty()).collect();
        if parts.is_empty() {
            return (None, false, None);
        }

        // 从当前作用域开始查找
        let mut current_path = current_scope.to_string();
        let mut parent_obj: Option<&Rc<RefCell<ObjectNode>>> = None;

        for (i, part) in parts.iter().enumerate() {
            // 查找在当前路径下名为 part 的对象
            let found = self.find_child_object(&current_path, part);

            if let Some(obj) = found {
                log::info!("resolve_object_path find: {} - {}", part, i);
                if i == parts.len() - 1 {
                    // 最后一个部分，返回对象
                    return (Some(obj), true, None);
                }
                parent_obj = found;
                current_path = obj.borrow().scope_path.clone();
            } else {
                // part might be a function
                return (parent_obj, false, Some(part.to_string()));
            }
        }

        (None, false, None)
    }

    /// 在指定作用域下查找子对象
    fn find_child_object(&self, parent_scope: &str, child_name: &str) -> Option<&Rc<RefCell<ObjectNode>>> {
        // 获取所有同名对象
        let scopes = self.name_to_scopes.get(child_name)?;
        log::info!("find_child_object: {} -- {:?}", child_name, scopes);
        // 查找父作用域匹配的对象
        for scope in scopes {
            // 检查是否是直接子对象
            if scope == child_name && parent_scope.is_empty() {
                // 顶层对象
                return self.objects.get(scope);
            }

            // 检查父作用域是否匹配
            if let Some(parent_end) = scope.rfind('/') {
                let parent = &scope[..parent_end];
                if parent == parent_scope {
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
    pub object_graph: ObjectGraph,  // 对象图
    /// 节点类型 ID 缓存，避免重复字符串比较
    pub node_kind_ids: HashMap<&'static str, u16>,
    pub builtin_ctx: Rc<RefCell<ObjectNode>>,
    pub current_uri: Option<Uri>
}

impl Ctx {
    pub fn new() -> Self {
        let mut parser = tree_sitter::Parser::new();
        let lang = tree_sitter_red::LANGUAGE;
        parser.set_language(&lang.into()).expect("Failed to set language");

        // 预获取所有节点类型的 kind_id
        let mut node_kind_ids = HashMap::new();
        let lang: tree_sitter::Language = lang.into();
        for kind_name in [
            "issue", "file", "make", "word", "set_word", "function", "does", "context",
            "block", "path", "set_path"] {
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

    /// 快速获取节点类型 ID
    #[inline]
    fn get_kind_id(&self, kind_name: &str) -> u16 {
        *self.node_kind_ids.get(kind_name).unwrap_or(&0)
    }

    /// 解析单行文本并提取符号
    pub fn parse_line_and_insert_symbols(&mut self, line_text: &str) {
        let tree = self.parser.parse(line_text, None);
        if let Some(tree) = tree {
            let mut cursor = tree.walk();
            self.walk_tree(line_text, &mut cursor, None);
        }
    }


    /// 从定义位置获取 refinements
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

    /// 从 spec 块中提取 refinements
    fn extract_refinements_from_block(&self, source_code: &str, block_node: tree_sitter::Node) -> Option<Vec<ObjectMember>> {
        let mut cursor = block_node.walk();
        if cursor.goto_first_child() {
            let mut results = Vec::new();
            loop {
                let node = cursor.node();
                if node.kind() == "refinement" {
                    if let Some(text) = get_node_text(source_code, &node) {
                        let ref_name = text.trim_start_matches('/');
                        if !ref_name.is_empty() {
                            results.push(ObjectMember {
                                name: CompactString::from(ref_name),
                                member_type: MemberType::Value,
                                spec_content: None
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
    /// 获取路径补全建议（实时从文件系统读取）
    pub fn get_path_completions(&self, prefix: &str, file_uri: &Uri) -> Vec<PathCompletionItem> {
        // 获取文件所在目录
        let current_dir = Url::parse(file_uri.as_str())
            .ok()
            .and_then(|url| url.to_file_path().ok())
            .and_then(|path| path.parent().map(|p| p.to_path_buf()))
            .unwrap_or_else(|| PathBuf::from("."));

        // 解析前缀，移除 % 前缀并获取基础路径和待补全部分
        let (base_path, partial) = Self::parse_path_prefix(prefix, &current_dir);

        log::info!("base path {:?}, partial {}", base_path, partial);
        // 直接从文件系统读取
        Self::collect_from_filesystem(&base_path, &partial)
    }

    /// 查找对象成员补全
    pub fn find_members(&self, object_path: &str, current_byte_pos: usize, prefix: &str) -> Vec<ObjectMember> {
        // 首先找到当前光标所在的作用域
        let scopes = self.object_graph.find_scopes_at_position(current_byte_pos);

        // 尝试从当前作用域解析对象路径
        for scope in &scopes {
            let scope_path = scope.borrow().scope_path.clone();
            match self.get_members_or_refiments(object_path, prefix, &scope_path) {
                Some(results) => return results,
                None => break,
            }
        }
        // find in global scope
        Vec::new()
    }

    pub fn find_obj(&self, word: &str, start_byte: usize) -> (Option<ObjectNode>, bool) {
        // 首先从 object_graph 查找
        // 首先找到当前光标所在的作用域
        let scopes = self.object_graph.find_scopes_at_position(start_byte);

        // 尝试从当前作用域解析对象路径
        for scope in &scopes {
            let scope_path = scope.borrow().scope_path.clone();
            let (obj, is_found, _) = self.object_graph.resolve_object_path(word, &scope_path);
            if is_found {
                return (obj.map(|v| v.borrow().clone()), false);
            }
        }
        // 从 document 的 root_object 查找
        if let Some(uri) = &self.current_uri {
            if let Some(document) = self.documents.get(uri) {
                let root_obj = document.root_object.borrow();
                let (obj, is_found, _) = self.object_graph.resolve_object_path(word, &root_obj.name);
                if is_found {
                    return (obj.map(|v| v.borrow().clone()), false);
                } else {
                    if let Some(member) = root_obj.members.get(word) && member.member_type == MemberType::Function {
                       return (None, true);
                    }
                }
            }
        }

        // 从 builtin_ctx 查找
        let builtin = self.builtin_ctx.borrow();
        let (obj, is_found, _) = self.object_graph.resolve_object_path(word, &builtin.name);
        if is_found {
            return (obj.map(|v| v.borrow().clone()), false);
        } else {
            if let Some(member) = builtin.members.get(word) && member.member_type == MemberType::Function {
                return (None, true);
            }
        }
        (None, false)
    }

    /// 获取对象成员补全
    pub fn get_object_completions(&self, object_path: &str, current_byte_pos: usize, prefix: &str, file_uri: &Uri) -> Vec<ObjectMember> {
        // 首先从 object_graph 查找
        let results = self.find_members(object_path, current_byte_pos, prefix);
        if !results.is_empty() {
            return results;
        }

        // 从 document 的 root_object 查找
        log::info!("get from opened file");
        if let Some(document) = self.documents.get(file_uri) {
            let root_obj = document.root_object.borrow();
            if let Some(results) = self.get_members_from_object(object_path, prefix, &*root_obj) {
                log::info!("current doc result: {:?}", results);
                return results;
            }
        }

        // 从 builtin_ctx 查找
        log::info!("get from builtin");
        let builtin = self.builtin_ctx.borrow();
        if let Some(results) = self.get_members_from_object(object_path, prefix, &*builtin) {
            log::info!("builtin result: {:?}", results);
            return results;
        }

        Vec::new()
    }

    fn is_any_func(t: MemberType) -> bool {
        t == MemberType::Action || t == MemberType::Function || t == MemberType::Native
    }
    /// 从指定对象中获取成员补全
    fn get_members_from_object(&self, object_path: &str, prefix: &str, root_object: &ObjectNode) -> Option<Vec<ObjectMember>> {
        let parts: Vec<&str> = object_path.split('/').filter(|s| !s.is_empty()).collect();
        if let Some(name) = parts.first() {
            if root_object.members.contains_key(name) {
                if let Some(results) = self.get_members_or_refiments(object_path, prefix, &root_object.name) {
                   return Some(results);
                } else {
                    // try to find it in root_object
                    log::info!("finding it in root");
                    if let Some(member) = root_object.members.get(name) && Self::is_any_func(member.member_type.clone()) {
                       return self.get_refinements_from_member(member);
                    }
                }
            }
        }
        None
    }

    fn get_members_or_refiments(&self, object_path: &str, prefix: &str, scope_path: &str) -> Option<Vec<ObjectMember>> {
        let (obj, is_found, word) = self.object_graph.resolve_object_path(object_path, scope_path);
        log::info!("is found?: {}", is_found);
        if is_found {
            let obj = obj.unwrap();
            let obj_ref = obj.borrow();
            if let Some(obj) = &obj_ref.include_obj {
                let results : Vec<ObjectMember> = if prefix.is_empty() {
                    obj.borrow().members.values().cloned().collect()
                } else {
                    obj.borrow().members.common_prefix_values(prefix).cloned().collect()
                };
                return Some(results);
            } else {
                let results : Vec<ObjectMember> = if prefix.is_empty() {
                    obj_ref.members.values().cloned().collect()
                } else {
                    obj_ref.members.common_prefix_values(prefix).cloned().collect()
                };
                return Some(results);
            }
        } else {
            // obj is the last object found
            if let Some(obj) = obj {
                let part = word.unwrap();
                log::info!("finding function in object");
                let obj_ref = obj.borrow();
                if let Some(obj) = &obj_ref.include_obj {
                    let obj_ref = obj.borrow();
                    if let Some(member) = obj_ref.members.get(part.clone()) && Self::is_any_func(member.member_type.clone()) {
                        return self.get_refinements_from_member(member);
                    }
                }{
                    if let Some(member) = obj_ref.members.get(part) && Self::is_any_func(member.member_type.clone()) {
                        return self.get_refinements_from_member(member);
                    }
                }
            }
        }
        None
    }

    fn parse_path_prefix(prefix: &str, current_dir: &Path) -> (PathBuf, String) {
        // 移除 % 前缀
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

        // 处理 Red 语言路径格式
        // %folder/file.red 或 %/C/folder/file.red (Windows)
        let path = Self::red_path_to_pathbuf(prefix);

        // 分离目录部分和最后一部分的名称
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

                // 跳过隐藏文件
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
        // 预获取节点类型 ID
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

            // 重置 cursor 收集对象定义
            cursor.reset(tree.root_node());

            // 收集对象定义
            self.collect_objects(source_code, &mut cursor, file_uri)
        } else {
            Rc::new(RefCell::new(ObjectNode::new()))
        }
    }

    /// 遍历语法树收集对象（context）定义
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
            if cursor.goto_first_child() {
                let mut scope_stack: Vec<String> = Vec::new();
                scope_stack.push(file_path.clone());
                self.parse_object_body(source_code, file_uri, cursor , &mut scope_stack, &mut *obj_borrow);
            }
            obj_borrow.file_path = file_path.clone();
            obj_borrow.name = file_path;
        }
        obj
    }

    /// 从节点的 name 字段提取成员名称
    fn extract_member_name(source_code: &str, node: &tree_sitter::Node) -> String {
        let name_node = node.child_by_field_name("name").unwrap();
        let name = get_node_text(source_code, &name_node).unwrap();
        name.trim().trim_end_matches(':').to_string()
    }

    /// 遍历树收集对象和成员
    /// scope_stack: 当前作用域栈，从外到内
    fn parse_object_body(
        &mut self,
        source_code: &str,
        uri: &Uri,
        cursor: &mut TreeCursor,
        scope_stack: &mut Vec<String>,
        scope: &mut ObjectNode
    ) {
        // 预获取节点类型 ID
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
                        self.object_graph.get(&format!("{}/{}", include_uri.as_str(), ANONYMOUS_OBJ)).cloned()
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
                                spec_content = get_node_text(source_code, &blk).map(|s| s.trim().trim_start_matches("[").trim_end_matches("]").to_string());
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
                        spec_content = get_node_text(source_code, &spec_node).map(|s| s.trim().trim_start_matches("[").trim_end_matches("]").to_string());
                    }
                }
            } else if kind_id == kind_context {
                let mut obj = ObjectNode::new();
                obj.byte_range = (node.start_byte(), node.end_byte());
                obj.file_path = uri.to_string();

                member_name = Self::extract_member_name(source_code, &node);
                scope_stack.push(member_name.clone());

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
                         for (key, value) in obj.borrow().members.iter() {
                             if value.member_type == MemberType::Object {
                                 scope_stack.push(key.clone());
                                 let include_obj = self.object_graph.find_child_object(&include_uri.to_string(), &key).cloned();
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
                             scope.members.insert(key.clone(), value.clone());
                         }
                     }
                 }
                 cursor.goto_next_sibling();
            } else if kind_id == kind_word && let Some(blk) = node.next_sibling() && blk.kind_id() == kind_block {
                let name = get_node_text(source_code, &node).unwrap_or("");
            }

            if !member_name.is_empty() {
                let name = CompactString::from(&member_name);
                scope.members.insert(
                    member_name,
                    ObjectMember {name, member_type, spec_content}
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
                //self.highlight_path_nodes(source_code, &node, tokens);
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
    ) {
        let mut cursor = path_node.walk();
        if !cursor.goto_first_child() {
            return;
        }

        let path_start = cursor.node();
        let start_word = get_node_text(source_code, &path_start).unwrap_or("");

        let (obj, is_func) = self.find_obj(start_word, path_start.start_byte());
        let start_col = path_start.start_position().column as u32;
        let end_col = path_start.end_position().column as u32;
        let length = end_col - start_col - 1; // remove last "/"
        if is_func {
            tokens.push((path_start.start_position().row as u32, start_col, length, TokenType::RedFunction as u32, 0));
            return;
        } else {
            // Collect all word nodes in the path
            let kind_word = self.get_kind_id("word");
            let mut path_parts: Vec<(tree_sitter::Node, String)> = Vec::new();

            loop {
                let node = cursor.node();
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
                return;
            }

            if let Some(obj) = obj {
                let mut ctx = obj;
                //tokens.push((path_start.start_position().row as u32, start_col, length, TokenType::RedCtx as u32, 0));
                let mut check = true;
                for (part_node, part) in path_parts.iter() {
                    let mut token_type = TokenType::RedVariable;
                    if check && let Some(member) = ctx.members.get(part) {
                        match member.member_type {
                            MemberType::Function => token_type = TokenType::RedFunction,
                            MemberType::Object => token_type = TokenType::RedVariable,
                            MemberType::Native => token_type = TokenType::RedKeyword,
                            MemberType::Action => token_type = TokenType::RedKeyword,
                            MemberType::Routine => token_type = TokenType::RedKeyword,
                            MemberType::Value => token_type = TokenType::RedVariable,
                        }
                    }

                    let start_col = part_node.start_position().column as u32;
                    let end_col = part_node.end_position().column as u32;
                    let length = end_col - start_col;
                    tokens.push((part_node.start_position().row as u32, start_col, length, token_type.clone() as u32, 0));

                    if token_type == TokenType::RedCtx {
                        if let Some(obj) = self.object_graph.get(&format!("{}/{}", ctx.scope_path, part)) {
                            ctx = obj.borrow().clone();
                        } else {
                            check = false;
                        }
                    }
                    if token_type == TokenType::RedFunction {
                        check = false;
                    }
                }
            }
        }
    }
}

#[derive(Debug, Clone)]
enum Symbol {
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
}

pub struct Symbols {
    map: StringRadixMap<Symbol>,
}

impl Symbols {
    fn new() -> Self {
        Self {
            map: StringRadixMap::new(),
        }
    }

    pub fn insert(&mut self, word: &str) {
        let key = word.to_lowercase();
        // Entry API for fast, single-lookup insertion
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

    pub fn find_by_prefix(&self, prefix: &str) -> Vec<String> {
        let normalized = prefix.to_lowercase();
        let mut results = Vec::new();

        // iterate_prefix returns an iterator over all entries starting with 'normalized'
        for (key, symbol) in self.map.iter_prefix(&normalized) {
            match symbol {
                Symbol::SameAsKey => results.push(key.to_string()),
                Symbol::Different(s) => results.push(s.to_string()),
                Symbol::Multiple(list) => results.extend(list.iter().map(|s| s.to_string())),
            }
        }
        results
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
