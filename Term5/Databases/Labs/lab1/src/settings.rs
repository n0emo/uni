use serde::Deserialize;
use config::{Config, ConfigError, File};

#[derive(Debug, Clone, Deserialize)]
pub struct Settings {
    pub address: String,
    pub port: String,
    pub db_url: String,
}

impl Settings {
    pub fn new() -> Result<Self, ConfigError> {
        let config = Config::builder()
            .add_source(File::with_name("settings"))
            .build()?;

        config.try_deserialize()
    }
}
