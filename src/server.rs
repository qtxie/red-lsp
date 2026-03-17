use anyhow::Result;
use crossbeam_channel::RecvError;
use hashbrown::HashMap;
use lsp_server::{Connection, ExtractError, Message, Request, Response};
use lsp_types::*;
use ropey::Rope;
use tree_sitter::Parser;
use rust_embed::Embed;
use std::path::{Path, PathBuf};
use std::str::FromStr;
use url::Url;

use crate::analyzer;
use crate::analyzer::MemberType;

#[derive(Embed)]
#[folder = "data/"]
#[include = "red-builtins.red"]
struct BuiltinsAsset;

#[derive(Debug, Clone)]
struct SemanticTokensCache {
    tokens: Vec<SemanticToken>,
    result_id: String,
}

#[derive(Debug, Clone, Copy, PartialEq)]
enum PositionEncoding {
    Utf8,
    Utf16,
    Utf32,
}

impl Default for PositionEncoding {
    fn default() -> Self {
        PositionEncoding::Utf16
    }
}

struct RedLanguageServer {
    ctx: analyzer::Ctx,
    parser: Parser,
    capabilities: ClientCapabilities,
    position_encoding: PositionEncoding,
    semantic_tokens_cache: HashMap<Uri, SemanticTokensCache>,
    client_supports_delta: bool,
}

/// Completion type
enum CompletionType {
    /// File path completion (starts with %)
    FilePath(String),
    /// Object member completion (path/ format)
    ObjectMember(String, String),
    /// Regular symbol completion
    Symbol(String),
    /// No completion
    None,
}

impl RedLanguageServer {
    fn new() -> Self {
        let mut parser = Parser::new();
        let lang = tree_sitter_red::LANGUAGE;
        parser.set_language(&lang.into()).expect("Failed to set language");

        let mut ctx = analyzer::Ctx::new();

        // Load embedded red-builtins.red file and collect built-in symbols
        log::info!("starting server");
        if let Some(builtins_content) = BuiltinsAsset::get("red-builtins.red") {
            let builtins_source = std::str::from_utf8(builtins_content.data.as_ref()).unwrap_or("");
            let builtins_tree = parser.parse(builtins_source, None);
            // Use virtual URI to represent built-in file
            let builtins_uri: Uri = "builtin://red-builtins.red".parse().unwrap();
            ctx.builtin_ctx = ctx.collect_identifiers(builtins_source, &builtins_tree, &builtins_uri);
            log::info!("Loaded red-builtins.red");
        }

        Self {
            ctx,
            parser,
            capabilities: ClientCapabilities::default(),
            position_encoding: PositionEncoding::default(),
            semantic_tokens_cache: HashMap::new(),
            client_supports_delta: false,
        }
    }

    fn handle_initialize(&mut self, params: InitializeParams) -> Result<InitializeResult> {
        // Check client capabilities to determine which features to enable
        let client_capabilities = params.capabilities;

        // Negotiate position encoding (UTF-8, UTF-16, or UTF-32)
        let position_encoding = self.negotiate_position_encoding(
            client_capabilities.general.as_ref().and_then(|g| g.position_encodings.as_ref())
        );

        let chosen_encoding = match position_encoding {
            PositionEncoding::Utf8  => PositionEncodingKind::UTF8,
            PositionEncoding::Utf16 => PositionEncodingKind::UTF16,
            PositionEncoding::Utf32 => PositionEncodingKind::UTF32,
        };

        // Check if client supports semantic tokens delta
        let client_supports_delta = client_capabilities
            .text_document
            .as_ref()
            .and_then(|td| td.semantic_tokens.as_ref())
            .and_then(|st| st.requests.full.as_ref())
            .map_or(false, |full| match full {
                SemanticTokensFullOptions::Bool(_) => false,
                SemanticTokensFullOptions::Delta { delta } => delta.unwrap_or(false),
            });

        // Store for later use
        self.client_supports_delta = client_supports_delta;

        let semantic_tokens_provider =
                Some(SemanticTokensServerCapabilities::SemanticTokensOptions(SemanticTokensOptions {
                    legend: SemanticTokensLegend {
                        token_types: vec![
                            SemanticTokenType::FUNCTION,
                            SemanticTokenType::VARIABLE,
                            SemanticTokenType::KEYWORD,
                            SemanticTokenType::NAMESPACE,
                        ],
                        token_modifiers: vec![],
                    },
                    range: Some(true),
                    full: Some(SemanticTokensFullOptions::Delta { delta: Some(true) }),
                    ..Default::default()
            }));

        let completion_provider = Some(CompletionOptions {
                resolve_provider: Some(true),
                trigger_characters: Some(vec!["/".to_string(), " ".to_string()]),
                all_commit_characters: None,
                completion_item: None,
                work_done_progress_options: Default::default(),
            });

        let result = InitializeResult {
            capabilities: ServerCapabilities {
                position_encoding: Some(chosen_encoding),
                text_document_sync: Some(TextDocumentSyncCapability::Options(
                    TextDocumentSyncOptions {
                        open_close: Some(true),
                        change: Some(TextDocumentSyncKind::INCREMENTAL),
                        save: Some(TextDocumentSyncSaveOptions::SaveOptions(SaveOptions {
                            include_text: Some(false),
                        })),
                        ..Default::default()
                    },
                )),
                definition_provider: Some(OneOf::Left(true)),
                completion_provider,
                semantic_tokens_provider,
                ..Default::default()
            },
            server_info: Some(ServerInfo {
                name: "red-lsp".to_string(),
                version: Some(format!("{}", env!("CARGO_PKG_VERSION"))),
            }),
        };

        // Store capabilities and encoding for later use
        self.capabilities = client_capabilities;
        self.position_encoding = position_encoding;

        Ok(result)
    }

    fn negotiate_position_encoding(
        &self,
        client_encodings: Option<&Vec<PositionEncodingKind>>,
    ) -> PositionEncoding {
        // Server preference order: UTF-8 > UTF-16 > UTF-32
        if let Some(encodings) = client_encodings {
            if encodings.contains(&PositionEncodingKind::UTF8) {return PositionEncoding::Utf8;}
            if encodings.contains(&PositionEncodingKind::UTF16) {return PositionEncoding::Utf16;}
            if encodings.contains(&PositionEncodingKind::UTF32) {return PositionEncoding::Utf32;}
        }

        // Default to UTF-16 if no encoding specified
        PositionEncoding::Utf16
    }

