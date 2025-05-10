use app::App;
use config::Config;
use tracing::Level;
use tracing_subscriber::EnvFilter;

mod app;
mod db;
mod routes;
mod config;
mod templates;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let filter = EnvFilter::from_default_env()
        .add_directive(Level::INFO.into());

    tracing_subscriber::fmt()
        .with_env_filter(filter)
        .with_target(false)
        .try_init()
        .map_err(anyhow::Error::from_boxed)?;

    let config = Config::load()?;

    let app = App::new(config).await;
    app.serve().await?;

    Ok(())
}
