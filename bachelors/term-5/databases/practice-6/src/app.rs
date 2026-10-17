use askama_axum::IntoResponse;
use askama::Template;
use axum::{body::Bytes, extract::{Path, State}, http::HeaderMap, response::Redirect, routing::{get, post}, Router};
use axum_typed_multipart::{FieldData, TryFromMultipart, TypedMultipart};

use crate::images::ImageService;

pub struct AppError(anyhow::Error);

impl IntoResponse for AppError {
    fn into_response(self) -> askama_axum::Response {
        (axum::http::StatusCode::INTERNAL_SERVER_ERROR, self.0.to_string()).into_response()
    }
}

impl From<anyhow::Error> for AppError {
    fn from(value: anyhow::Error) -> Self {
        Self(value)
    }
}

#[derive(Clone)]
pub struct AppState {
    pub images: ImageService,
}

#[derive(Template)]
#[template(path = "index.html")]
pub struct IndexTemplate {
    images: Vec<String>,
}

#[derive(Template)]
#[template(path = "images.html")]
pub struct ImagesTemplate { }

#[derive(TryFromMultipart)]
pub struct ImageMultipart {
    pub image: FieldData<Bytes>,
}

pub fn app(state: AppState) -> Router {
    Router::new()
        .route("/", get(get_index))
        .route("/images/:path", get(get_images_path))
        .route("/images", get(get_images))
        .route("/images", post(post_images))
        .with_state(state)
}

async fn get_index(State(state): State<AppState>) -> Result<IndexTemplate, AppError> {
    let images = state.images.list_all().await?;
    Ok(IndexTemplate { images })
}

async fn get_images_path(State(state): State<AppState>, Path(path): Path<String>) -> Result<impl IntoResponse, AppError> {
    let image = state.images.get(&path).await?;

    let mut headers = HeaderMap::new();
    headers.insert("Content-Type", image.1.as_str().parse().unwrap());

    Ok((headers, image.0))
}

async fn get_images() -> ImagesTemplate {
    ImagesTemplate { }
}

#[axum::debug_handler]
async fn post_images(
    State(state): State<AppState>,
    TypedMultipart(ImageMultipart { image }): TypedMultipart<ImageMultipart>
) -> Result<impl IntoResponse, AppError> {
    state.images.put(
        &image.contents,
        &image.metadata.file_name.as_deref()
            .ok_or_else(|| anyhow::anyhow!("No name provided!"))?,
        image.metadata.content_type.as_deref()
            .ok_or_else(|| anyhow::anyhow!("No content-type provided!"))?
    ).await?;

    Ok(Redirect::to("/"))
}
