use anyhow::Result;
use crossbeam_channel::RecvTimeoutError;
use lsp_server::{Connection, ExtractError, Message, Request, Response};
use lsp_types::*;
use ropey::Rope;
use std::collections::HashMap;
use tree_sitter::Parser;

use crate::analyzer;

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
    capabilities: ServerCapabilities,
    previous_tokens: HashMap<Uri, Vec<SemanticToken>>,
    position_encoding: PositionEncoding,
}

impl RedLanguageServer {
    fn new() -> Self {
        let mut parser = Parser::new();
        let lang = tree_sitter_red::LANGUAGE;
        parser.set_language(&lang.into()).expect("Failed to set language");
        Self {
            ctx: analyzer::Ctx::new(),
            parser,
            capabilities: ServerCapabilities::default(),
            previous_tokens: HashMap::new(),
            position_encoding: PositionEncoding::default(),
        }
    }

    fn handle_initialize(&mut self, params: InitializeParams) -> Result<InitializeResult> {
        // Check client capabilities to determine which features to enable
        let client_capabilities = params.capabilities;
        
        // Negotiate position encoding (UTF-8, UTF-16, or UTF-32)
        let position_encoding = self.negotiate_position_encoding(
            client_capabilities.general.as_ref().and_then(|g| g.position_encodings.as_ref())
        );
        
        // Check if client supports semantic tokens
        let semantic_tokens_provider =
                Some(SemanticTokensServerCapabilities::SemanticTokensOptions(SemanticTokensOptions {
                    legend: SemanticTokensLegend {
                        token_types: vec![
                            SemanticTokenType::FUNCTION,
                            SemanticTokenType::KEYWORD,
                            SemanticTokenType::STRING,
                            SemanticTokenType::NUMBER,
                            SemanticTokenType::COMMENT,
                        ],
                        token_modifiers: vec![],
                    },
                    range: Some(true),
                    full: Some(SemanticTokensFullOptions::Delta { delta: Some(true) }),
                    ..Default::default()
            }));

        // Check if client supports completion
        let completion_provider = Some(CompletionOptions {
                resolve_provider: Some(false),
                trigger_characters: Some(vec!["/".to_string(), " ".to_string()]),
                all_commit_characters: None,
                completion_item: None,
                work_done_progress_options: Default::default(),
            });

        // Check if client supports definition/go-to-definition
        let definition_provider = client_capabilities
            .text_document
            .as_ref()
            .and_then(|td| td.definition.as_ref())
            .map(|_| OneOf::Left(true));

        let result = InitializeResult {
            capabilities: ServerCapabilities {
                text_document_sync: Some(TextDocumentSyncCapability::Options(
                    TextDocumentSyncOptions {
                        open_close: Some(true),
                        change: Some(TextDocumentSyncKind::INCREMENTAL),
                        ..Default::default()
                    },
                )),
                definition_provider,
                completion_provider,
                semantic_tokens_provider,
                ..Default::default()
            },
            server_info: Some(ServerInfo {
                name: "red-lsp".to_string(),
                version: Some(format!("{} ({})", env!("CARGO_PKG_VERSION"), match position_encoding {
                    PositionEncoding::Utf8 => "UTF-8",
                    PositionEncoding::Utf16 => "UTF-16",
                    PositionEncoding::Utf32 => "UTF-32",
                })),
            }),
        };

        // Store capabilities and encoding for later use
        self.capabilities = result.capabilities.clone();
        self.position_encoding = position_encoding;

        Ok(result)
    }
    
