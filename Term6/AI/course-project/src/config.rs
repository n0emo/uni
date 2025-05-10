use config::ConfigError;
use serde::Deserialize;

#[derive(Debug, Clone, Deserialize)]
pub struct Config {
    pub host: String,
    pub port: u16,
}

impl Config {
    pub fn load() -> Result<Self, ConfigError> {
        let c = config::Config::builder()
            .add_source(config::File::with_name("config").required(false))
            .set_default("host", "127.0.0.1")?
            .set_default("port", 9000)?
            .build()?;

        c.try_deserialize()
    }
}