    fn handle_text_document_did_open(&mut self, params: DidOpenTextDocumentParams) {
        let uri = params.text_document.uri.clone();
        let content = Rope::from_str(&params.text_document.text);
        self.ctx.current_uri = Some(uri.clone());

        // Parse initial tree using callback
        let tree = self.parser.parse_with_options(
            &mut |byte, _| {
                let (chunk, chunk_byte_idx, _, _) = content.chunk_at_byte(byte);
                &chunk.as_bytes()[byte - chunk_byte_idx..]
            },
            None,
            None,
        );

        let root_object = self.ctx.collect_identifiers(&params.text_document.text, &tree, &uri);

        let document = analyzer::Document {
            content,
            tree,
            root_object,
        };

        self.ctx.documents.insert(uri, document);
    }

    fn handle_text_document_did_change(&mut self, params: DidChangeTextDocumentParams) {
        let uri = params.text_document.uri.clone();
        self.ctx.current_uri = Some(uri.clone());

        // Collect line numbers that need to be parsed
        let mut lines_to_parse: Vec<usize> = Vec::new();

        if let Some(document) = self.ctx.documents.get_mut(&uri) {
            for change in &params.content_changes {
                if let Some(range) = change.range {
                    lines_to_parse.push(range.start.line as usize);

                    // Calculate old byte position before applying the change
                    let start_byte = position_to_offset_rope(&document.content, range.start);
                    let old_end_byte = position_to_offset_rope(&document.content, range.end);
                    let new_end_byte = start_byte + change.text.len();

                    // Calculate old end point before applying the change
                    let start_point = tree_sitter::Point {
                        row: range.start.line as usize,
                        column: range.start.character as usize,
                    };
                    let old_end_point = tree_sitter::Point {
                        row: range.end.line as usize,
                        column: range.end.character as usize,
                    };

                    // Apply the change to the rope
                    apply_content_change(&mut document.content, &change.text, range);

                    // Update the tree incrementally if it exists
                    if let Some(ref mut tree) = document.tree {
                        // Calculate the new end point based on the inserted text
                        let new_end_position =
                            calculate_new_end_position(&document.content, range, &change.text);

                        // Tell the parser about the change
                        tree.edit(&tree_sitter::InputEdit {
                            start_byte,
                            old_end_byte,
                            new_end_byte,
                            start_position: start_point,
                            old_end_position: old_end_point,
                            new_end_position,
                        });

                        // Re-parse the modified tree using callback
                        document.tree = self.parser.parse_with_options(
                            &mut |byte, _| {
                                let (chunk, chunk_byte_idx, _, _) = document.content.chunk_at_byte(byte);
                                &chunk.as_bytes()[byte - chunk_byte_idx..]
                            },
                            Some(tree),
                            None,
                        );
                    }
                } else {
                    // Full document change
                    document.content = Rope::from_str(&change.text);
                    document.tree = self.parser.parse_with_options(
                        &mut |byte, _| {
                            let (chunk, chunk_byte_idx, _, _) = document.content.chunk_at_byte(byte);
                            &chunk.as_bytes()[byte - chunk_byte_idx..]
                        },
                        None,
                        None,
                    );
                }
            }
        }
    }

    fn handle_goto_definition(
        &mut self,
        params: GotoDefinitionParams,
    ) -> Option<GotoDefinitionResponse> {
        let uri = &params.text_document_position_params.text_document.uri;
        let position = params.text_document_position_params.position;
        self.ctx.current_uri = Some(uri.clone());

        // Get the content of the line where the cursor is located
        let line_content = self.get_line_at_position(uri, position);
        if line_content.is_empty() {return None};

        let _cursor_col = position.character as usize;
        let byte_pos = self.get_byte_offset(uri, position);

        // Extract the node at the cursor position from the syntax tree
        let token = self.extract_path_from_tree(uri, byte_pos);

        if token.is_empty() {
            return None;
        }

        log::info!("goto definition for: '{}' at byte {}", token, byte_pos);

        // Check if it's a file path (starts with %)
        if token.starts_with('%') {
            return self.goto_file_path(&token, uri);
        }

        // Look up object/symbol definition
        let file_path = uri.to_string();
        let (obj, member) = self.ctx.find_obj(&token, byte_pos, &file_path);

        // Prefer using member's location information
        if let Some(member_info) = &member {
            if let (Some(byte_range), Some(object_path)) = (&member_info.byte_range, &member_info.object_path) {
                log::info!("found member: {} at object {:?}", member_info.name, member_info.object_path);
                // Get file_path from the object using object_path
                let file_path = self.ctx.object_graph.get(object_path)
                    .map(|obj| obj.borrow().file_path.clone())
                    .unwrap_or_else(|| uri.to_string());
                let range = self.byte_range_to_lsp_range(&file_path, *byte_range)?;
                let target_uri = if file_path.starts_with("builtin://") {
                    return None;
                } else {
                    Uri::from_str(&file_path).unwrap_or_else(|_| uri.clone())
                };
                return Some(GotoDefinitionResponse::Scalar(Location {
                    uri: target_uri,
                    range,
                }));
            }
        }

        if let Some(obj_node) = obj {
            // Found object definition
            let obj_ref = obj_node.borrow();
            log::info!("found object: {} at {} {:?}", obj_ref.name, obj_ref.file_path, obj_ref.byte_range);

            // Convert byte range to LSP location
            let range = self.byte_range_to_lsp_range(&obj_ref.file_path, obj_ref.byte_range)?;

            let target_uri = if obj_ref.file_path.starts_with("builtin://") {
                // Built-in definition, try to find source file
                return None;
            } else {
                Uri::from_str(&obj_ref.file_path).unwrap_or(uri.clone())
            };

            return Some(GotoDefinitionResponse::Scalar(Location {
                uri: target_uri,
                range,
            }));
        }

        // Found member but no location information
        if let Some(member_info) = &member {
            log::info!("found member without location: {:?}", member_info.name);
        }

        None
    }

