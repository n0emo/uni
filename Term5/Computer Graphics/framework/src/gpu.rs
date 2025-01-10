use std::sync::Arc;

use crate::{evloop::UserEvent, Application};
use anyhow::Context as _;
use wgpu::{Adapter, CreateSurfaceError, Device, Instance, Queue, Surface, SurfaceConfiguration};
use winit::{
    dpi::PhysicalSize,
    event::{Event, StartCause},
    window::Window,
};

pub struct WgpuContext {
    pub instance: Instance,
    pub adapter: Adapter,
    pub device: Device,
    pub queue: Queue,
}

impl WgpuContext {
    pub async fn new<A: Application>(
        surface: &mut SurfaceWrapper,
        window: Arc<Window>,
    ) -> anyhow::Result<Self> {
        let instance = Instance::default();

        surface.pre_adapter(&instance, Arc::clone(&window))?;
        let adapter = wgpu::util::initialize_adapter_from_env_or_default(&instance, surface.get())
            .await
            .context("Could not get adapter")?;
        log::info!("Using `{}` backend", adapter.get_info().backend);

        let (device, queue) = adapter
            .request_device(
                &wgpu::DeviceDescriptor {
                    label: None,
                    required_features: A::required_features(),
                    required_limits: A::required_limits().using_resolution(adapter.limits()),
                    memory_hints: wgpu::MemoryHints::MemoryUsage,
                },
                None,
            )
            .await
            .map_err(|e| anyhow::anyhow!("Could not get device: {e}"))?;

        Ok(Self {
            instance,
            adapter,
            device,
            queue,
        })
    }
}

#[derive(Default)]
pub struct SurfaceWrapper {
    surface: Option<Surface<'static>>,
    config: Option<SurfaceConfiguration>,
}

impl SurfaceWrapper {
    pub fn get(&self) -> Option<&Surface> {
        self.surface.as_ref()
    }

    pub fn config(&self) -> &wgpu::SurfaceConfiguration {
        self.config.as_ref().unwrap()
    }

    pub fn pre_adapter(
        &mut self,
        instance: &Instance,
        window: Arc<Window>,
    ) -> Result<(), CreateSurfaceError> {
        if cfg!(target_arch = "wasm32") {
            self.surface = Some(instance.create_surface(window)?);
        }

        Ok(())
    }

    pub fn start_condition(e: &Event<UserEvent>) -> bool {
        match e {
            Event::NewEvents(StartCause::Init) => true,
            _ => false,
        }
    }

    pub fn resume(&mut self, context: &WgpuContext, window: Arc<Window>, srgb: bool) {
        let window_size = window.inner_size();
        let width = window_size.width.max(1);
        let height = window_size.height.max(1);

        log::info!("Surface resume {window_size:?}");

        if !cfg!(target_arch = "wasm32") {
            self.surface = Some(context.instance.create_surface(window).unwrap());
        }

        // From here on, self.surface should be Some.

        let surface = self.surface.as_ref().unwrap();

        let mut config = surface
            .get_default_config(&context.adapter, width, height)
            .expect("Surface isn't supported by the adapter.");
        if srgb {
            let view_format = config.format.add_srgb_suffix();
            config.view_formats.push(view_format);
        } else {
            let format = config.format.remove_srgb_suffix();
            config.format = format;
            config.view_formats.push(format);
        };

        surface.configure(&context.device, &config);
        self.config = Some(config);
    }

    pub fn acquire(&mut self, ctx: &WgpuContext) -> wgpu::SurfaceTexture {
        let surface = self.surface.as_ref().unwrap();

        match surface.get_current_texture() {
            Ok(frame) => frame,
            Err(wgpu::SurfaceError::Timeout) => surface
                .get_current_texture()
                .expect("Failed to acquire next surface texture!"),
            Err(
                wgpu::SurfaceError::Outdated
                | wgpu::SurfaceError::Lost
                | wgpu::SurfaceError::OutOfMemory,
            ) => {
                surface.configure(&ctx.device, self.config());
                surface
                    .get_current_texture()
                    .expect("Failed to acquire next surface texture!")
            }
        }
    }

    pub fn resize(&mut self, context: &WgpuContext, size: PhysicalSize<u32>) {
        log::info!("Surface resize {size:?}");

        let config = self.config.as_mut().unwrap();
        config.width = size.width.max(1).min(4096);
        config.height = size.height.max(1).min(4096);
        let surface = self.surface.as_ref().unwrap();
        surface.configure(&context.device, config);
    }
}