    fn negotiate_position_encoding(
        &self,
        client_encodings: Option<&Vec<PositionEncodingKind>>,
    ) -> PositionEncoding {
        // Server preference order: UTF-8 > UTF-16 > UTF-32
        if let Some(encodings) = client_encodings {
            for encoding in encodings {
                match encoding.as_str() {
                    "utf-8" => return PositionEncoding::Utf8,
                    "utf-16" => return PositionEncoding::Utf16,
                    "utf-32" => return PositionEncoding::Utf32,
                    _ => {}
                }
            }
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

        self.ctx.collect_identifiers(&params.text_document.text, &tree);

        let document = analyzer::Document {
            content,
            tree,
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
    }

    fn handle_goto_definition(
        &self,
        _params: GotoDefinitionParams,
    ) -> Option<GotoDefinitionResponse> {
        None
    }

    fn handle_completion(&self, params: CompletionParams) -> Option<lsp_types::CompletionResponse> {
        // Get the prefix from the text document position
        let prefix = self.get_word_at_position(
            &params.text_document_position.text_document.uri,
            params.text_document_position.position,
        );

        let symbols = self.ctx.symbols.find_by_prefix(&prefix);
        let items = get_red_completions(&symbols);
        Some(lsp_types::CompletionResponse::Array(items))
    }

    fn handle_text_document_did_close(&mut self, params: DidCloseTextDocumentParams) {
        self.ctx.documents.remove(&params.text_document.uri);
    }

    fn handle_semantic_tokens_full(
        &self,
        params: SemanticTokensParams,
    ) -> Option<SemanticTokensResult> {
        let uri = &params.text_document.uri;
        if let Some(document) = self.ctx.documents.get(uri) {
            let tokens = self.ctx.get_semantic_tokens(&document.content, &document.tree);
            return Some(SemanticTokensResult::Tokens(SemanticTokens {
                result_id: None,
                data: tokens,
            }));
        }
        Some(SemanticTokensResult::Tokens(SemanticTokens {
            result_id: None,
            data: vec![],
        }))
    }

    fn handle_semantic_tokens_full_delta(
        &mut self,
        params: SemanticTokensDeltaParams,
    ) -> Option<SemanticTokensFullDeltaResult> {
        let uri = &params.text_document.uri;
        let previous_result_id = if params.previous_result_id.is_empty() {
            None
        } else {
            Some(params.previous_result_id.as_str())
        };

        if let Some(document) = self.ctx.documents.get(uri) {
            let tokens = self.ctx.get_semantic_tokens(&document.content, &document.tree);

            // Check if we have previous tokens and a result_id was provided
            if let Some(prev_tokens) = self.previous_tokens.get(uri) {
                if previous_result_id.is_some() && tokens_equal(prev_tokens, &tokens) {
                    // Tokens haven't changed, return empty edits
                    return Some(SemanticTokensFullDeltaResult::PartialTokensDelta {
                        edits: vec![],
                    });
                }
            }

            // Get previous tokens for delta calculation
            let prev_tokens = self.previous_tokens.get(uri).cloned();

            // Store current tokens for next delta
            self.previous_tokens.insert(uri.clone(), tokens.clone());

            // Calculate delta if we have previous tokens
            if let Some(prev) = prev_tokens {
                let edits = compute_semantic_delta(&prev, &tokens, previous_result_id.unwrap_or(""));
                return Some(SemanticTokensFullDeltaResult::PartialTokensDelta { edits });
            }

            // No previous tokens, return full tokens
            Some(SemanticTokensFullDeltaResult::Tokens(SemanticTokens {
                result_id: Some("1".to_string()),
                data: tokens,
            }))
        } else {
            Some(SemanticTokensFullDeltaResult::Tokens(SemanticTokens {
                result_id: Some("1".to_string()),
                data: vec![],
            }))
        }
    }

    fn handle_semantic_tokens_range(
        &self,
        params: SemanticTokensRangeParams,
    ) -> Option<SemanticTokensResult> {
        let uri = &params.text_document.uri;
        let range = params.range;

        if let Some(document) = self.ctx.documents.get(uri) {
            let all_tokens = self.ctx.get_semantic_tokens(&document.content, &document.tree);

            // Filter tokens to only include those within the requested range
            let range_tokens = filter_tokens_in_range(&all_tokens, range);

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

    fn get_word_at_position(&self, uri: &lsp_types::Uri, position: lsp_types::Position) -> String {
        if let Some(document) = self.ctx.documents.get(uri) {
            let line_num = position.line as usize;
            let char_num = position.character as usize;

            // Get the line content
            if line_num < document.content.len_lines() {
                let line_start = document.content.line_to_char(line_num);
                let line_end = document.content.line_to_char(line_num + 1);
                let line_content: String = document.content.chars_at(line_start).take(line_end - line_start).collect();

                // Get the word at the cursor position
                let chars: Vec<char> = line_content.chars().collect();
                if char_num <= chars.len() {
                    // Find word start
                    let mut start = char_num;
                    while start > 0 && (chars[start - 1].is_alphanumeric() || chars[start - 1].is_ascii_punctuation() ) {
                        start -= 1;
                    }

                    // Return the prefix
                    if start < char_num {
                        return chars[start..char_num].iter().collect();
                    }
                }
            }
        }
        String::new()
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

fn compute_semantic_delta(
    prev_tokens: &[SemanticToken],
    current_tokens: &[SemanticToken],
    _previous_result_id: &str,
) -> Vec<SemanticTokensEdit> {
    // Simple delta: if tokens are the same, return empty edits
    if tokens_equal(prev_tokens, current_tokens) {
        return vec![];
    }

    // For simplicity, return a single edit that replaces everything
    // In a real implementation, you'd want to compute a proper diff
    if current_tokens.is_empty() {
        return vec![];
    }

    // Return full replacement as a single edit
    vec![SemanticTokensEdit {
        start: 0,
        delete_count: prev_tokens.len() as u32,
        data: Some(current_tokens.to_vec()),
    }]
}

// Helper to compare tokens for equality
fn tokens_equal(a: &[SemanticToken], b: &[SemanticToken]) -> bool {
    if a.len() != b.len() {
        return false;
    }
    a.iter().zip(b.iter()).all(|(x, y)| {
        x.delta_line == y.delta_line &&
        x.delta_start == y.delta_start &&
        x.length == y.length &&
        x.token_type == y.token_type &&
        x.token_modifiers_bitset == y.token_modifiers_bitset
    })
}

// Filter tokens to only include those within the specified range
fn filter_tokens_in_range(tokens: &[SemanticToken], range: Range) -> Vec<SemanticToken> {
    // Decode delta-encoded tokens to absolute positions
    let mut decoded: Vec<(u32, u32, SemanticToken)> = Vec::new();
    let mut prev_line = 0u32;
    let mut prev_start = 0u32;

    for token in tokens {
        let line = prev_line + token.delta_line;
        let start = if token.delta_line == 0 {
            prev_start + token.delta_start
        } else {
            token.delta_start
        };
        decoded.push((line, start, token.clone()));
        prev_line = line;
        prev_start = start;
    }

    // Filter tokens within range
    let range_start_line = range.start.line;
    let range_end_line = range.end.line;

    let filtered: Vec<SemanticToken> = decoded
        .into_iter()
        .filter(|(line, _, _)| *line >= range_start_line && *line <= range_end_line)
        .map(|(_, _, token)| token)
        .collect();

    // Re-encode tokens with delta encoding
    if filtered.is_empty() {
        return vec![];
    }

    let mut result: Vec<SemanticToken> = Vec::with_capacity(filtered.len());
    let mut prev_line = 0u32;
    let mut prev_start = 0u32;

    for token in filtered {
        let delta_line = if result.is_empty() {
            token.delta_line
        } else {
            token.delta_line
        };

        let delta_start = token.delta_start;

        result.push(SemanticToken {
            delta_line,
            delta_start,
            length: token.length,
            token_type: token.token_type,
            token_modifiers_bitset: token.token_modifiers_bitset,
        });

        prev_line = prev_line + delta_line;
        prev_start = if delta_line == 0 {
            prev_start + delta_start
        } else {
            delta_start
        };
    }

    result
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
    rope.remove(start_offset..end_offset);
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
