```rs
use std::net::SocketAddr;

use axum::{
    body::Bytes,
    extract::{
        ConnectInfo,
        State,
        WebSocketUpgrade,
        ws::{
            self,
            WebSocket,
        },
    },
    response::IntoResponse,
};
use deanery_schemas::infotab::{
    InfotabDeviceMessage,
    InfotabDeviceParams,
};
use deanery_server_core::extract::Path;
use deanery_service_infotab_device::{
    BoxedInfotabDeviceBackendService,
    DeviceCommand,
    InfotabDevice,
    InfotabDeviceId,
    InfotabDeviceService,
    InfotabDeviceServiceError,
};
use deanery_service_schedule::{
    BoxedScheduleService,
    ScheduleService,
    ScheduleServiceError,
};
use tokio::sync::mpsc::{
    UnboundedReceiver,
    UnboundedSender,
};
use tracing::{
    error,
    info,
    warn,
};

/// WebSocket connection endpoint for Infotab devices
///
/// Read `InfotabMessage` objects from the devices
#[utoipa::path(
    get,
    path = "/{id}",
    tags = ["infotab", "websocket"],
    operation_id = "connect-infotab-device",
    params(InfotabDeviceParams),
)]
pub async fn handler(
    State(device_service): State<BoxedInfotabDeviceBackendService>,
    State(schedule_service): State<BoxedScheduleService>,
    Path(InfotabDeviceParams { id }): Path<InfotabDeviceParams>,
    ws: WebSocketUpgrade,
    ConnectInfo(addr): ConnectInfo<SocketAddr>,
) -> impl IntoResponse {
    let id = InfotabDeviceId::new(id);
    info!("Got ws upgrade request from address {addr}, id {id}");
    ws.on_upgrade(move |ws| handle_socket(ws, id, device_service, schedule_service))
}

async fn handle_socket(
    mut socket: WebSocket,
    device_id: InfotabDeviceId,
    device_service: BoxedInfotabDeviceBackendService,
    schedule_service: BoxedScheduleService,
) {
    let device = match save_device_if_not_exists(&*device_service, device_id).await {
        Err(e) => {
            error!("Error checking if device {device_id} exists in database or saving it: {e}");
            send_closing_frame(&mut socket, device_id).await;
            return;
        }
        Ok(device) => device,
    };

    let (mut ch_sender, mut ch_receiver) = tokio::sync::mpsc::unbounded_channel();

    if let Some(room) = &device.room
        && let Err(e) = send_schedule_from_database(&*schedule_service, &mut ch_sender, room.clone()).await
    {
        error!("Error sending schedule to device {device_id}: {e}");
        send_closing_frame(&mut socket, device_id).await;
        return;
    }

    if let Err(e) = device_service.connect(device_id, ch_sender).await {
        error!("Could not create service connection to device {device_id}: {e}");
        send_closing_frame(&mut socket, device_id).await;
        return;
    }

    if let Err(e) = handle_device(&mut socket, &mut ch_receiver, device_id).await {
        error!("Error while handling device {device_id}: {e}")
    }

    send_closing_frame(&mut socket, device_id).await;
    if let Err(e) = device_service.disconnect(device_id).await {
        error!("Error while disconnecting service from device {device_id}: {e}");
    }
}

async fn save_device_if_not_exists(
    service: &dyn InfotabDeviceService,
    id: InfotabDeviceId,
) -> Result<InfotabDevice, InfotabDeviceServiceError> {
    let device = match service.get_by_id(id).await? {
        Some(device) => device,
        None => {
            service
                .save(InfotabDevice {
                    id,
                    ..Default::default()
                })
                .await?
        }
    };

    Ok(device)
}

async fn send_schedule_from_database(
    service: &dyn ScheduleService,
    sender: &mut UnboundedSender<DeviceCommand>,
    room: String,
) -> Result<(), ScheduleServiceError> {
    let schedule = service.get_for_room(&room).await?;

    if let Some(schedule) = schedule {
        let schedule = Box::new(schedule);
        let cmd = DeviceCommand::DisplaySchedule { room, schedule };
        sender
            .send(cmd)
            .expect("Channel still exists, so message should be sent successfully");
    }

    Ok(())
}

async fn send_closing_frame(socket: &mut WebSocket, device_id: InfotabDeviceId) {
    let _ = socket
        .send(axum::extract::ws::Message::Close(None))
        .await
        .inspect_err(|e| warn!("Could not send closing frame to device {device_id}: {e}"));
}

async fn handle_device(
    socket: &mut WebSocket,
    receiver: &mut UnboundedReceiver<DeviceCommand>,
    device_id: InfotabDeviceId,
) -> Result<(), anyhow::Error> {
    loop {
        tokio::select! {
            msg = socket.recv() => {
                match msg {
                    Some(msg) => match msg? {
                        ws::Message::Close(_) => return Ok(()),
                        ws::Message::Pong(_) => {},
                        msg => info!("Got unknown message from device {device_id}: {msg:?}")
                    },
                    None => return Ok(()),
                }
            }

            cmd = receiver.recv() => {
                match cmd {
                    Some(cmd) => match cmd {
                        DeviceCommand::Ping => {
                            socket.send(ws::Message::Ping(Bytes::new())).await?;
                        },
                        DeviceCommand::DisplaySchedule { room, schedule } => {
                            let msg = InfotabDeviceMessage::DisplaySchedule {
                                room,
                                schedule: (*schedule).into(),
                            };
                            let msg = serde_json::to_string(&msg)?;
                            socket.send(ws::Message::Text(msg.into())).await?;
                        },
                    },
                    None => return Ok(()),
                }
            }
        }
    }
}
```
