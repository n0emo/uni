use std::sync::Arc;

use anyhow::Context;
use winit::{
    event_loop::{EventLoop, EventLoopBuilder},
    window::{Window, WindowBuilder},
};

#[derive(Clone, Debug)]
pub enum UserEvent {
    Close,
}

pub struct EventLoopWrapper {
    pub event_loop: EventLoop<UserEvent>,
    pub window: Arc<Window>,
}

impl EventLoopWrapper {
    pub fn new(title: String) -> anyhow::Result<Self> {
        let event_loop = EventLoopBuilder::<UserEvent>::with_user_event()
            .build()
            .context("Could not create event loop")?;

        let mut builder = WindowBuilder::new()
            .with_title(title);

        #[cfg(target_arch = "wasm32")]
        {
            use wasm_bindgen::JsCast;
            use winit::platform::web::WindowBuilderExtWebSys;

            let canvas = web_sys::window()
                .context("Could not get web window")?
                .document()
                .context("Could not get web document")?
                .get_element_by_id("canvas")
                .context("There is no element with id `canvas`")?
                .dyn_into::<web_sys::HtmlCanvasElement>()
                .map_err(|_| {
                    anyhow::anyhow!("Could not cast element with id `canvas` to HtmlCanvas")
                })?;
            builder = builder.with_canvas(Some(canvas));
        }
        #[cfg(not(target_arch = "wasm32"))]
        {
            builder = builder.with_inner_size(winit::dpi::PhysicalSize { width: 1280, height: 720 });
        }

        let window = Arc::new(
            builder
                .build(&event_loop)
                .context("Coult not create window")?,
        );
        Ok(Self { event_loop, window })
    }
}
