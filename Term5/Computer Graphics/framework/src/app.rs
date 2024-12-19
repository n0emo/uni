use std::sync::{Arc, Mutex};

use winit::{event::Event, event_loop::{EventLoop, EventLoopProxy, EventLoopWindowTarget}};

use crate::{EventLoopWrapper, SurfaceWrapper, UserEvent, WgpuContext};

pub trait Application {
    fn init() -> Self;

    fn resize();

    fn update();

    fn render();
}

#[derive(Default)]
pub struct ApplicationHandle {
    proxy: Option<EventLoopProxy<UserEvent>>
}

impl ApplicationHandle {
    pub fn exit(&self) {
        let _ = self.proxy.as_ref().unwrap()
            .send_event(UserEvent::Close);
    }
}

pub fn run<A: Application>(title: String, handle: Option<Arc<Mutex<ApplicationHandle>>>) {
    cfg_if::cfg_if! {
        if #[cfg(target_arch = "wasm32")] {
            wasm_bindgen_futures::spawn_local(async move { start::<A>(title, handle).await });
        } else {
            todo!("Native platform")
        }
    }
}

pub async fn start<A: Application>(title: String, handle: Option<Arc<Mutex<ApplicationHandle>>>) {
    println!("Starting application");
    let EventLoopWrapper { event_loop, window } = EventLoopWrapper::new(title).unwrap();
    if let Some(handle) = handle {
        handle.lock().unwrap().proxy = Some(event_loop.create_proxy());
    }
    let mut surface = SurfaceWrapper::default();
    let context = WgpuContext::new(&mut surface, window.clone()).await.unwrap();

    cfg_if::cfg_if! {
        if #[cfg(target_arch = "wasm32")] {
            use winit::platform::web::EventLoopExtWebSys;
            let event_loop_function = EventLoop::spawn;
        } else {
            let event_loop_function = EventLoop::run;
        }
    }

    #[allow(clippy::let_unit_value)]
    let _ = (event_loop_function)(
        event_loop,
        move |event: Event<UserEvent>, target: &EventLoopWindowTarget<UserEvent>| {
            let _context = &context;
            match event {
                Event::WindowEvent { window_id: _, event } => match event {
                    winit::event::WindowEvent::CloseRequested => target.exit(),
                    _e => { }
                }
                Event::UserEvent(e) => match e {
                    UserEvent::Close => target.exit(),
                }
                _e => { }
            }
        }
    );
}
