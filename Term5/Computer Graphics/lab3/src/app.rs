use std::f32::consts::PI;

use framework::WgpuContext;
use wgpu::{
    util::{BufferInitDescriptor, DeviceExt}, BlendState, Buffer, BufferUsages, ColorTargetState, ColorWrites, CommandEncoderDescriptor, CompareFunction, DepthBiasState, DepthStencilState, FragmentState, PipelineCompilationOptions, PipelineLayoutDescriptor, PrimitiveState, PrimitiveTopology, RenderPassColorAttachment, RenderPassDescriptor, RenderPipeline, RenderPipelineDescriptor, StencilState, SurfaceConfiguration, TextureDescriptor, VertexState
};

use crate::{
    camera::{Camera, CameraParams}, instance::{make_surname_instances, Instance}, material::Material, model::{Model, Vertex}, texture, SAMPLE_COUNT
};

pub struct Application {
    pipeline: RenderPipeline,
    cube: Model,
    camera: Camera,
    time: f32,
    instance_buf: Buffer,
    instance_len: u32,
    recreate_textures: Option<(u32, u32)>,
    msaa_texture: wgpu::TextureView,
    depth_texture: texture::Texture,
}

impl framework::Application for Application {
    const NAME: &str = "ЛР№3.";

    const DESCRIPTION: &str = "Лабораторная работа №3";

    fn init(config: &SurfaceConfiguration, ctx: &WgpuContext) -> Self {
        let shader = ctx
            .device
            .create_shader_module(wgpu::include_wgsl!("shader.wgsl"));

        let pipeline = ctx
            .device
            .create_render_pipeline(&RenderPipelineDescriptor {
                label: Some("Render Pipeline"),
                layout: Some(
                    &ctx.device
                        .create_pipeline_layout(&PipelineLayoutDescriptor {
                            label: Some("Pipeline Layout"),
                            bind_group_layouts: &[
                                &Material::bind_group_layout(&ctx.device),
                                &Camera::bind_group_layout(&ctx.device),
                            ],
                            push_constant_ranges: &[],
                        }),
                ),
                vertex: VertexState {
                    module: &shader,
                    entry_point: Some("vs_main"),
                    compilation_options: PipelineCompilationOptions::default(),
                    buffers: &[Vertex::layout(), Instance::layout()],
                },
                fragment: Some(FragmentState {
                    module: &shader,
                    entry_point: Some("fs_main"),
                    compilation_options: PipelineCompilationOptions::default(),
                    targets: &[Some(ColorTargetState {
                        format: config.view_formats[0],
                        blend: Some(BlendState::ALPHA_BLENDING),
                        write_mask: ColorWrites::ALL,
                    })],
                }),
                primitive: PrimitiveState {
                    topology: PrimitiveTopology::TriangleList,
                    strip_index_format: None,
                    front_face: wgpu::FrontFace::Ccw,
                    cull_mode: Some(wgpu::Face::Back),
                    unclipped_depth: false,
                    polygon_mode: wgpu::PolygonMode::Fill,
                    conservative: false,
                },
                depth_stencil: Some(DepthStencilState {
                    format: texture::Texture::DEPTH_FORMAT,
                    depth_write_enabled: true,
                    depth_compare: CompareFunction::Less,
                    stencil: StencilState::default(),
                    bias: DepthBiasState::default(),
                }),
                multisample: wgpu::MultisampleState {
                    count: SAMPLE_COUNT,
                    mask: !0,
                    alpha_to_coverage_enabled: false,
                },
                multiview: None,
                cache: None,
            });

        let fabric_material = Material::from_texture_bytes(
            include_bytes!("../res/fabric_basecolor.png"),
            include_bytes!("../res/fabric_normal.png"),
            ctx,
        )
        .unwrap();

        let cube = Model::create_cube(fabric_material, ctx);

        let camera = Camera::new(
            &ctx.device,
            CameraParams {
                eye: (0.0, 3.0, 0.0).into(),
                ..Default::default()
            },
        );

        let instances = make_surname_instances();
        let instance_buf = ctx.device.create_buffer_init(&BufferInitDescriptor {
            label: Some("Surname Instance buffer"),
            contents: bytemuck::cast_slice(&instances),
            usage: BufferUsages::VERTEX,
        });
        let instance_len = instances.len() as u32;

        let msaa_texture = texture::create_msaa_texture(config.width, config.height, &ctx.device);
        let depth_texture = texture::Texture::create_depth_texture(config.width, config.height, &ctx.device);

        Self {
            pipeline,
            cube,
            camera,
            time: 0.0,
            instance_buf,
            instance_len,
            recreate_textures: None,
            msaa_texture,
            depth_texture,
        }
    }

    fn render(&mut self, view: &wgpu::TextureView, dt: f32, ctx: &WgpuContext) {
        self.time += dt;

        let zoom = ((self.time * 0.6).sin() + 3.5) * 10.0;
        self.camera.params.eye.y = (self.time * 0.2).sin() * 5.0;
        self.camera.params.eye.x = (self.time * 0.3 - PI * 0.7).sin() * zoom;
        self.camera.params.eye.z = (self.time * 0.3 - PI * 0.7).cos() * zoom;
        self.camera.update_buffer(&ctx.queue);

        if let Some((width, height)) = self.recreate_textures.take() {
            self.msaa_texture = texture::create_msaa_texture(width, height, &ctx.device);
            self.depth_texture = texture::Texture::create_depth_texture(width, height, &ctx.device);
        }

        let mut encoder = ctx
            .device
            .create_command_encoder(&CommandEncoderDescriptor::default());

        let mut rpass = encoder.begin_render_pass(&RenderPassDescriptor {
            label: Some("Render Pass"),
            color_attachments: &[Some(RenderPassColorAttachment {
                view: &self.msaa_texture,
                resolve_target: Some(view),
                ops: wgpu::Operations {
                    load: wgpu::LoadOp::Clear(wgpu::Color {
                        r: 0.1,
                        g: 0.1,
                        b: 0.1,
                        a: 1.0,
                    }),
                    store: wgpu::StoreOp::Store,
                },
            })],
            depth_stencil_attachment: Some(wgpu::RenderPassDepthStencilAttachment {
                view: &self.depth_texture.view,
                depth_ops: Some(wgpu::Operations {
                    load: wgpu::LoadOp::Clear(1.0),
                    store: wgpu::StoreOp::Store,
                }),
                stencil_ops: None,
            }),
            ..Default::default()
        });

        rpass.set_pipeline(&self.pipeline);
        self.camera.bind(&mut rpass);
        self.cube
            .draw_instanced(&mut rpass, &self.instance_buf, self.instance_len);

        drop(rpass);

        ctx.queue.submit(std::iter::once(encoder.finish()));
    }

    fn resize(&mut self, config: &SurfaceConfiguration, _ctx: &WgpuContext) {
        self.recreate_textures = Some((config.width, config.height))
    }
}

