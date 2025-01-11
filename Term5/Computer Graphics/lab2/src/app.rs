use framework::WgpuContext;
use wgpu::{
    util::{BufferInitDescriptor, DeviceExt as _},
    ColorTargetState, CommandEncoderDescriptor, FragmentState, MultisampleState,
    PipelineCompilationOptions, PipelineLayoutDescriptor, PrimitiveState, RenderPassDescriptor,
    RenderPipeline, RenderPipelineDescriptor, TextureView, VertexState,
};

use crate::model::{Vertex, CUBE};

pub struct Application {
    pipeline: RenderPipeline,
    vertex_buf: wgpu::Buffer,
    index_buf: wgpu::Buffer,
}

impl framework::Application for Application {
    const NAME: &str = "ЛР№2. 3D-объект";

    const DESCRIPTION: &str = "Лабораторная работа №2 - Вывод на экран трёхмерного изображения";

    fn required_features() -> wgpu::Features {
        wgpu::Features::empty()
    }

    fn init(
        config: &wgpu::SurfaceConfiguration,
        WgpuContext {
            instance: _,
            adapter: _,
            device,
            queue: _,
        }: &WgpuContext,
    ) -> Self {
        let shader = device.create_shader_module(wgpu::include_wgsl!("shader.wgsl"));

        let pipeline = device.create_render_pipeline(&RenderPipelineDescriptor {
            label: Some("3D Pipeline"),
            layout: Some(&device.create_pipeline_layout(&PipelineLayoutDescriptor {
                label: Some("3D Pipeline Layout"),
                bind_group_layouts: &[],
                push_constant_ranges: &[],
            })),
            vertex: VertexState {
                module: &shader,
                entry_point: Some("vs_main"),
                buffers: &[Vertex::layout()],
                compilation_options: PipelineCompilationOptions::default(),
            },
            fragment: Some(FragmentState {
                module: &shader,
                entry_point: Some("fs_main"),
                targets: &[Some(ColorTargetState {
                    format: config.view_formats[0],
                    blend: Some(wgpu::BlendState::ALPHA_BLENDING),
                    write_mask: wgpu::ColorWrites::ALL,
                })],
                compilation_options: PipelineCompilationOptions::default(),
            }),
            primitive: PrimitiveState {
                topology: wgpu::PrimitiveTopology::TriangleList,
                strip_index_format: None,
                front_face: wgpu::FrontFace::Ccw,
                cull_mode: Some(wgpu::Face::Back),
                polygon_mode: wgpu::PolygonMode::Fill,
                unclipped_depth: false,
                conservative: false,
            },
            multisample: MultisampleState {
                count: 1,
                mask: !0,
                alpha_to_coverage_enabled: false,
            },
            depth_stencil: None,
            multiview: None,
            cache: None,
        });

        let vertex_buf = device.create_buffer_init(&BufferInitDescriptor {
            label: Some("3D Object Vertex Buffer"),
            contents: bytemuck::cast_slice(&CUBE.vertices),
            usage: wgpu::BufferUsages::VERTEX,
        });

        let index_buf = device.create_buffer_init(&BufferInitDescriptor {
            label: Some("3D Object Index Buffer"),
            contents: bytemuck::cast_slice(&CUBE.indices),
            usage: wgpu::BufferUsages::INDEX,
        });

        Self {
            pipeline,
            vertex_buf,
            index_buf,
        }
    }

    fn render(
        &mut self,
        view: &TextureView,
        _dt: f32,
        WgpuContext {
            instance: _,
            adapter: _,
            device,
            queue,
        }: &WgpuContext,
    ) {
        let mut encoder = device.create_command_encoder(&CommandEncoderDescriptor {
            label: Some("Command Encoder"),
        });

        let mut rpass = encoder.begin_render_pass(&RenderPassDescriptor {
            label: Some("Render Pass"),
            color_attachments: &[Some(wgpu::RenderPassColorAttachment {
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
            depth_stencil_attachment: None,
            timestamp_writes: None,
            occlusion_query_set: None,
        });

        rpass.set_pipeline(&self.pipeline);
        rpass.set_vertex_buffer(0, self.vertex_buf.slice(..));
        rpass.set_index_buffer(self.index_buf.slice(..), wgpu::IndexFormat::Uint16);
        let len = CUBE.indices.len() as u32;
        rpass.draw_indexed(0..len, 0, 0..1);

        drop(rpass);

        queue.submit(std::iter::once(encoder.finish()));
    }
}
