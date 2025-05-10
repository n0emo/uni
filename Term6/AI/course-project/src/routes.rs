use axum::response::IntoResponse;

use crate::templates::pages;

pub mod index {
    use super::*;

    pub async fn get() -> impl IntoResponse {
        pages::index()
    }
}

pub mod add {
    use super::*;

    pub async fn get() -> impl IntoResponse {
        pages::add()
    }
}

pub mod list {
    use super::*;

    pub async fn get() -> impl IntoResponse {
        pages::list()
    }
}
