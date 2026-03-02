use hashbrown::{HashMap, HashSet};
use lsp_types::{SemanticToken, Uri};
use ropey::Rope;
use tree_sitter::Tree;
use compact_str::CompactString;
use fast_radix_trie::StringRadixMap;
use std::fs;
use std::path::{Path, PathBuf};
use url::Url;

pub struct Document {
    pub content: Rope,
    pub tree: Option<Tree>,
}

pub struct Ctx {
    pub parser: tree_sitter::Parser,
    pub documents: HashMap<Uri, Document>,
    pub symbols: Symbols,
    pub functions: HashSet<CompactString>,
    pub include_cache: HashSet<PathBuf>,
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
        }
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

        // Check if already cached
        if self.include_cache.contains(&full_path) {
            log::debug!("Include file already cached: {:?}", full_path);
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
        if let Ok(file_uri) = url::Url::from_file_path(&full_path) {
            if let Ok(uri) = serde_json::from_str::<lsp_types::Uri>(&format!("\"{}\"", file_uri.as_str())) {
                self.collect_identifiers(&content, &tree, &uri);
                log::debug!("Collected identifiers from include file: {:?}", full_path);
            }
        }

        self.include_cache.insert(full_path.clone());
        log::info!("Cached include file: {:?}", full_path);
        Some(true)
    }

    // Recursive function to collect identifiers from the tree
    pub fn walk_tree(&mut self, source_code: &str, cursor: &mut tree_sitter::TreeCursor, base_path: Option<&Path>) {
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

    /// Convert Red language path format to Rust PathBuf
    /// Red paths start with % and use forward slashes
    /// Red paths NEVER contain colons
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
        // Only on Windows: single letter + '/' means drive letter
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

    pub fn collect_identifiers(&mut self, source_code: &str, tree: &Option<Tree>, file_uri: &Uri) {
        if let Some(tree) = tree {
            let mut cursor = tree.walk();
            // Convert Uri to file path
            let base_path = Url::parse(file_uri.as_str())
                .ok()
                .and_then(|url| url.to_file_path().ok());
            self.walk_tree(source_code, &mut cursor, base_path.as_deref());
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
        cursor: &mut tree_sitter::TreeCursor,
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
