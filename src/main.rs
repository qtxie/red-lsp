use anyhow::Result;
use lsp_server::Connection;

mod analyzer;
mod server;
use server::run_server;

fn main() -> Result<()> {
    env_logger::Builder::new()
        .filter_level(log::LevelFilter::Debug)
        .init();

    // Create the transport
    let (connection, io_threads) = Connection::stdio();

    // Run the server and wait for the two threads to end
    let result = run_server(&connection);

    // Join io_threads to ensure they finish
    let _ = io_threads.join();

    result
}
