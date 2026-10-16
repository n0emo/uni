```rs
use chrono::{
    DateTime,
    Duration,
    Local,
};
use deanery_models::Day;
use deanery_schemas::infotab::InfotabDeviceMessage;
use ewebsock::{
    WsEvent,
    WsMessage,
    WsReceiver,
    WsSender,
};
use serde::{
    Deserialize,
    Serialize,
};
use uuid::Uuid;

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum FallbackView {
    Room(String),
}

#[derive(Debug, Clone)]
pub enum BoardAppData {
    Fallback { view: FallbackView },

    Day { room: String, day: Day },
}

enum DataSourceState {
    Closed {
        scheduled_connect_time: DateTime<Local>,
    },
    Connecting(WsHandler),
    Connected {
        handler: WsHandler,
        queue: Vec<InfotabDeviceMessage>,
    },
}

impl DataSourceState {
    fn reconnect(duration: Duration) -> Self {
        log::info!("Reconnecting in {duration} seconds...");
        Self::Closed {
            scheduled_connect_time: Local::now() + duration,
        }
    }
}

impl Default for DataSourceState {
    fn default() -> Self {
        Self::Closed {
            scheduled_connect_time: Local::now(),
        }
    }
}

pub struct DataSource {
    state: DataSourceState,
    id: Uuid,
    current_reconnect_secs: f32,
    max_reconnect_secs: f32,
    reconnect_factor: f32,
}

impl DataSource {
    pub fn new(id: Uuid) -> Self {
        let state = DataSourceState::Closed {
            scheduled_connect_time: Local::now(),
        };

        Self {
            state,
            id,
            current_reconnect_secs: 1.0,
            max_reconnect_secs: 150.0,
            reconnect_factor: 1.5,
        }
    }

    #[allow(unused)]
    pub fn opened(&self) -> bool {
        matches!(self.state, DataSourceState::Connected { .. })
    }

    pub fn update(&mut self) {
        self.state = match std::mem::take(&mut self.state) {
            DataSourceState::Closed { scheduled_connect_time } if Local::now() > scheduled_connect_time => {
                DataSourceState::Connecting(WsHandler::new(self.id))
            }
            DataSourceState::Connecting(mut handler) => match handler.try_recv() {
                Some(WsEvent::Opened) => {
                    log::info!("Opened WebSocket connection");
                    DataSourceState::Connected {
                        handler,
                        queue: Vec::new(),
                    }
                }
                Some(WsEvent::Error(e)) => {
                    log::error!("Could not connect to server: {e}");
                    DataSourceState::reconnect(self.reconnect_duration())
                }
                _ => DataSourceState::Connecting(handler),
            },
            DataSourceState::Connected { mut handler, mut queue } => {
                let mut do_reconnect = false;
                while let Some(event) = handler.try_recv() {
                    match event {
                        WsEvent::Message(ws_message) => match ws_message {
                            ewebsock::WsMessage::Text(text) => match serde_json::from_str(&text) {
                                Ok(msg) => {
                                    log::info!("Received new message: {msg:?}");
                                    queue.push(msg);
                                }
                                Err(e) => log::error!("Error parsing recieved message: {e}"),
                            },
                            ewebsock::WsMessage::Ping(msg) => {
                                handler.sender.send(WsMessage::Pong(msg));
                            }
                            msg => log::warn!("Recieved unexpected message: {msg:?}"),
                        },
                        WsEvent::Error(e) => {
                            log::error!("WebSocket error: {e}");
                            do_reconnect = true;
                        }
                        WsEvent::Closed => {
                            do_reconnect = true;
                        }
                        _ => {}
                    }
                }
                if do_reconnect {
                    DataSourceState::reconnect(self.reconnect_duration())
                } else {
                    DataSourceState::Connected { handler, queue }
                }
            }
            s => s,
        }
    }

    pub fn messages(&mut self) -> Vec<InfotabDeviceMessage> {
        if let DataSourceState::Connected { queue, .. } = &mut self.state {
            std::mem::take(queue)
        } else {
            Vec::new()
        }
    }

    fn reconnect_duration(&mut self) -> Duration {
        let result = Duration::seconds(self.current_reconnect_secs as i64);
        self.current_reconnect_secs = f32::clamp(
            self.current_reconnect_secs * self.reconnect_factor,
            1.0,
            self.max_reconnect_secs,
        );
        result
    }
}

struct WsHandler {
    #[allow(unused)]
    sender: WsSender,
    receiver: WsReceiver,
}

impl WsHandler {
    fn new(id: Uuid) -> Self {
        const DEFAULT_URL: &str = "http://localhost:8000/ws/infotab/";

        let options = ewebsock::Options::default();

        let base_url = match std::option_env!("INFOTAB_WS_URL") {
            Some(url) => url,
            None => {
                log::error!("INFOTAB_WS_URL env was not defined at compile time, using default instead: {DEFAULT_URL}");
                DEFAULT_URL
            }
        };

        let mut base_url = base_url.to_owned();
        match base_url.chars().last() {
            None => base_url.push('/'),
            Some(last) if last != '/' => base_url.push('/'),
            _ => {}
        }

        let url = format!("{base_url}{id}");
        log::info!("Trying to connect to {url}");
        let (sender, receiver) = ewebsock::connect(url, options).unwrap();

        Self { sender, receiver }
    }

    fn try_recv(&mut self) -> Option<WsEvent> {
        self.receiver.try_recv()
    }
}
```
