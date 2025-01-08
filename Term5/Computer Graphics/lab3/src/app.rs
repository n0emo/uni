use framework::WgpuContext;
use wgpu::{
    BlendState, ColorTargetState, ColorWrites, CommandEncoderDescriptor, FragmentState,
    PipelineCompilationOptions, PipelineLayoutDescriptor, PrimitiveState, PrimitiveTopology,
    RenderPassColorAttachment, RenderPassDescriptor, RenderPipeline, RenderPipelineDescriptor,
    VertexState,
};

use crate::{
    camera::{Camera, CameraParams},
    material::Material,
    model::{Model, Vertex},
};

pub struct Application {
    pipeline: RenderPipeline,
    cube: Model,
    camera: Camera,
    time: f32,
}

impl framework::Application for Application {
    const NAME: &str = "ЛР№3.";

    const DESCRIPTION: &str = "Лабораторная работа №3";

    fn init(config: &wgpu::SurfaceConfiguration, ctx: &WgpuContext) -> Self {
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
                    buffers: &[Vertex::layout()],
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
                depth_stencil: None,
                multisample: wgpu::MultisampleState {
                    count: 1,
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

        Self {
            pipeline,
            cube,
            camera,
            time: 0.0,
        }
    }

    fn render(&mut self, view: &wgpu::TextureView, dt: f32, ctx: &WgpuContext) {
        self.time += dt;

        self.camera.params.eye.y = (self.time * 0.7).sin() * 3.0;
        self.camera.params.eye.x = self.time.sin() * 5.0;
        self.camera.params.eye.z = self.time.cos() * 5.0;
        self.camera.update_buffer(&ctx.queue);

        let mut encoder = ctx
            .device
            .create_command_encoder(&CommandEncoderDescriptor::default());

        let mut rpass = encoder.begin_render_pass(&RenderPassDescriptor {
            label: Some("Render Pass"),
            color_attachments: &[Some(RenderPassColorAttachment {
                view,
                resolve_target: None,
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
            ..Default::default()
        });

        rpass.set_pipeline(&self.pipeline);
        self.camera.bind(&mut rpass);
        self.cube.draw(&mut rpass);

        drop(rpass);

        ctx.queue.submit(std::iter::once(encoder.finish()));
    }
}