    /// Jump to file path
    fn goto_file_path(&self, file_path: &str, current_uri: &Uri) -> Option<GotoDefinitionResponse> {
        // Remove % prefix and possible quotes
        let path = file_path.trim_start_matches('%').trim_matches('"');

        if path.is_empty() {
            return None;
        }

        log::info!("goto file path: {}", path);

        // Get the directory of the current file
        let current_dir = Url::parse(current_uri.as_str())
            .ok()
            .and_then(|url| url.to_file_path().ok())
            .and_then(|p| p.parent().map(|parent| parent.to_path_buf()))
            .unwrap_or_else(|| PathBuf::from("."));

        // Parse Red language path
        let target_path = Self::red_path_to_full_path(path, &current_dir);

        log::info!("target path: {:?}", target_path);

        // Check if file exists
        if !target_path.exists() {
            log::warn!("file not found: {:?}", target_path);
            return None;
        }

        // Convert to URI
        let target_uri = Url::from_file_path(&target_path).ok()?;
        let uri_str = target_uri.as_str();

        // Create LSP URI
        let lsp_uri: Uri = Uri::from_str(&format!("\"{}\"", uri_str))
            .or_else(|_| Uri::from_str(uri_str))
            .unwrap_or_else(|_| current_uri.clone());

        // Return location at the beginning of the file
        Some(GotoDefinitionResponse::Scalar(Location {
            uri: lsp_uri,
            range: Range {
                start: Position { line: 0, character: 0 },
                end: Position { line: 0, character: 0 },
            },
        }))
    }

    /// Convert Red language path to full path
    fn red_path_to_full_path(red_path: &str, current_dir: &Path) -> PathBuf {
        // Remove leading slashes
        let path_str = red_path.trim_start_matches('/');

        // Check if it's a Windows drive letter path
        #[cfg(windows)]
        {
            if path_str.len() >= 1
                && path_str.chars().next().map(|c| c.is_ascii_alphabetic()).unwrap_or(false)
                && path_str.chars().nth(1) == Some('/')
            {
                // Drive letter: C/folder → C:\folder
                let drive = path_str.chars().next().unwrap_or('C');
                let rest = &path_str[2..];
                let mut path = PathBuf::new();
                path.push(format!("{}:", drive));
                if !rest.is_empty() {
                    path.push(rest.replace('/', "\\"));
                }
                return path;
            } else {
                // Relative path, relative to current directory
                return current_dir.join(path_str.replace('/', "\\"));
            }
        }

        #[cfg(not(windows))]
        {
            // Unix path
            if red_path.starts_with('/') {
                PathBuf::from(red_path)
            } else {
                // Relative path, relative to current directory
                current_dir.join(path_str)
            }
        }
    }

    /// Extract node text at cursor position from syntax tree
    /// Returns corresponding content based on node type (path, word, file)
    fn extract_path_from_tree(&self, uri: &Uri, byte_pos: usize) -> String {
        let Some(document) = self.ctx.documents.get(uri) else {
            return String::new();
        };

        let Some(tree) = &document.tree else {
            return String::new();
        };

        let root = tree.root_node();

        // Use descendant_for_byte_range to find the node containing the cursor position
        root.descendant_for_byte_range(byte_pos, byte_pos)
            .and_then(|node| {
                let kind = node.kind();
                let kind_id = node.kind_id();

                log::info!("node at {}: kind={}, kind_id={}", byte_pos, kind, kind_id);

                // Get node text directly from rope
                let text = Self::get_node_text_from_rope(&document.content, &node)?;

                // Return based on node type
                match kind {
                    "file" => {
                        // File path, return full path (including %)
                        Some(text.to_string())
                    }
                    "word" | "path_start" | "get_word" => {
                        if let Some(parent) = node.parent() && parent.kind() == "path" {
                            self.extract_path_to_cursor(&Self::get_node_text_from_rope(&document.content, &parent)?, byte_pos - parent.start_byte())
                        } else {
                            Some(text.to_string())
                        }
                    }
                    _ => {
                        // Other types, try to return text
                        Some(String::new())
                    }
                }
            })
            .unwrap_or_default()
    }

    /// Get node text directly from a Rope without converting to String
    fn get_node_text_from_rope(rope: &Rope, node: &tree_sitter::Node) -> Option<String> {
        let start_byte = node.start_byte();
        let end_byte = node.end_byte();

        if start_byte <= rope.len_bytes() && end_byte <= rope.len_bytes() && start_byte <= end_byte {
            let start_char = rope.byte_to_char(start_byte);
            let end_char = rope.byte_to_char(end_byte);
            Some(rope.slice(start_char..end_char).to_string())
        } else {
            None
        }
    }

    /// Extract path portion up to cursor position
    fn extract_path_to_cursor(&self, path: &str, cursor_offset: usize) -> Option<String> {
        log::info!("extract_path_to_cursor: path='{}', cursor_offset={}", path, cursor_offset);

        // Split path by /
        let parts: Vec<&str> = path.split('/').collect();

        let mut pos = 0;
        let mut result_parts: Vec<&str> = Vec::new();

        for part in parts {
            let part_start = pos;
            let part_end = pos + part.len();

            log::info!("  checking part='{}', start={}, end={}, cursor_offset={}", part, part_start, part_end, cursor_offset);

            // Check if cursor is within this part
            if cursor_offset >= part_start && cursor_offset <= part_end {
                // Cursor is in this part, return path up to current part (including all previous parts)
                result_parts.push(part);
                let result = result_parts.join("/");
                log::info!("  found! returning: '{}'", result);
                return Some(result);
            }

            // Haven't reached cursor part yet, save this part first
            result_parts.push(part);
            pos = part_end + 1; // +1 for the '/'
        }

        // Cursor at end of path, return full path
        log::info!("  cursor at end, returning: '{}'", path);
        Some(path.to_string())
    }

    /// Convert byte range to LSP range
    fn byte_range_to_lsp_range(&self, file_path: &str, byte_range: (usize, usize)) -> Option<Range> {
        // Try to get file content from documents
        let uri = Uri::from_str(file_path).ok()?;

        if let Some(document) = self.ctx.documents.get(&uri) {
            let start_pos = self.byte_to_position(&document.content, byte_range.0);
            //let end_pos = self.byte_to_position(&document.content, byte_range.1);
            return Some(Range {
                start: start_pos,
                end: start_pos,
            });
        }

        // If file is not in open documents, try to read from file
        let url = url::Url::parse(uri.as_str()).ok()?;
        let path = url.to_file_path().ok()?;
        if let Ok(content) = std::fs::read_to_string(path) {
            let rope = Rope::from_str(&content);
            let start_pos = self.byte_to_position(&rope, byte_range.0);
            let end_pos = self.byte_to_position(&rope, byte_range.1);
            return Some(Range {
                start: start_pos,
                end: end_pos,
            });
        }

        None
    }

