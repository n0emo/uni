use std::{ops::Deref, sync::Arc};

use axum::{routing::get, Router};
use tracing::info;

use crate::config::Config;

#[derive(Clone)]
pub struct AppState(Arc<AppStateInner>);

impl AppState {
    fn new() -> Self {
        Self(Arc::new(AppStateInner::new()))
    }
}

impl Deref for AppState {
    type Target = AppStateInner;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

pub struct AppStateInner {
}

impl AppStateInner {
    pub fn new() -> Self {
        Self {}
    }
}

pub struct App {
    router: Router,
    config: Config,
}

impl App {
    pub async fn new(config: Config) -> Self {
        use crate::routes::{index, add, list};

        let state = AppState::new();
        let router = Router::new()
            .route("/", get(index::get))
            .route("/add", get(add::get))
            .route("/list", get(list::get))
            .with_state(state);

        Self { router, config }
    }

    pub async fn serve(self) -> anyhow::Result<()> {
        let addr = (self.config.host.as_str(), self.config.port);
        let listener = tokio::net::TcpListener::bind(addr).await?;
        info!("Listening at {addr}", addr = listener.local_addr()?);
        axum::serve(listener, self.router).await?;

        Ok(())
    }
}
