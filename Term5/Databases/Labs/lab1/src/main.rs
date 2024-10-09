use app::App;
use tracing::info;

use crate::settings::Settings;

mod app;
mod db;
mod settings;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let sub = tracing_subscriber::fmt().finish();
    tracing::subscriber::set_global_default(sub)?;

    info!("Deserializing settings");
    let settings = Settings::new()?;

    info!("Creating app");
    let app = App::new(settings).await?;
    app.serve().await?;

    Ok(())
}