    /// Convert byte offset to LSP position
    fn byte_to_position(&self, rope: &Rope, byte_offset: usize) -> Position {
        let char_offset = rope.byte_to_char(byte_offset.min(rope.len_bytes()));
        let line = rope.char_to_line(char_offset);
        let line_start_char = rope.line_to_char(line);
        let col = char_offset - line_start_char;
        Position {
            line: line as u32,
            character: col as u32,
        }
    }

    fn handle_completion(&mut self, params: CompletionParams) -> Option<lsp_types::CompletionResponse> {
        let uri = &params.text_document_position.text_document.uri;
        let position = params.text_document_position.position;
        self.ctx.current_uri = Some(uri.clone());

        let byte_pos = self.get_byte_offset(uri, position);

        // Extract node type at cursor position from syntax tree to determine completion type
        let completion_type = self.get_completion_type_from_tree(uri, byte_pos);

        match completion_type {
            CompletionType::FilePath(path_prefix) => {
                // File path completion
                let completions = self.ctx.get_path_completions(&path_prefix, uri);
                let items = get_path_completion_items(&completions);
                Some(lsp_types::CompletionResponse::Array(items))
            }
            CompletionType::ObjectMember(object_path, member_prefix) => {
                // Object member completion
                let members = self.ctx.get_object_completions(&object_path, byte_pos, &member_prefix, uri);
                let items = get_object_completion_items(&members);
                Some(lsp_types::CompletionResponse::Array(items))
            }
            CompletionType::Symbol(prefix) => {
                // Regular symbol completion
                if prefix.is_empty() {
                    Some(lsp_types::CompletionResponse::Array(vec![]))
                } else {
                    let members = self.ctx.get_symbol_completions(byte_pos, &prefix, uri);
                    let items = get_object_completion_items(&members);
                    Some(lsp_types::CompletionResponse::Array(items))
                }
            }
            CompletionType::None => {
                Some(lsp_types::CompletionResponse::Array(vec![]))
            }
        }
    }

    /// Handle completion item resolve - add documentation for functions
    /// Only loads heavy data when user actually selects an item (on-demand)
    fn handle_completion_item_resolve(&self, mut item: CompletionItem) -> Option<CompletionItem> {
        // Extract info from data field
        let Some(data) = &item.data else {
            // No data field - this is a non-function item (Object, Value, Path, etc.)
            // No documentation needed
            log::info!("resolve: no data for {} (non-function)", item.label);
            return Some(item);
        };

        // Get name and member_type from data
        let Some(name) = data.get("name").and_then(|v| v.as_str()) else {
            log::info!("resolve: no name in data for {}", item.label);
            return Some(item);
        };

        let member_type = data.get("type").and_then(|v| v.as_str()).unwrap_or("Function");
        log::info!("resolve: {} (type: {})", name, member_type);

        // Only fetch documentation for functions
        if member_type == "func" || member_type == "native" || member_type == "action" || member_type == "routine" {
            // Get object_path from data if available (from object member completion)
            let object_path = data.get("path").and_then(|v| v.as_str());

            // Search in object_graph using object_path for fast O(1) lookup
            if let Some(opath) = object_path {
                if let Some(member) = self.ctx.object_graph.get_function_from_object(name, opath) {
                    if let Some(spec) = &member.spec_content {
                        let doc = format!("{}",  Self::pretty_spec(name, spec));
                        item.documentation = Some(lsp_types::Documentation::MarkupContent(
                            lsp_types::MarkupContent {
                                kind: lsp_types::MarkupKind::Markdown,
                                value: doc,
                            }
                        ));
                        item.detail = Some(format!("{} {}", member_type, Self::format_detail_spec(spec)));
                        log::info!("resolved function {} from object {} with spec", name, opath);
                        return Some(item);
                    }
                }
            }

            // Fallback: search in all objects (for symbol completions without object_path)
            if let Some(member) = self.ctx.object_graph.find_function(name) {
                if let Some(spec) = &member.spec_content {
                    let doc = format!("{}", Self::pretty_spec(name, spec));
                    item.documentation = Some(lsp_types::Documentation::MarkupContent(
                        lsp_types::MarkupContent {
                            kind: lsp_types::MarkupKind::Markdown,
                            value: doc,
                        }
                    ));
                    item.detail = Some(format!("{} {}", member_type, Self::format_detail_spec(spec)));
                    log::info!("resolved function {} with spec (fallback)", name);
                    return Some(item);
                }
            }

            // Search in builtin_ctx
            if let Some(member) = self.ctx.builtin_ctx.borrow().get_member(name) {
                if let Some(spec) = &member.spec_content {
                    let doc = format!("{}", Self::pretty_spec(name, spec));
                    item.documentation = Some(lsp_types::Documentation::MarkupContent(
                        lsp_types::MarkupContent {
                            kind: lsp_types::MarkupKind::Markdown,
                            value: doc,
                        }
                    ));
                    item.detail = Some(format!("{} {}", member_type, Self::format_detail_spec(spec)));
                    log::info!("resolved builtin function {} with spec", name);
                    return Some(item);
                }
            }
        }

        log::info!("no documentation found for {}", name);
        Some(item)
    }

    fn align_columns(items: &[(String, String)], indent: usize) -> String {
        let max_len = items.iter().map(|(name, _)| name.len()).max().unwrap_or(0);
        items.iter()
            .map(|(name, ty)| format!("{:indent$}{:<width$} {}", "", name, ty, indent = indent, width = max_len))
            .collect::<Vec<_>>()
            .join("\n")
    }

    fn tokenize(input: &str) -> Vec<String> {
        let mut tokens = Vec::new();
        let mut buf = String::new();
        let mut in_brace = false;
        let mut in_quote = false;
        let mut in_bracket = false;

        for c in input.chars() {
            match c {
                '{' => { if !buf.trim().is_empty() { tokens.push(buf.trim().to_string()); } buf.clear(); in_brace = true; buf.push(c); }
                '}' if in_brace => { buf.push(c); tokens.push(buf.trim().to_string()); buf.clear(); in_brace = false; }
                '"' => { buf.push(c); if in_quote { tokens.push(buf.trim().to_string()); buf.clear(); } in_quote = !in_quote; }
                '[' => { if !buf.trim().is_empty() { tokens.push(buf.trim().to_string()); } buf.clear(); in_bracket = true; buf.push(c); }
                ']' if in_bracket => { buf.push(c); tokens.push(buf.trim().to_string()); buf.clear(); in_bracket = false; }
                ' ' | '\n' if !in_brace && !in_quote && !in_bracket => { if !buf.is_empty() { tokens.push(buf.trim().to_string()); buf.clear(); } }
                _ => buf.push(c),
            }
        }
        if !buf.trim().is_empty() { tokens.push(buf.trim().to_string()); }
        tokens
    }

