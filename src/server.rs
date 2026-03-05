use anyhow::Result;
use crossbeam_channel::RecvTimeoutError;
use hashbrown::HashMap;
use lsp_server::{Connection, ExtractError, Message, Request, Response};
use lsp_types::*;
use ropey::Rope;
use tree_sitter::Parser;

use crate::analyzer;

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

impl RedLanguageServer {
    fn new() -> Self {
        let mut parser = Parser::new();
        let lang = tree_sitter_red::LANGUAGE;
        parser.set_language(&lang.into()).expect("Failed to set language");
        Self {
            ctx: analyzer::Ctx::new(),
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
                            SemanticTokenType::KEYWORD,
                        ],
                        token_modifiers: vec![],
                    },
                    range: Some(true),
                    full: Some(SemanticTokensFullOptions::Delta { delta: Some(true) }),
                    ..Default::default()
            }));

        let completion_provider = Some(CompletionOptions {
                resolve_provider: Some(false),
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
        if let Some(document) = self.ctx.documents.get_mut(&params.text_document.uri) {
            for change in params.content_changes {
                if let Some(range) = change.range {
                    // Apply the change to the rope
                    apply_content_change(&mut document.content, &change.text, range);

                    // Update the tree incrementally if it exists
                    if let Some(ref mut tree) = document.tree {
                        // Calculate the byte positions and points for the edit
                        let start_byte = position_to_offset_rope(&document.content, range.start);
                        let old_end_byte = position_to_offset_rope(&document.content, range.end);
                        let new_end_byte = start_byte + change.text.len();

                        // Calculate the start and end points
                        let start_point = tree_sitter::Point {
                            row: range.start.line as usize,
                            column: range.start.character as usize,
                        };

                        // Calculate the old end point based on the original range
                        let old_end_point = tree_sitter::Point {
                            row: range.end.line as usize,
                            column: range.end.character as usize,
                        };

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

        // Update root_object after releasing the borrow on documents
        // if let Some(document) = self.ctx.documents.get_mut(&params.text_document.uri) {
        //     let uri = params.text_document.uri.clone();
        //     let content = document.content.to_string();
        //     let tree = document.tree.clone();

        //     // Use raw pointer to avoid borrow checker issues
        //     let doc_ptr = document as *mut analyzer::Document;
        //     unsafe {
        //         (*doc_ptr).root_object = self.ctx.collect_objects_only(&content, &tree, &uri);
        //     }
        // }
    }

    fn handle_goto_definition(
        &self,
        params: GotoDefinitionParams,
    ) -> Option<GotoDefinitionResponse> {
        let uri = &params.text_document_position_params.text_document.uri;
        let position = params.text_document_position_params.position;

        // 获取光标所在行的内容
        let line_content = self.get_line_at_position(uri, position);
        if line_content.is_empty() {return None};

        let cursor_col = position.character as usize;
        let byte_pos = self.get_byte_offset(uri, position);

        // 提取要跳转的符号或路径
        let symbol_path = if let Some(path) = self.extract_object_path(&line_content, cursor_col) {
            // 对象路径，如 "a/b/c"
            path.0
        } else {
            // 单个符号名
            self.get_word_at_position(&line_content, cursor_col)
        };

        // 查找定义
        if let Some(def) = self.ctx.go_to_definition(&symbol_path, byte_pos, uri) {
            let document = self.ctx.documents.get(uri).unwrap();
            let pos = offset_to_position(&document.content, def.byte_range.0);
            let range = lsp_types::Range {
                start: pos,
                end: pos
            };

            return Some(GotoDefinitionResponse::Scalar(lsp_types::Location {
                uri: def.uri,
                range,
            }));
        }

        None
    }

    fn handle_completion(&self, params: CompletionParams) -> Option<lsp_types::CompletionResponse> {
        let uri = &params.text_document_position.text_document.uri;
        let position = params.text_document_position.position;

        // 获取光标所在行的内容，判断是否是路径补全
        let line_content = self.get_line_at_position(uri, position);
        let cursor_col = position.character as usize;

        // 检查是否是 Red 语言文件路径补全（以 % 开头）
        if let Some(path_prefix) = self.extract_path_prefix(&line_content, cursor_col) {
            // 文件路径补全
            let completions = self.ctx.get_path_completions(&path_prefix, uri);
            let items = get_path_completion_items(&completions);
            return Some(lsp_types::CompletionResponse::Array(items));
        }

        // 检查是否是对象成员补全（包含 / 但不以 % 开头）
        if let Some((object_path, member_prefix)) = self.extract_object_path(&line_content, cursor_col) {
            // 对象成员补全 - 需要计算光标的字节位置
            let byte_pos = self.get_byte_offset(uri, position);
            log::info!("get object completion");
            let members = self.ctx.get_object_completions(&object_path, byte_pos, &member_prefix, uri);
            let items = get_object_completion_items(&members);
            return Some(lsp_types::CompletionResponse::Array(items));
        }

        // 普通符号补全
        let prefix = self.get_word_at_position(&line_content, cursor_col);
        if prefix.is_empty() {
            return Some(lsp_types::CompletionResponse::Array(vec![]));
        }
        let symbols = self.ctx.symbols.find_by_prefix(&prefix);
        let items = get_red_completions(&symbols);
        Some(lsp_types::CompletionResponse::Array(items))
    }

    /// 获取指定行的内容
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

    /// 获取光标位置的字节偏移量
    fn get_byte_offset(&self, uri: &lsp_types::Uri, position: lsp_types::Position) -> usize {
        if let Some(document) = self.ctx.documents.get(uri) {
            let line_num = position.line as usize;
            let char_num = position.character as usize;
            let char_offset = document.content.line_to_char(line_num) + char_num;
            return document.content.char_to_byte(char_offset);
        }
        0
    }

    /// 从行内容中提取 Red 语言路径前缀（以 % 开头）
    /// 返回光标位置之前的路径前缀（包含 %）
    fn extract_path_prefix(&self, line_content: &str, cursor_col: usize) -> Option<String> {
        if cursor_col == 0 || cursor_col > line_content.len() {
            return None;
        }

        // 获取光标之前的内容
        let before_cursor = &line_content[..cursor_col];

        // 查找最后一个空白字符，确定当前 token 的起始位置
        let token_start = before_cursor
            .char_indices()
            .rfind(|(_, c)| c.is_whitespace())
            .map(|(idx, _)| idx + 1)
            .unwrap_or(0);

        let token = &before_cursor[token_start..];

        // 检查 token 是否以 % 开头（Red 语言路径格式）
        if token.starts_with('%') {
            Some(token.to_string())
        } else {
            None
        }
    }

    /// 从行内容中提取对象路径（如 obj1/ 或 obj1/d/）
    /// 返回 (对象路径，成员前缀)
    fn extract_object_path(&self, line_content: &str, cursor_col: usize) -> Option<(String, String)> {
        if cursor_col == 0 || cursor_col > line_content.len() {
            return None;
        }

        // 获取光标之前的内容
        let before_cursor = &line_content[..cursor_col];

        // 查找最后一个空白字符，确定当前 token 的起始位置
        let token_start = before_cursor
            .char_indices()
            .rfind(|(_, c)| c.is_whitespace())
            .map(|(idx, _)| idx + 1)
            .unwrap_or(0);

        let token = &before_cursor[token_start..];

        // 检查 token 是否包含 / 但不以 % 开头（对象成员访问）
        if token.contains('/') && !token.starts_with('%') {
            // 分割对象路径和成员前缀
            // 例如：obj1/a  -> 对象路径："obj1", 成员前缀："a"
            //       obj1/   -> 对象路径："obj1", 成员前缀：""
            //       obj1/d/ -> 对象路径："obj1/d", 成员前缀：""

            // 找到最后一个 / 的位置
            if let Some(last_slash) = token.rfind('/') {
                let object_path = &token[..last_slash];
                let member_prefix = &token[last_slash + 1..];

                if !object_path.is_empty() {
                    return Some((object_path.to_string(), member_prefix.to_string()));
                }
            }
        }

        None
    }

    fn handle_text_document_did_close(&mut self, params: DidCloseTextDocumentParams) {
        self.ctx.documents.remove(&params.text_document.uri);
        self.semantic_tokens_cache.remove(&params.text_document.uri);
    }

    fn handle_semantic_tokens_full(
        &mut self,
        params: SemanticTokensParams,
    ) -> Option<SemanticTokensResult> {
        let uri = params.text_document.uri.clone();
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
        &self,
        params: SemanticTokensRangeParams,
    ) -> Option<SemanticTokensResult> {
        let uri = &params.text_document.uri;
        let range = params.range;

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

    fn get_word_at_position(&self, line_content: &str, char_num: usize) -> String {
        if line_content.is_empty() {return line_content.to_string()};

        // Get the word at the cursor position
        let chars: Vec<char> = line_content.chars().collect();
        let end_num = chars.len();
        if char_num <= end_num {
            // Find word start
            let mut start = char_num;
            while start > 0 && is_word_char(chars[start - 1]) {
                start -= 1;
            }

            // Find word end
            let mut end = char_num;
            while end < end_num && is_word_char(chars[end]) {
                end += 1;
            }

            // Return the word
            if start < char_num || end > char_num {
                return chars[start..end].iter().collect();
            }
        }
        String::new()
    }
}

/// 快速判断 ASCII 字符是否为单词字符（使用查找表）
const fn is_ascii_word_char(c: u8) -> bool {
    matches!(c,
        b'a'..=b'z' | b'A'..=b'Z' | b'0'..=b'9' |
        b'-' | b'?' | b'!' | b'_' | b'&' | b'*' | b'~' | b'|' | b'^' | b'+'
    )
}

#[inline]
fn is_word_char(c: char) -> bool {
    // ASCII 路径使用快速查找表
    if c.is_ascii() {
        is_ascii_word_char(c as u8)
    } else {
        // 非 ASCII 字符（Unicode）使用 is_alphanumeric
        c.is_alphanumeric()
    }
}

fn get_red_completions(symbols: &Vec<String>) -> Vec<lsp_types::CompletionItem> {
    symbols
        .iter()
        .map(|word| lsp_types::CompletionItem {
            label: word.to_string(),
            kind: Some(lsp_types::CompletionItemKind::FUNCTION),
            ..Default::default()
        })
        .collect()
}

/// 将路径补全项转换为 LSP 补全项
fn get_path_completion_items(completions: &Vec<analyzer::PathCompletionItem>) -> Vec<lsp_types::CompletionItem> {
    completions
        .iter()
        .map(|comp| {
            let kind = if comp.is_dir {
                lsp_types::CompletionItemKind::FOLDER
            } else {
                lsp_types::CompletionItemKind::FILE
            };

            // 为目录添加尾随斜杠
            let label = if comp.is_dir {
                format!("{}/", comp.label)
            } else {
                comp.label.clone()
            };

            lsp_types::CompletionItem {
                label: label.clone(),
                kind: Some(kind),
                ..Default::default()
            }
        })
        .collect()
}

/// 将对象成员转换为 LSP 补全项
fn get_object_completion_items(members: &Vec<&analyzer::ObjectMember>) -> Vec<lsp_types::CompletionItem> {
    members
        .iter()
        .map(|member| {
            let kind = match member.member_type {
                analyzer::MemberType::Function => lsp_types::CompletionItemKind::FUNCTION,
                analyzer::MemberType::Object => lsp_types::CompletionItemKind::MODULE,
                analyzer::MemberType::Value => lsp_types::CompletionItemKind::VARIABLE,
            };

            lsp_types::CompletionItem {
                label: member.name.to_string(),
                kind: Some(kind),
                ..Default::default()
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

    // Run the event loop with timeout to detect client disconnect
    let mut shutdown_requested = false;
    loop {
        match connection.receiver.recv_timeout(std::time::Duration::from_secs(1)) {
            Ok(msg) => {
                match msg {
                    Message::Request(req) => {
                        if connection.handle_shutdown(&req)? {
                            shutdown_requested = true;
                        }

                        // Ignore requests after shutdown
                        if shutdown_requested {
                            continue;
                        }

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
            Err(RecvTimeoutError::Timeout) => {
                // Continue loop to check for client disconnect
                continue;
            }
            Err(RecvTimeoutError::Disconnected) => {
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
        _ => {}
    }

    Ok(())
}

fn apply_content_change(rope: &mut Rope, new_text: &str, range: Range) {
    let start_line = range.start.line as usize;
    let start_char = range.start.character as usize;
    let end_line = range.end.line as usize;
    let end_char = range.end.character as usize;

    // Calculate char offsets
    let start_offset = rope.line_to_char(start_line) + start_char;
    let end_offset = rope.line_to_char(end_line) + end_char;

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
    let char_offset = rope.line_to_char(position.line as usize) + position.character as usize;
    rope.char_to_byte(char_offset)
}

/// 将字节偏移量转换为 (line, column) 位置
fn offset_to_position(rope: &Rope, byte_offset: usize) -> Position {
    // Ropey gives us a way to map byte offsets to character indices
    let char_idx = rope.byte_to_char(byte_offset);

    // Get the line number containing this character
    let line = rope.char_to_line(char_idx);

    // Get the character offset within that line
    let line_start = rope.line_to_char(line);
    let column = char_idx - line_start;

    Position {
        line: line as u32,
        character: column as u32,
    }
}
