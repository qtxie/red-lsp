use anyhow::Result;
use crossbeam_channel::RecvTimeoutError;
use lsp_server::{Connection, ExtractError, Message, Request, Response};
use lsp_types::*;
use ropey::Rope;
use tree_sitter::Parser;

use crate::analyzer;

struct RedLanguageServer {
    ctx: analyzer::Ctx,
    parser: Parser,
}

impl RedLanguageServer {
    fn new() -> Self {
        let mut parser = Parser::new();
        let lang = tree_sitter_red::LANGUAGE;
        parser.set_language(&lang.into()).expect("Failed to set language");
        Self {
            ctx: analyzer::Ctx::new(),
            parser,
        }
    }

    fn handle_initialize(&mut self, _params: InitializeParams) -> Result<InitializeResult> {
        Ok(InitializeResult {
            capabilities: ServerCapabilities {
                text_document_sync: Some(TextDocumentSyncCapability::Options(
                    TextDocumentSyncOptions {
                        open_close: Some(true),
                        change: Some(TextDocumentSyncKind::INCREMENTAL),
                        ..Default::default()
                    },
                )),
                definition_provider: Some(OneOf::Left(true)),
                completion_provider: Some(CompletionOptions {
                    resolve_provider: Some(false),
                    trigger_characters: Some(vec!["/".to_string(), " ".to_string()]),
                    all_commit_characters: None,
                    completion_item: None,
                    work_done_progress_options: Default::default(),
                }),
                ..Default::default()
            },
            server_info: Some(ServerInfo {
                name: "red-lsp".to_string(),
                version: Some(env!("CARGO_PKG_VERSION").to_string()),
            }),
        })
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
                    while start > 0 && (chars[start - 1].is_alphanumeric() || chars[start - 1] == '_' || chars[start - 1] == '?' || chars[start - 1] == '~') {
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
        "textDocument/completion" => match serde_json::from_value::<CompletionParams>(req.params) {
            Ok(params) => {
                let result = server.handle_completion(params);
                Ok(Some(Response::new_ok(id, result)))
            }
            Err(_) => Ok(Some(Response::new_err(
                id,
                lsp_server::ErrorCode::InvalidParams as i32,
                "Invalid params".to_string(),
            ))),
        },
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
