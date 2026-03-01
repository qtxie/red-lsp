# Red Language Server

Red-LSP is a language server for the Red programming language, implementing the Language Server Protocol (LSP). It provides IDE-like features for Red developers.

## Features

- **Go to Definition**: Navigate to the definition of functions, variables, and other symbols in your Red code
- **Code Completion**: Get intelligent suggestions for Red keywords, functions, and variables
- **Semantic Highlighting**: Syntax highlighting support through LSP semantic tokens
- **Incremental Parsing**: Efficient document updates using [tree-sitter-red](https://github.com/red/tree-sitter-red)
- **Multiple Transport Modes**: Supports both STDIO and TCP connections
- **Position Encoding Negotiation**: Supports UTF-8, UTF-16, and UTF-32 encodings

## Usage

### Standard IO Mode (Default)

The language server can be integrated with any editor that supports LSP via stdio:

```bash
# Run in stdio mode (default)
red-lsp
```

### TCP Mode

For debugging or remote development, the server can also run in TCP mode:

```bash
# Run in TCP mode (default port 2087)
red-lsp --tcp

# Run in TCP mode with custom port
red-lsp --tcp --port 3000

# Run with verbose logging
red-lsp --tcp --verbose
```

## Architecture

The server uses:
- `tree-sitter-red` (from github.com/red/tree-sitter-red) for parsing Red code
- `lsp-server` and `lsp-types` for LSP implementation
- Custom logic for semantic analysis and feature implementation

## Build

```bash
# Clone the repository
git clone https://github.com/qtxie/red-lsp.git
cd red-lsp

# Build the project
cargo build --release
```
