use std::sync::Arc;

use anyhow::Context as _;
use wgpu::{Adapter, CreateSurfaceError, Device, Instance, Queue, Surface, SurfaceConfiguration};
use winit::window::Window;

#[derive(Default)]
pub struct SurfaceWrapper {
    surface: Option<Surface<'static>>,
    config: Option<SurfaceConfiguration>,
}

impl SurfaceWrapper {
    pub fn get(&self) -> Option<&Surface> {
        self.surface.as_ref()
    }

    pub fn pre_adapter(&mut self, instance: &Instance, window: Arc<Window>) -> Result<(), CreateSurfaceError>  {
        if cfg!(target_arch = "wasm32") {
            self.surface = Some(instance.create_surface(window)?);
        }

        Ok(())
    }
}

pub struct WgpuContext {
    instance: Instance,
    adapter: Adapter,
    device: Device,
    queue: Queue,
}

impl WgpuContext {
    pub async fn new(surface: &mut SurfaceWrapper, window: Arc<Window>) -> anyhow::Result<Self> {
        let instance = Instance::default();

        surface.pre_adapter(&instance, Arc::clone(&window))?;
        let adapter = wgpu::util::initialize_adapter_from_env_or_default(&instance, surface.get())
            .await.context("Could not get adapter")?;

        let (device, queue) = adapter.request_device(
            &wgpu::DeviceDescriptor {
                label: None,
                // TODO: features
                required_features: wgpu::Features::empty(),
                // TODO: limits
                required_limits: wgpu::Limits::downlevel_webgl2_defaults(),
                memory_hints: wgpu::MemoryHints::MemoryUsage,
            },
            None,
        )
        .await
        .map_err(|e| anyhow::anyhow!("Could not get device: {e}"))?;

        Ok(Self { instance, adapter, device, queue })
    }
}
