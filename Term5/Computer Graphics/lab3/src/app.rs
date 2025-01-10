use std::{cell::RefCell, f32::consts::PI, rc::Rc};

use framework::WgpuContext;
use wgpu::{CommandEncoderDescriptor,  SurfaceConfiguration};

use crate::{
    camera::{Camera, CameraParams}, light::{Light, LightUniform}, render::{create_rpass, LightSourceState, SurnameState}, texture
};

pub struct Application {
    camera: Rc<RefCell<Camera>>,
    light: Rc<RefCell<Light>>,
    surname_state: SurnameState,
    light_source_state: LightSourceState,
    time: f32,
    recreate_textures: Option<(u32, u32)>,
    msaa_texture: wgpu::TextureView,
    depth_texture: texture::Texture,
}

impl framework::Application for Application {
    const NAME: &str = "ЛР№3.";

    const DESCRIPTION: &str = "Лабораторная работа №3";

    fn init(config: &SurfaceConfiguration, ctx: &WgpuContext) -> Self {
        let camera = Rc::new(RefCell::new(Camera::new(
            &ctx.device,
            CameraParams {
                eye: (0.0, 3.0, 0.0).into(),
                ..Default::default()
            },
        )));

        let light = Rc::new(RefCell::new(Light::new(
            LightUniform {
                color: [1.0, 1.0, 1.0],
                position: [0.0, 0.0, 5.0],
                ..Default::default()
            },
            &ctx.device)));

        let msaa_texture = texture::create_msaa_texture(config.width, config.height, &ctx.device);
        let depth_texture = texture::Texture::create_depth_texture(config.width, config.height, &ctx.device);

        let surname_state = SurnameState::new(config, ctx, camera.clone(), light.clone());
        let light_source_state = LightSourceState::new(config, ctx, camera.clone(), light.clone());

        Self {
            camera,
            light,
            surname_state,
            light_source_state,
            time: 0.0,
            recreate_textures: None,
            msaa_texture,
            depth_texture,
        }
    }

    fn render(&mut self, view: &wgpu::TextureView, dt: f32, ctx: &WgpuContext) {
        self.time += dt;

        let zoom = ((self.time * 0.6).sin() + 3.5) * 10.0;
        self.camera.borrow_mut().params.eye.y = (self.time * 1.0).sin() * 15.0;
        self.camera.borrow_mut().params.eye.x = (self.time * 0.3 - PI * 0.7).sin() * zoom;
        self.camera.borrow_mut().params.eye.z = (self.time * 0.3 - PI * 0.7).cos() * zoom;
        self.camera.borrow_mut().update_buffer(&ctx.queue);

        self.light.borrow_mut().light_uniform.position[0] = (self.time * 0.5).cos() * 20.0;
        self.light.borrow_mut().update_buffer(&ctx.queue);

        if let Some((width, height)) = self.recreate_textures.take() {
            self.msaa_texture = texture::create_msaa_texture(width, height, &ctx.device);
            self.depth_texture = texture::Texture::create_depth_texture(width, height, &ctx.device);
        }

        let mut encoder = ctx
            .device
            .create_command_encoder(&CommandEncoderDescriptor::default());

        let mut rpass = create_rpass(&mut encoder, &self.msaa_texture, view, &self.depth_texture);

        self.surname_state.render(&mut rpass);
        self.light_source_state.render(&mut rpass);

        drop(rpass);

        ctx.queue.submit([encoder.finish()]);
    }

    fn resize(&mut self, config: &SurfaceConfiguration, _ctx: &WgpuContext) {
        self.recreate_textures = Some((config.width, config.height))
    }
}
