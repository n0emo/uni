use sqlx::{query, query_as, PgPool};
use uuid::Uuid;

use crate::settings::Settings;

pub struct User {
    id: Uuid,
    name: String,
    surname: String,
    email: String,
}

pub async fn pool(settings: &Settings) -> Result<PgPool, sqlx::Error> {
    PgPool::connect(&settings.db_url).await
}

#[derive(Clone)]
pub struct UserRepository {
    pool: PgPool,
}

impl UserRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }

    pub async fn insert(&self, name: &str, surname: &str, email: &str) -> Result<(), sqlx::Error> {
        let id =  Uuid::new_v7();

        query!(r#"
            insert into users values
            ($1, $2, $3, $4)
            "#,
            id,
            name,
            surname,
            email
        )
        .execute(&self.pool)
        .await
        .map(|_| ())
    }

    pub async fn get_all(&self) -> Result<Vec<User>, sqlx::Error> {
        query_as!(User, r#"select id, name, surname, email from users"#)
            .fetch_all(&self.pool)
            .await
    }
}
