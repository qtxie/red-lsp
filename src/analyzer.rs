use hashbrown::{HashMap, HashSet};
use lsp_types::{SemanticToken, Uri};
use ropey::Rope;
use tree_sitter::{Tree, TreeCursor};
use compact_str::CompactString;
use fast_radix_trie::StringRadixMap;
use std::fs;
use std::path::{Path, PathBuf};
use url::Url;

pub struct Document {
    pub content: Rope,
    pub tree: Option<Tree>,
    pub root_object: ObjectNode,
}

/// 路径补全项
#[derive(Debug, Clone)]
pub struct PathCompletionItem {
    pub label: String,
    pub is_dir: bool,
}

/// 对象成员类型
#[derive(Debug, Clone)]
pub enum MemberType {
    Value,      // 普通值（数字、字符串等）
    Function,   // 函数
    Object,     // 嵌套对象（context）
}

/// 对象成员 - 使用 CompactString 存储名称
#[derive(Debug, Clone)]
pub struct ObjectMember {
    pub name: CompactString,
    pub member_type: MemberType,
}

/// 符号定义位置
#[derive(Debug, Clone)]
pub struct SymbolDefinition {
    pub uri: Uri,
    pub byte_range: (usize, usize),
}

/// 对象节点，表示一个 context 对象
#[derive(Debug, Clone, Default)]
pub struct ObjectNode {
    pub name: String,                    // 对象名称（如 "a"）
    pub scope_path: String,              // 完整作用域路径（如 "a/b/a"）
    pub members: StringRadixMap<ObjectMember>,
    pub byte_range: (usize, usize),      // 对象在源代码中的字节范围
    pub file_path: String,
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
#[derive(Debug, Default)]
pub struct ObjectGraph {
    /// 作用域路径 -> 对象节点
    pub objects: HashMap<String, ObjectNode>,
    /// 对象名称 -> 所有同名对象的作用域路径列表
    pub name_to_scopes: HashMap<String, Vec<String>>,
}

impl ObjectGraph {
    pub fn new() -> Self {
        Self {
            objects: HashMap::new(),
            name_to_scopes: HashMap::new(),
        }
    }

    /// 添加对象
    pub fn add_object(&mut self, name: String, scope_path: String, obj: ObjectNode) -> &mut ObjectNode {
        log::info!("----add object: {} scope: {}", name, scope_path);
        // 记录名称到作用域的映射
        self.name_to_scopes.entry(name.clone()).or_insert_with(Vec::new).push(scope_path.clone());

        self.objects.entry(scope_path.clone()).or_insert(obj)
    }

    /// 根据字节位置查找当前所在的作用域（从内到外）
    pub fn find_scopes_at_position(&self, byte_pos: usize) -> Vec<&ObjectNode> {
        let mut scopes: Vec<&ObjectNode> = self.objects.values()
            .filter(|obj| byte_pos >= obj.byte_range.0 && byte_pos <= obj.byte_range.1)
            .collect();

        // 按作用域深度排序（深的在前，即内层作用域在前）
        scopes.sort_by(|a, b| {
            let depth_a = a.scope_path.matches('/').count();
            let depth_b = b.scope_path.matches('/').count();
            depth_b.cmp(&depth_a)
        });

        scopes
    }

    /// 解析对象路径并找到对应的对象
    /// path: "a" 或 "a/b" 等
    /// current_scope: 当前所在的作用域路径
    pub fn resolve_object_path(&self, path: &str, current_scope: &str) -> Option<&ObjectNode> {
        // 将路径分割为部分
        let parts: Vec<&str> = path.split('/').filter(|s| !s.is_empty()).collect();
        if parts.is_empty() {
            return None;
        }

        // 从当前作用域开始查找
        let mut current_path = current_scope.to_string();

        for (i, part) in parts.iter().enumerate() {
            // 查找在当前路径下名为 part 的对象
            let found = self.find_child_object(&current_path, part);

            if let Some(obj) = found {
                if i == parts.len() - 1 {
                    // 最后一个部分，返回对象
                    return Some(obj);
                }
                current_path = obj.scope_path.clone();
            } else {
                return None;
            }
        }

        None
    }

