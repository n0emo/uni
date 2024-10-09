use axum::{routing::get, Router};
use tokio::net::TcpListener;
use tracing::info;

use crate::{db::{self, UserRepository}, settings::Settings};

#[derive(Clone)]
pub struct App {
    users: UserRepository,
    settings: Settings,
}

impl App {
    pub async fn new(settings: Settings) -> anyhow::Result<Self> {
        info!("Connecting to the Database");
        let pool = db::pool(&settings).await?;
        let users = UserRepository::new(pool);

        Ok(Self { users, settings })
    }

    pub async fn serve(self) -> anyhow::Result<()> {
        let router = Router::new()
            .route("/", get(get::root))
            .with_state(self.clone());

        let addr = format!("{}:{}", self.settings.address, self.settings.port);
        let listener = TcpListener::bind(addr).await?;

        info!("Listening at {}", listener.local_addr()?);
        axum::serve(listener, router).await?;

        Ok(())
    }
}

mod get {
    pub async fn root() -> &'static str {
        "Hello, World!"
    }
}
