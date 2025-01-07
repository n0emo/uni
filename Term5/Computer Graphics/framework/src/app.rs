use std::sync::{Arc, Mutex};

use log::info;
use wgpu::SurfaceConfiguration;
use winit::{
    event::{Event, WindowEvent},
    event_loop::{EventLoop, EventLoopProxy, EventLoopWindowTarget},
};

use crate::{EventLoopWrapper, SurfaceWrapper, UserEvent, WgpuContext};

pub trait Application {
    const SRGB: bool = true;

    const NAME: &str;

    const DESCRIPTION: &str;

    fn init(config: &SurfaceConfiguration, ctx: &WgpuContext) -> Self;

    fn render(&mut self, view: &wgpu::TextureView, dt: f32, ctx: &WgpuContext);

    fn optional_features() -> wgpu::Features {
        wgpu::Features::empty()
    }

    fn required_features() -> wgpu::Features {
        wgpu::Features::empty()
    }

    fn required_downlevel_capabilities() -> wgpu::DownlevelCapabilities {
        wgpu::DownlevelCapabilities {
            flags: wgpu::DownlevelFlags::empty(),
            shader_model: wgpu::ShaderModel::Sm5,
            ..wgpu::DownlevelCapabilities::default()
        }
    }

    fn required_limits() -> wgpu::Limits {
        wgpu::Limits::downlevel_webgl2_defaults()
    }

    fn resize(&mut self, config: &SurfaceConfiguration, ctx: &WgpuContext) {
        let _ = (config, ctx);
    }

    fn update(&mut self, event: WindowEvent) {
        let _ = event;
    }
}

#[derive(Default)]
pub struct ApplicationHandle {
    proxy: Option<EventLoopProxy<UserEvent>>,
}

impl ApplicationHandle {
    pub fn exit(&self) {
        let _ = self.proxy.as_ref().unwrap().send_event(UserEvent::Close);
    }
}

pub fn run<A: Application + 'static>(handle: Option<Arc<Mutex<ApplicationHandle>>>) {
    cfg_if::cfg_if! {
        if #[cfg(target_arch = "wasm32")] {
            wasm_bindgen_futures::spawn_local(async move { start::<A>(handle).await });
        } else {
            pollster::block_on(start::<A>(handle));
        }
    }
}

pub async fn start<A: Application + 'static>(
    handle: Option<Arc<Mutex<ApplicationHandle>>>,
) {
    info!("Starting application");
    let title = A::NAME.to_owned();
    let EventLoopWrapper { event_loop, window } = EventLoopWrapper::new(title).unwrap();
    if let Some(handle) = handle {
        handle.lock().unwrap().proxy = Some(event_loop.create_proxy());
    }
    let mut surface = SurfaceWrapper::default();
    let context = WgpuContext::new::<A>(&mut surface, window.clone())
        .await
        .unwrap();

    cfg_if::cfg_if! {
        if #[cfg(target_arch = "wasm32")] {
            use winit::platform::web::EventLoopExtWebSys;
            let event_loop_function = EventLoop::spawn;
        } else {
            let event_loop_function = EventLoop::run;
        }
    }

    let mut app = None;
    let mut time = chrono::Local::now();

    #[allow(clippy::let_unit_value)]
    let _ = (event_loop_function)(
        event_loop,
        move |event: Event<UserEvent>, target: &EventLoopWindowTarget<UserEvent>| {
            let _context = &context;
            match event {
                ref event if SurfaceWrapper::start_condition(event) => {
                    surface.resume(&context, window.clone(), A::SRGB);
                    if app.is_none() {
                        app = Some(A::init(surface.config(), &context))
                    }
                }
                Event::WindowEvent {
                    window_id: _,
                    event,
                } => match event {
                    WindowEvent::CloseRequested => target.exit(),
                    WindowEvent::RedrawRequested => {
                        let Some(app) = app.as_mut() else { return };

                        let frame = surface.acquire(&context);
                        let view = frame.texture.create_view(&wgpu::TextureViewDescriptor {
                            format: Some(surface.config().view_formats[0]),
                            ..wgpu::TextureViewDescriptor::default()
                        });

                        let time_now = chrono::Local::now();
                        let dt = time_now - time;
                        const NANOS_PER_SECOND: f32 = 1_000_000_000.0;
                        let dt = (dt.num_seconds() as f32) + (dt.subsec_nanos() as f32 / NANOS_PER_SECOND);
                        time = time_now;

                        app.render(&view, dt, &context);
                        frame.present();
                    }
                    WindowEvent::Resized(size) => {
                        surface.resize(&context, size);
                        app.as_mut().unwrap().resize(&surface.config(), &context);
                    }
                    _e => {}
                },
                Event::UserEvent(e) => match e {
                    UserEvent::Close => target.exit(),
                },
                _e => {}
            }
        },
    );
}
