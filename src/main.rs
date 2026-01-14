use anyhow::Result;
use lsp_server::Connection;

mod analyzer;
mod server;
use server::run_server;

fn main() -> Result<()> {
    let args: Vec<String> = std::env::args().collect();
    
    // Initialize logger based on mode
    let log_level = if args.iter().any(|arg| arg == "--verbose") {
        log::LevelFilter::Debug
    } else {
        log::LevelFilter::Info
    };
    
    env_logger::Builder::new()
        .filter_level(log_level)
        .init();

    // Check for TCP mode: --tcp [--port <port>]
    let tcp_mode = args.iter().any(|arg| arg == "--tcp");
    let port = args.iter()
        .position(|arg| arg == "--port")
        .and_then(|pos| args.get(pos + 1))
        .and_then(|port_str| port_str.parse::<u16>().ok())
        .unwrap_or(2087);

    if tcp_mode {
        run_tcp_server(port)
    } else {
        run_stdio_server()
    }
}

fn run_tcp_server(port: u16) -> Result<()> {
    let addr = format!("127.0.0.1:{}", port);

    log::info!("LSP TCP server listening on {}", addr);
    log::info!("Configure your editor to connect to this port");

    // Listen for client connection using lsp-server's built-in TCP support
    let (connection, io_threads) = Connection::listen(&addr)?;

    log::info!("Client connected, LSP connection established via TCP");

    // Run the server
    let result = run_server(&connection);

    // Wait for IO threads to finish
    let _ = io_threads.join();

    log::info!("TCP connection closed");

    result
}

fn run_stdio_server() -> Result<()> {
    log::info!("LSP STDIO server starting");

    // Create the transport
    let (connection, io_threads) = Connection::stdio();

    log::info!("LSP connection established via STDIO");

    // Run the server and wait for the two threads to end
    let result = run_server(&connection);

    // Join io_threads to ensure they finish
    let _ = io_threads.join();

    log::info!("STDIO connection closed");

    result
}