    fn pretty_spec(func_name: &str, input: &str) -> String {
        let mut description = String::new();
        let mut arguments = Vec::new();
        let mut refinements = Vec::new();
        let mut returns = String::new();
        let mut usage = vec![func_name.to_uppercase()];

        let tokens = Self::tokenize(input);
        let mut i = 0;
         while i < tokens.len() {
             let tok = &tokens[i];

             if tok == "/local" { break; }

             if tok.starts_with('{') && tok.ends_with('}') && description.is_empty() {
                 description = tok.trim_matches(|c| c == '{' || c == '}').to_string();
                 i += 1; continue;
             }
             if tok == "return:" {
                 if i + 1 < tokens.len() { returns = tokens[i + 1].to_string(); i += 2; } else { i += 1; }
                 continue;
             }
             if tok.starts_with('/') {
                 let refine = tok.to_string();
                 i += 1;
                 // docstring
                 if i < tokens.len() && (tokens[i].starts_with('"') || tokens[i].starts_with('{')) {
                     let doc = tokens[i].trim_matches(|c| c == '"' || c == '{' || c == '}').to_string();
                     refinements.push(format!("  {} => {}", refine, doc));
                     i += 1;
                 } else {
                     refinements.push(format!("  {}", refine));
                 }
                 // sub‑arguments until next refinement/return/local
                 while i + 1 < tokens.len() && !tokens[i].starts_with('/') && tokens[i] != "return:" && tokens[i] != "/local" {
                     if tokens[i + 1].starts_with('[') {
                         let name = tokens[i].clone();
                         let ty = tokens[i + 1].clone();
                         refinements.push(format!("    {:<8} {}", name, ty));
                         i += 2;
                     } else { i += 1; }
                 }
                 continue;
             }

             // arguments
             if i + 1 < tokens.len() && tokens[i + 1].starts_with('[') {
                 let name = tok.to_string();
                 let ty = tokens[i + 1].to_string();
                 arguments.push((name.clone(), ty));
                 usage.push(name);
                 i += 2;
             } else { i += 1; }
         }

        let mut sections: Vec<String> = Vec::new();
        if !description.is_empty() {
            sections.push(description.to_string());
        }
        // USAGE is always shown
        sections.push(format!("```red\nUSAGE:\n  {}", usage.join(" ")));

        if !arguments.is_empty() {
            sections.push(format!("ARGUMENTS:\n{}", Self::align_columns(&arguments, 2)));
        }
        if !refinements.is_empty() {
            sections.push(format!("REFINEMENTS:\n{}", refinements.join("\n")));
        }
        if !returns.is_empty() {
            sections.push(format!("RETURNS:\n  {}", returns));
        }

        let mut str = sections.join("\n\n");
        str.push_str("\n```");
        str
    }

    /// Format spec for item.detail: show only params, refinements and return type
    /// Example: [a b /ref return: integer!]
    fn format_detail_spec(spec: &str) -> String {
        let mut tokens = Vec::new();
        let mut in_brace = false;
        let mut in_quote = false;

        for tok in spec.split_whitespace() {
            // Stop completely once we hit /local
            if tok == "/local" {
                break;
            }

            if tok.starts_with('{') {
                in_brace = true;
                continue;
            }
            if tok.starts_with('"') {
                in_quote = true;
                continue;
            }

            if in_brace {
                if tok.ends_with('}') {
                    in_brace = false;
                }
                continue;
            }

            if in_quote {
                if tok.ends_with('"') {
                    in_quote = false;
                }
                continue;
            }

            tokens.push(tok);
        }

        format!("[{}]", tokens.join(" "))
    }

    /// Get completion type from syntax tree at cursor position
    fn get_completion_type_from_tree(&self, uri: &Uri, byte_pos: usize) -> CompletionType {
        let Some(document) = self.ctx.documents.get(uri) else {
            return CompletionType::None;
        };

        let Some(tree) = &document.tree else {
            return CompletionType::None;
        };

        let root = tree.root_node();

        // Find the node containing the cursor position
        if let Some(node) = root.descendant_for_byte_range(byte_pos-1, byte_pos-1) {
            let kind = node.kind();
            log::info!("completion at {}: kind={}", byte_pos, kind);

            // Get node text directly from rope
            if let Some(text) = Self::get_node_text_from_rope(&document.content, &node) {
                log::info!("completion text {}", text);
                match kind {
                    "file" => {
                        // File path completion
                        return CompletionType::FilePath(text);
                    }
                    "word" | "path_start" | "get_word" => {
                        if let Some(parent) = node.parent() && parent.kind() == "path" {
                            let cursor_offset = byte_pos - parent.start_byte();
                            return self.get_object_path_completion(&Self::get_node_text_from_rope(&document.content, &parent).unwrap(), cursor_offset);
                        } else {
                            // Regular symbol completion
                            return CompletionType::Symbol(text);
                        }
                    }
                    "/" => {
                        log::info!("get_completion_callback");
                        return self.get_completion_type_fallback(uri, byte_pos);
                    }
                    _ => {}
                }
            }
        }

        CompletionType::None
    }

    /// Get object path completion type
    fn get_object_path_completion(&self, path: &str, cursor_offset: usize) -> CompletionType {
        // Find the position of the last /
        if let Some(last_slash) = path.rfind('/') {
            if cursor_offset > last_slash {
                // Cursor is after the last /, complete members
                let object_path = path[..last_slash].to_string();
                let member_prefix = path[last_slash + 1..].to_string();
                return CompletionType::ObjectMember(object_path, member_prefix);
            } else {
                // Cursor is before the last /, continue parsing the preceding path
                return self.get_object_path_completion(&path[..last_slash], cursor_offset);
            }
        }

        // No /, complete object path
        CompletionType::ObjectMember(String::new(), path.to_string())
    }

