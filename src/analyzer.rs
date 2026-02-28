use std::collections::HashMap;
use lsp_types::Uri;
use ropey::Rope;
use tree_sitter::Tree;
use compact_str::CompactString;
use fast_radix_trie::StringRadixMap;
use url::Url;
use std::fs;

pub struct Document {
    pub content: Rope,
    pub tree: Option<Tree>,
}

pub struct Ctx {
    pub documents: HashMap<Uri, Document>,
    pub symbols: Symbols,
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
        Self {
            documents: HashMap::new(),
            symbols: Symbols::new(),
        }
    }

    // Recursive function to collect identifiers from the tree
    pub fn walk_tree(&mut self, source_code: &str, cursor: &mut tree_sitter::TreeCursor) {
        loop {
            let node = cursor.node();

            // Check if this node is an identifier or function name
            if node.kind() == "word" || node.kind() == "set_word" {
                let text = get_node_text(source_code, &node).unwrap_or("");
                self.symbols.insert(text);
            }

            // Recurse into children
            if cursor.goto_first_child() {
                self.walk_tree(source_code, cursor);
                cursor.goto_parent();
            }

            if !cursor.goto_next_sibling() {
                break;
            }
        }
    }

    pub fn collect_identifiers(&mut self, source_code: &str, tree: &Option<Tree>) {
        if let Some(tree) = tree {
            let mut cursor = tree.walk();
            self.walk_tree(source_code, &mut cursor);
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

fn read_file_from_uri(uri: &Uri) -> Result<String, Box<dyn std::error::Error>> {
    // 1. Convert lsp_types::Uri to url::Url
    let url = Url::parse(uri.as_str())?;

    // 2. Convert Url to a local PathBuf
    let path = url
        .to_file_path()
        .map_err(|_| "URI is not a valid local file path")?;

    // 3. Read the file
    let content = fs::read_to_string(path)?;
    Ok(content)
}
