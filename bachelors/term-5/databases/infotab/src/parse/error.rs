use thiserror::Error;

#[derive(Debug, Error)]
pub enum ParseError {
    #[error("Request error: {0}")]
    Reqwest(#[from] reqwest::Error),

    #[error("SQL error: {0}")]
    Sql(#[from] sqlx::Error),
}