    /// Fallback to string-based method
    fn get_completion_type_fallback(&self, uri: &Uri, byte_pos: usize) -> CompletionType {
        let Some(document) = self.ctx.documents.get(uri) else {
            return CompletionType::None;
        };

        let source_code = document.content.to_string();

        // Find the start position of the line where the cursor is located
        let line_start = source_code[..byte_pos].rfind('\n').map(|i| i + 1).unwrap_or(0);
        let before_cursor = &source_code[line_start..byte_pos];

        let token_start = before_cursor
            .char_indices()
            .rfind(|(_, c)| c.is_whitespace() || matches!(c, '[' | ']' | '(' | ')' | '}'))
            .map(|(idx, _)| idx + 1)
            .unwrap_or(0);

        let token = &before_cursor[token_start..];

        if token.starts_with('%') {
            return CompletionType::FilePath(token.to_string());
        }

        if token.contains('/') {
            if let Some(last_slash) = token.rfind('/') {
                let object_path = token[..last_slash].to_string();
                let member_prefix = token[last_slash + 1..].to_string();
                return CompletionType::ObjectMember(object_path, member_prefix);
            }
        }

        CompletionType::Symbol(token.to_string())
    }

    /// Get the content of the specified line
    fn get_line_at_position(&self, uri: &lsp_types::Uri, position: lsp_types::Position) -> String {
        if let Some(document) = self.ctx.documents.get(uri) {
            let line_num = position.line as usize;
            if line_num < document.content.len_lines() {
                let line_start = document.content.line_to_char(line_num);
                let line_end = document.content.line_to_char(line_num + 1);
                return document.content.chars_at(line_start).take(line_end - line_start).collect();
            }
        }
        String::new()
    }

    /// Get the byte offset at cursor position
    fn get_byte_offset(&self, uri: &lsp_types::Uri, position: lsp_types::Position) -> usize {
        if let Some(document) = self.ctx.documents.get(uri) {
            let line_num = position.line as usize;
            let char_num = position.character as usize;
            let char_offset = document.content.line_to_char(line_num) + char_num;
            return document.content.char_to_byte(char_offset);
        }
        0
    }

    fn handle_text_document_did_close(&mut self, params: DidCloseTextDocumentParams) {
        let uri = &params.text_document.uri;
        self.ctx.current_uri = Some(uri.clone());

        // If it's a file in include cache, don't remove from object_graph (because it may be referenced by multiple files)
        if !self.ctx.include_cache.contains_key(uri) {
            // Remove objects of this file from object_graph
            let file_path = uri.to_string();
            self.ctx.object_graph.remove_objects_by_file(&file_path);
        }

        self.ctx.documents.remove(uri);
        self.semantic_tokens_cache.remove(uri);
    }

    fn handle_semantic_tokens_full(
        &mut self,
        params: SemanticTokensParams,
    ) -> Option<SemanticTokensResult> {
        let uri = params.text_document.uri.clone();
        self.ctx.current_uri = Some(uri.clone());
        if let Some(document) = self.ctx.documents.get(&uri) {
            let tokens = self.ctx.get_semantic_tokens(&document.content, &document.tree);

            // Update cache with new result_id
            let result_id = generate_result_id();

            if self.client_supports_delta {
                self.semantic_tokens_cache.insert(uri, SemanticTokensCache {
                    tokens: tokens.clone(),
                    result_id: result_id.clone(),
                });
            }

            Some(SemanticTokensResult::Tokens(SemanticTokens {
                result_id: Some(result_id),
                data: tokens,
            }))
        } else {
            Some(SemanticTokensResult::Tokens(SemanticTokens {
                result_id: Some(generate_result_id()),
                data: vec![],
            }))
        }
    }

    fn handle_semantic_tokens_full_delta(
        &mut self,
        params: SemanticTokensDeltaParams,
    ) -> Option<SemanticTokensFullDeltaResult> {
        let uri = params.text_document.uri.clone();
        let previous_result_id = params.previous_result_id;
        self.ctx.current_uri = Some(uri.clone());

        // 1. Fetch previous state from cache
        let cached = self.semantic_tokens_cache.get(&uri);

        // 2. Check if the result_id matches our cache
        if let Some(old) = cached {
            if old.result_id == previous_result_id {
                // Cache hit! Compute delta
                if let Some(document) = self.ctx.documents.get(&uri) {
                    let current_tokens = self.ctx.get_semantic_tokens(&document.content, &document.tree);

                    // Compute the minimal edit
                    let edits = compute_semantic_delta(&old.tokens, &current_tokens);

                    // Update cache with new result_id
                    let result_id = generate_result_id();
                    self.semantic_tokens_cache.insert(uri, SemanticTokensCache {
                        tokens: current_tokens.clone(),
                        result_id: result_id.clone(),
                    });

                    // Return delta with edits
                    return Some(SemanticTokensFullDeltaResult::TokensDelta(SemanticTokensDelta {
                        result_id: Some(result_id),
                        edits,
                    }));
                }
            }
        }

        // 3. Fallback: Cache miss or ID mismatch - return FULL response
        self.handle_semantic_tokens_full_inner(uri)
    }

    // Helper function for returning full tokens
    fn handle_semantic_tokens_full_inner(&mut self, uri: Uri) -> Option<SemanticTokensFullDeltaResult> {
        if let Some(document) = self.ctx.documents.get(&uri) {
            let full_tokens = self.ctx.get_semantic_tokens(&document.content, &document.tree);
            let result_id = generate_result_id();
            self.semantic_tokens_cache.insert(uri, SemanticTokensCache {
                tokens: full_tokens.clone(),
                result_id: result_id.clone(),
            });

            return Some(SemanticTokensFullDeltaResult::Tokens(SemanticTokens {
                result_id: Some(result_id),
                data: full_tokens,
            }));
        }

        // Document not found - return empty response
        Some(SemanticTokensFullDeltaResult::Tokens(SemanticTokens {
            result_id: Some(generate_result_id()),
            data: vec![],
        }))
    }

    fn handle_semantic_tokens_range(
        &mut self,
        params: SemanticTokensRangeParams,
    ) -> Option<SemanticTokensResult> {
        let uri = &params.text_document.uri;
        let range = params.range;
        self.ctx.current_uri = Some(uri.clone());

        if let Some(document) = self.ctx.documents.get(uri) {
            // Get tokens only within the requested range - no filtering needed
            let range_tokens = self.ctx.get_semantic_tokens_in_range(
                &document.content,
                &document.tree,
                Some(range),
            );

            Some(SemanticTokensResult::Tokens(SemanticTokens {
                result_id: None,
                data: range_tokens,
            }))
        } else {
            Some(SemanticTokensResult::Tokens(SemanticTokens {
                result_id: None,
                data: vec![],
            }))
        }
    }

