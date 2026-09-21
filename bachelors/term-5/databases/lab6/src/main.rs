use tracing::info;

mod app;
mod images;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt()
        .compact()
        .with_target(false)
        .with_file(false)
        .init();

    let images =  {
        let access_key = "48jbTBFkn9bjSpJJFtsA";
        let secret_key = "xVMtBeZGcVgsDLzuLt1XKugduSJWb6Br8zfDNms7";
        let endpoint = "http://localhost:9000".to_owned();
        images::ImageService::new(endpoint, access_key, secret_key).await?
    };
    let state = app::AppState { images };
    let app = app::app(state);

    let listener = tokio::net::TcpListener::bind(("0.0.0.0", 3000)).await?;
    info!("Listening at {}", listener.local_addr()?);

    axum::serve(listener, app).await?;

    Ok(())
}