    /// 在指定作用域下查找子对象
    fn find_child_object(&self, parent_scope: &str, child_name: &str) -> Option<&ObjectNode> {
        // 获取所有同名对象
        log::info!("find child: {:?} , {:?}", child_name, self.name_to_scopes);
        let scopes = self.name_to_scopes.get(child_name)?;
        log::info!("parent_scope: {:?}", parent_scope);
log::info!("find scopes: {:?}", scopes);
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

    /// 查找对象成员补全
    pub fn find_members(&self, object_path: &str, current_byte_pos: usize, prefix: &str) -> Vec<&ObjectMember> {
        // 首先找到当前光标所在的作用域
        let scopes = self.find_scopes_at_position(current_byte_pos);

        // 尝试从当前作用域解析对象路径
        for scope in &scopes {
            if let Some(obj) = self.resolve_object_path(object_path, &scope.scope_path) {
                let results : Vec<&ObjectMember> = if prefix.is_empty() {
                    obj.members.values().collect()
                } else {
                    obj.members.common_prefix_values(prefix).collect()
                };
                if !results.is_empty() {
                    break;
                }
                return results;
            }
        }
        // find in global scope
        Vec::new()
    }
}

pub struct Ctx {
    pub parser: tree_sitter::Parser,
    pub documents: HashMap<Uri, Document>,  // all opened files
    pub symbols: Symbols,
    pub functions: HashSet<CompactString>,
    pub include_cache: HashSet<Uri>,
    pub object_graph: ObjectGraph,  // 对象图
    /// 符号名称 -> 定义位置列表（支持同名符号）
    pub symbol_definitions: HashMap<String, Vec<SymbolDefinition>>,
    /// 对象成员路径 -> 定义位置 (如 "a/b/c" -> c 的定义)
    pub member_definitions: HashMap<String, SymbolDefinition>,
}

impl Ctx {
    pub fn new() -> Self {
        let mut parser = tree_sitter::Parser::new();
        let lang = tree_sitter_red::LANGUAGE;
        parser.set_language(&lang.into()).expect("Failed to set language");
        Self {
            parser,
            documents: HashMap::new(),
            symbols: Symbols::new(),
            functions: HashSet::new(),
            include_cache: HashSet::new(),
            object_graph: ObjectGraph::new(),
            symbol_definitions: HashMap::new(),
            member_definitions: HashMap::new(),
        }
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

    /// 获取对象成员补全
    pub fn get_object_completions(&self, object_path: &str, current_byte_pos: usize, prefix: &str, file_uri: &Uri) -> Vec<&ObjectMember> {
        // 首先从 object_graph 查找
        let results = self.object_graph.find_members(object_path, current_byte_pos, prefix);
        if !results.is_empty() {
            return results;
        }

        // 从 document 的 root_object 查找
        if let Some(document) = self.documents.get(file_uri) {
            log::info!("get in root object");
            let parts: Vec<&str> = object_path.split('/').filter(|s| !s.is_empty()).collect();
            log::info!("part split: {:?}, {:?}, {:?}", parts, parts.first(), document.root_object.members);
            if let Some(name) = parts.first() && document.root_object.members.contains_key(name) {
                if let Some(obj) = self.object_graph.resolve_object_path(object_path, &document.root_object.name) {
                    let results : Vec<&ObjectMember> = if prefix.is_empty() {
                        obj.members.values().collect()
                    } else {
                        obj.members.common_prefix_values(prefix).collect()
                    };
                    return results;
                }
            }
        }

        Vec::new()
    }

    /// Go to definition for a symbol or object path
    /// - `path`: 可以是单个符号名（如 "abc"）或对象路径（如 "a/b/c"）
    /// - `current_byte_pos`: 当前光标字节位置，用于确定作用域
    /// - `file_uri`: 当前文件 URI
    pub fn go_to_definition(&self, path: &str, current_byte_pos: usize, file_uri: &Uri) -> Option<SymbolDefinition> {
        // 检查是否是对象路径（包含 /）
        if path.contains('/') {
            // 对象路径补全，如 "a/b/c"
            self.resolve_object_member_definition(path, current_byte_pos)
        } else {
            // 单个符号名，如 "abc"
            self.find_symbol_definition(path, current_byte_pos, file_uri)
        }
    }

    /// 解析对象成员路径并返回定义位置
    fn resolve_object_member_definition(&self, object_path: &str, _current_byte_pos: usize) -> Option<SymbolDefinition> {
        // 首先尝试直接从 member_definitions 查找
        if let Some(def) = self.member_definitions.get(object_path) {
            return Some(def.clone());
        }

        // 尝试从对象图中解析
        let parts: Vec<&str> = object_path.split('/').filter(|s| !s.is_empty()).collect();
        if parts.is_empty() {
            return None;
        }

        // 从对象图中查找对象
        // 尝试找到匹配的对象
        for (scope_path, _obj) in &self.object_graph.objects {
            if scope_path == object_path {
                //return obj.def_position.clone();
                return None;
            }
        }

        None
    }

    /// 查找符号定义（考虑作用域）
    fn find_symbol_definition(&self, symbol_name: &str, current_byte_pos: usize, file_uri: &Uri) -> Option<SymbolDefinition> {
        // 获取所有同名符号的定义
        let definitions = self.symbol_definitions.get(symbol_name)?;

        if definitions.is_empty() {
            return None;
        }

        // 如果只有一个定义，直接返回
        if definitions.len() == 1 {
            return Some(definitions[0].clone());
        }

        // 多个定义时，找到与当前光标位置最接近且在光标之前的定义
        // 或者根据作用域找到最近的定义
        let mut best_match: Option<&SymbolDefinition> = None;
        let mut best_distance: usize = usize::MAX;

        for def in definitions {
            // 只考虑同一文件的定义
            if def.uri != *file_uri {
                continue;
            }

            let def_byte = def.byte_range.0;

            // 找到在光标之前且距离最近的定义
            if def_byte <= current_byte_pos {
                let distance = current_byte_pos - def_byte;
                if distance < best_distance {
                    best_distance = distance;
                    best_match = Some(def);
                }
            }
        }

        // 如果没有在光标之前的定义，返回第一个定义
        best_match.cloned().or_else(|| definitions.first().cloned())
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

    /// Parse an include file and cache its content
    fn parse_include_file(&mut self, include_path: &Path, base_dir: &Path) -> Option<bool> {
        // Resolve relative path
        let full_path = if include_path.is_absolute() {
            include_path.to_path_buf()
        } else {
            base_dir.join(include_path)
        };

        log::debug!("Attempting to parse include file: {:?}", full_path);

        let file_url = url::Url::from_file_path(&full_path).ok()?;
        let uri = serde_json::from_str::<lsp_types::Uri>(&format!("\"{}\"", file_url.as_str())).ok()?;

        // Check if already cached or opened
        if self.include_cache.contains(&uri) || self.documents.contains_key(&uri) {
            return Some(true);
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
        self.collect_identifiers(&content, &tree, &uri);

        self.include_cache.insert(uri);
        Some(true)
    }

    // Recursive function to collect identifiers from the tree
    pub fn walk_tree(&mut self, source_code: &str, cursor: &mut TreeCursor, base_path: Option<&Path>) {
        loop {
            let node = cursor.node();
            let kind = node.kind();

            // Check for include/import directives (tree-sitter-red may use different node types)
            if kind == "issue" && get_node_text(source_code, &node).unwrap_or("") == "#include" {
                if let Some(filepath) = node.next_sibling() {
                    if filepath.kind() == "file" && let Some(include_path) = Self::extract_include_path(source_code, &filepath) {
                        log::debug!("include path: {:?}", include_path);
                        if let Some(base_dir) = base_path.and_then(|p| p.parent()) {
                            self.parse_include_file(&include_path, base_dir);
                        }
                    }
                }
            }

            // Check if this node is an identifier or function name
            if kind == "word" || kind == "set_word" {
                let mut text = get_node_text(source_code, &node).unwrap_or("");
                if kind == "set_word" {
                    text = text.trim_end_matches(':');
                }
                self.symbols.insert(text);
            }

            // Highlight function definitions (set_word followed by function body)
            // In Red: func-name: func [...] [...]
            if kind == "function" || kind == "does" {
                // Find the function name
                if let Some(name_node) = node.child(0) {
                    if name_node.kind() == "set_word" {
                        if let Some(text) = get_node_text(source_code, &name_node) {
                            // Remove the trailing colon for set_word
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

    pub fn collect_identifiers(&mut self, source_code: &str, tree: &Option<Tree>, file_uri: &Uri) -> ObjectNode {
        if let Some(tree) = tree {
            let mut cursor = tree.walk();
            // Convert Uri to file path
            let base_path = Url::parse(file_uri.as_str())
                .ok()
                .and_then(|url| url.to_file_path().ok());

            // 收集符号定义位置
            //self.collect_symbol_definitions(source_code, &mut cursor, file_uri);

            // 重置 cursor 到根节点
            //while cursor.goto_parent() {}

            self.walk_tree(source_code, &mut cursor, base_path.as_deref());

            // 重置 cursor 收集对象定义
            cursor.reset(tree.root_node());

            // 收集对象定义
            self.collect_objects(source_code, &mut cursor, file_uri)
        } else {
            ObjectNode::new()
        }
    }

    /// 遍历语法树收集对象（context）定义
    pub fn collect_objects(&mut self, source_code: &str, cursor: &mut TreeCursor, file_uri: &Uri) -> ObjectNode {
        let mut obj = ObjectNode::new();    // root context
        obj.byte_range = (0, source_code.len());
        let file_path = file_uri.to_string();
        if cursor.goto_first_child() {
            let mut scope_stack: Vec<String> = Vec::new();
            scope_stack.push(file_path.clone());
            self.parse_object_body(source_code, file_uri, cursor , &mut scope_stack, &mut obj);
        }
        obj.file_path = file_path.clone();
        obj.name = file_path;
        obj
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
        loop {
            let node = cursor.node();
            let kind = node.kind();
            let mut member_type = MemberType::Value;
            let mut member_name = String::new();

            if kind == "set_word" {
                let name = get_node_text(source_code, &node).unwrap();
                member_name = name.trim_end_matches(':').to_string();
            }

            if kind == "function" || kind == "does" {
                let name_node = node.child_by_field_name("name").unwrap();
                let name = get_node_text(source_code, &name_node).unwrap();
                member_name = name.trim_end_matches(':').to_string();
                member_type = MemberType::Function
            }

            // 检测对象定义：obj: context [...] 或 obj: make object! [...]
            if kind == "context" {
                let mut obj = ObjectNode::new();
                obj.byte_range = (node.start_byte(), node.end_byte());
                obj.file_path = uri.to_string();

                let name_node = node.child_by_field_name("name").unwrap();
                let name = get_node_text(source_code, &name_node).unwrap();
                member_name = name.trim_end_matches(':').to_string();
                scope_stack.push(member_name.clone());

                if let Some(body_node) = node.child_by_field_name("body") {
                    let mut body_cursor = body_node.walk();
                    if body_cursor.goto_first_child() {
                        log::info!(">>>>> body");
                        self.parse_object_body(source_code, uri, &mut body_cursor, scope_stack, &mut obj);
                    }
                }
                log::info!("scope_stack: {:?}", scope_stack);
                if !member_name.is_empty() {
                    self.object_graph.add_object(member_name.clone(), scope_stack.join("/"), obj);
                }
                member_type = MemberType::Object;
                scope_stack.pop();
            }

            log::info!("member_name: {:?}", member_name);
            if !member_name.is_empty() {
                let name = CompactString::from(&member_name);
                scope.members.insert(
                    member_name,
                    ObjectMember {name, member_type}
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
        loop {
            let node = cursor.node();
            let kind = node.kind();

            // Also highlight word nodes as references
            if kind == "word" {
                if let Some(text) = get_node_text(source_code, &node) {
                    let start_line = node.start_position().row as u32;

                    // Skip if outside requested range
                    if let Some(r) = range {
                        if start_line < r.start.line || start_line > r.end.line {
                            // Skip this node and its children if outside range
                            if cursor.goto_first_child() {
                                self.collect_function_tokens(source_code, cursor, tokens, range);
                                cursor.goto_parent();
                            }
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
            if cursor.goto_first_child() {
                self.collect_function_tokens(source_code, cursor, tokens, range);
                cursor.goto_parent();
            }

            if !cursor.goto_next_sibling() {
                break;
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