    fn handle_text_document_did_save(&mut self, params: DidSaveTextDocumentParams) {
        let uri = params.text_document.uri.clone();
        self.ctx.current_uri = Some(uri.clone());

        // Re-run collect_identifiers to update symbols
        if let Some(document) = self.ctx.documents.get(&uri) {
            let content = params.text.unwrap_or(document.content.to_string());
            if let Some(tree) = &document.tree {
                // Re-collect identifiers and update object graph
                // First remove old objects from this file
                let file_path = uri.to_string();
                self.ctx.object_graph.remove_objects_by_file(&file_path);

                // Then re-collect
                self.ctx.collect_identifiers(&content, &Some(tree.clone()), &uri);
            }
        }
    }
}

/// Convert path completion items to LSP completion items
/// Path completions don't need sort_text or data - they are simple file/folder names
fn get_path_completion_items(completions: &Vec<analyzer::PathCompletionItem>) -> Vec<lsp_types::CompletionItem> {
    completions
        .iter()
        .map(|comp| {
            let kind = if comp.is_dir {
                lsp_types::CompletionItemKind::FOLDER
            } else {
                lsp_types::CompletionItemKind::FILE
            };

            // Add trailing slash for directories
            let label = if comp.is_dir {
                format!("{}/", comp.label)
            } else {
                comp.label.clone()
            };

            lsp_types::CompletionItem {
                label: label.clone(),
                kind: Some(kind),
                // Path completions don't need sort_text or data
                sort_text: None,
                data: None,
                detail: None,
                documentation: None,
                label_details: None,
                deprecated: None,
                preselect: None,
                filter_text: None,
                insert_text: None,
                insert_text_format: None,
                insert_text_mode: None,
                text_edit: None,
                additional_text_edits: None,
                command: None,
                commit_characters: None,
                tags: None,
            }
        })
        .collect()
}

/// Convert object members to LSP completion items
/// Prioritizes names with ! and ? suffixes (e.g., abc!, abc? before abc)
/// Only stores minimal info for performance - full details loaded in resolve
/// Only functions store data for resolve, other types have data: None
fn get_object_completion_items(members: &Vec<analyzer::ObjectMember>) -> Vec<lsp_types::CompletionItem> {
    members
        .iter()
        .map(|member| {
            let kind = match member.member_type {
                MemberType::Function | MemberType::Routine => lsp_types::CompletionItemKind::FUNCTION,
                MemberType::Action | MemberType::Native => lsp_types::CompletionItemKind::KEYWORD,
                MemberType::Object => lsp_types::CompletionItemKind::CLASS,
                MemberType::Value => lsp_types::CompletionItemKind::VALUE,
            };

            // Set sortText to prioritize ! and ? suffixes
            // Lower hex values appear first in completion list
            let sort_text = if member.name.ends_with('!') {
                "80000000".to_string()
            } else if member.name.ends_with('?') {
                "80000001".to_string()
            } else {
                "80000002".to_string()
            };

            // Only store data for functions - used for resolve to lookup spec_content
            // Other types (Object, Value) don't need resolve, so data is None
            let data = if analyzer::is_any_func(member.member_type.clone()) {
                Some(serde_json::json!({
                    "name": member.name.to_string(),
                    "type": member.member_type.as_str(),
                    "path": member.object_path
                }))
            } else {
                None
            };

            lsp_types::CompletionItem {
                label: member.name.to_string(),
                kind: Some(kind),
                sort_text: Some(sort_text),
                data,
                // Don't send documentation, detail, or label_details in initial response
                // These will be loaded on-demand in resolve phase
                label_details: None,
                detail: None,
                documentation: None,
                deprecated: None,
                preselect: None,
                filter_text: None,
                insert_text: None,
                insert_text_format: None,
                insert_text_mode: None,
                text_edit: None,
                additional_text_edits: None,
                command: None,
                commit_characters: None,
                tags: None,
            }
        })
        .collect()
}

pub fn run_server(connection: &Connection) -> Result<()> {
    let mut server = RedLanguageServer::new();

    // Handle initialization
    let (id, params) = connection.initialize_start()?;
    let initialize_params = serde_json::from_value(params)?;
    let server_capabilities = server.handle_initialize(initialize_params)?;
    connection.initialize_finish(id, serde_json::to_value(server_capabilities)?)?;

    loop {
        match connection.receiver.recv() {
            Ok(msg) => {
                match msg {
                    Message::Request(req) => {
                        if connection.handle_shutdown(&req)? {return Ok(());}

                        let req_result = handle_request(&mut server, req);

                        if let Some(response) = req_result? {
                            connection.sender.send(Message::Response(response))?;
                        }
                    }
                    Message::Response(_resp) => {
                        // Responses are handled by the client
                    }
                    Message::Notification(notification) => {
                        // Handle exit notification (with or without prior shutdown)
                        if notification.method == "exit" {
                            return Ok(());
                        }
                        handle_notification(&mut server, notification)?;
                    }
                }
            }
            Err(RecvError) => {
                // Channel disconnected, exit
                break;
            }
        }
    }

    Ok(())
}

/// Generate a unique result_id for semantic tokens caching
/// In production, use a proper UUID or hash-based ID
fn generate_result_id() -> String {
    use std::time::{SystemTime, UNIX_EPOCH};
    let timestamp = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap()
        .as_nanos();
    format!("{}", timestamp)
}

/// Compute delta between old and new token arrays
/// Returns edits needed to transform old tokens into new tokens
fn compute_semantic_delta(old: &[SemanticToken], new: &[SemanticToken]) -> Vec<SemanticTokensEdit> {
    let mut edits = Vec::new();
    let mut i = 0;
    let mut j = 0;
    let field_cnt = 5;

    while i < old.len() && j < new.len() {
        if old[i] == new[j] {
            i += 1;
            j += 1;
            continue;
        }

        // Start of a difference
        let start = i as u32;

        // Find end of difference region
        let mut i2 = i;
        let mut j2 = j;
        while i2 < old.len() && j2 < new.len() && old[i2] != new[j2] {
            i2 += 1;
            j2 += 1;
        }

        // If one side runs out, consume the rest
        if i2 == old.len() || j2 == new.len() {
            i2 = old.len();
            j2 = new.len();
        }

        let delete_count = (i2 - i) as u32;
        let data = if j2 == j {
            None
        } else {
            Some(new[j..j2].to_vec())
        };

        edits.push(SemanticTokensEdit {
            start: start * field_cnt,
            delete_count: delete_count * field_cnt,
            data,
        });

        i = i2;
        j = j2;
    }

    // Handle trailing insertions
    if j < new.len() {
        edits.push(SemanticTokensEdit {
            start: i as u32 * field_cnt,
            delete_count: 0,
            data: Some(new[j..].to_vec()),
        });
    }

    // Handle trailing deletions
    if i < old.len() {
        edits.push(SemanticTokensEdit {
            start: i as u32 * field_cnt,
            delete_count: (old.len() - i) as u32 * field_cnt,
            data: None,
        });
    }

    edits
}


fn handle_request(
    server: &mut RedLanguageServer,
    req: Request,
) -> std::result::Result<Option<Response>, ExtractError<Request>> {
    let id = req.id.clone();

    match req.method.as_str() {
        "textDocument/definition" => {
            match serde_json::from_value::<GotoDefinitionParams>(req.params) {
                Ok(params) => {
                    let result = server.handle_goto_definition(params);
                    log::info!("result: {:?}", result);
                    Ok(Some(Response::new_ok(id, result)))
                }
                Err(_) => Ok(Some(Response::new_err(
                    id,
                    lsp_server::ErrorCode::InvalidParams as i32,
                    "Invalid params".to_string(),
                ))),
            }
        }
        "textDocument/completion" => {
            match serde_json::from_value::<CompletionParams>(req.params) {
                Ok(params) => {
                    let result = server.handle_completion(params);
                    Ok(Some(Response::new_ok(id, result)))
                }
                Err(_) => Ok(Some(Response::new_err(
                    id,
                    lsp_server::ErrorCode::InvalidParams as i32,
                    "Invalid params".to_string(),
                ))),
            }
        }
        "completionItem/resolve" => {
            match serde_json::from_value::<CompletionItem>(req.params) {
                Ok(item) => {
                    let result = server.handle_completion_item_resolve(item);
                    Ok(Some(Response::new_ok(id, result)))
                }
                Err(_) => Ok(Some(Response::new_err(
                    id,
                    lsp_server::ErrorCode::InvalidParams as i32,
                    "Invalid params".to_string(),
                ))),
            }
        }
        "textDocument/semanticTokens/full" => {
            match serde_json::from_value::<SemanticTokensParams>(req.params) {
                Ok(params) => {
                    let result = server.handle_semantic_tokens_full(params);
                    Ok(Some(Response::new_ok(id, result)))
                }
                Err(_) => Ok(Some(Response::new_err(
                    id,
                    lsp_server::ErrorCode::InvalidParams as i32,
                    "Invalid params".to_string(),
                ))),
            }
        }
        "textDocument/semanticTokens/full/delta" => {
            match serde_json::from_value::<SemanticTokensDeltaParams>(req.params) {
                Ok(params) => {
                    let result = server.handle_semantic_tokens_full_delta(params);
                    Ok(Some(Response::new_ok(id, result)))
                }
                Err(_) => Ok(Some(Response::new_err(
                    id,
                    lsp_server::ErrorCode::InvalidParams as i32,
                    "Invalid params".to_string(),
                ))),
            }
        }
        "textDocument/semanticTokens/range" => {
            match serde_json::from_value::<SemanticTokensRangeParams>(req.params) {
                Ok(params) => {
                    let result = server.handle_semantic_tokens_range(params);
                    Ok(Some(Response::new_ok(id, result)))
                }
                Err(_) => Ok(Some(Response::new_err(
                    id,
                    lsp_server::ErrorCode::InvalidParams as i32,
                    "Invalid params".to_string(),
                ))),
            }
        }
        _ => Ok(None),
    }
}

fn handle_notification(
    server: &mut RedLanguageServer,
    notification: lsp_server::Notification,
) -> Result<()> {
    match notification.method.as_str() {
        "textDocument/didOpen" => {
            let params: DidOpenTextDocumentParams = serde_json::from_value(notification.params)?;
            server.handle_text_document_did_open(params);
        }
        "textDocument/didChange" => {
            let params: DidChangeTextDocumentParams = serde_json::from_value(notification.params)?;
            server.handle_text_document_did_change(params);
        }
        "textDocument/didClose" => {
            let params: DidCloseTextDocumentParams = serde_json::from_value(notification.params)?;
            server.handle_text_document_did_close(params);
        }
        "textDocument/didSave" => {
            let params: DidSaveTextDocumentParams = serde_json::from_value(notification.params)?;
            server.handle_text_document_did_save(params);
        }
        _ => {}
    }

    Ok(())
}

fn apply_content_change(rope: &mut Rope, new_text: &str, range: Range) {
    let start_line = range.start.line as usize;
    let start_char = range.start.character as usize;
    let end_line = range.end.line as usize;
    let end_char = range.end.character as usize;

    // Boundary check: ensure line numbers don't exceed range
    let max_line = rope.len_lines().saturating_sub(1);
    let start_line = start_line.min(max_line);
    let end_line = end_line.min(max_line);

    // Calculate char offsets
    let start_offset = rope.line_to_char(start_line) + start_char;
    let end_offset = rope.line_to_char(end_line) + end_char;

    // Boundary check: ensure offsets don't exceed rope length
    let rope_len = rope.len_chars();
    let start_offset = start_offset.min(rope_len);
    let end_offset = end_offset.min(rope_len);

    // Remove the old range and insert new text
    if end_offset > start_offset {
        rope.remove(start_offset..end_offset);
    }
    rope.insert(start_offset, new_text);
}

fn calculate_new_end_position(_rope: &Rope, range: Range, new_text: &str) -> tree_sitter::Point {
    // Calculate the end position after inserting new_text
    let start_line = range.start.line as usize;

    // Count newlines in the new text to determine how many lines were added
    let newline_count = new_text.matches('\n').count();

    // Calculate the column position in the last line of the new text
    let last_line_start = new_text.rfind('\n').map(|i| i + 1).unwrap_or(0);
    let last_line_length = new_text[last_line_start..].chars().count();

    if newline_count == 0 {
        // Same line - just add the character count to the start character
        tree_sitter::Point {
            row: start_line,
            column: range.start.character as usize + last_line_length,
        }
    } else {
        // Multiple lines - calculate the final position
        tree_sitter::Point {
            row: start_line + newline_count,
            column: last_line_length,
        }
    }
}

fn position_to_offset_rope(rope: &Rope, position: Position) -> usize {
    let line = position.line as usize;
    let char = position.character as usize;

    // Boundary check: ensure line numbers don't exceed range
    let line = line.min(rope.len_lines().saturating_sub(1));

    let char_offset = rope.line_to_char(line) + char;

    // Boundary check: ensure character offset doesn't exceed rope length
    let char_offset = char_offset.min(rope.len_chars());

    rope.char_to_byte(char_offset)
}
