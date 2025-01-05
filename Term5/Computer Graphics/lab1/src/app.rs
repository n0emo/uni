use framework::WgpuContext;
use wgpu::{
    include_wgsl,
    util::{BufferInitDescriptor, DeviceExt as _},
    CommandEncoderDescriptor, MultisampleState, Operations, PipelineCompilationOptions,
    PrimitiveState, RenderPassDescriptor, RenderPipeline, RenderPipelineDescriptor,
    SurfaceConfiguration, TextureView,
};

use crate::model::{Vertex, VERTICES};

pub struct Application {
    pipeline: RenderPipeline,
    vertex_buf: wgpu::Buffer,
}

impl framework::Application for Application {
    const NAME: &str = "ЛР№1. Фамилия на WebGPU";

    const DESCRIPTION: &str = "Лабораторная рабоа №1 - Вывод на экран графического примитива (отрисовка фамилии с помощью WebGPU)";

    fn init(
        config: &SurfaceConfiguration,
        WgpuContext {
            instance: _,
            adapter: _,
            device,
            queue: _,
        }: &WgpuContext,
    ) -> Self {
        let shader = device.create_shader_module(include_wgsl!("shader.wgsl"));

        let pipeline = device.create_render_pipeline(&RenderPipelineDescriptor {
            label: Some("Render Pipeline"),
            layout: Some(
                &device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
                    label: Some("Pipeline Layout"),
                    bind_group_layouts: &[],
                    push_constant_ranges: &[],
                }),
            ),
            vertex: wgpu::VertexState {
                module: &shader,
                entry_point: Some("vs_main"),
                buffers: &[Vertex::layout()],
                compilation_options: PipelineCompilationOptions::default(),
            },
            fragment: Some(wgpu::FragmentState {
                module: &shader,
                entry_point: Some("fs_main"),
                compilation_options: PipelineCompilationOptions::default(),
                targets: &[Some(wgpu::ColorTargetState {
                    format: config.view_formats[0],
                    blend: Some(wgpu::BlendState::ALPHA_BLENDING),
                    write_mask: wgpu::ColorWrites::ALL,
                })],
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
            label: Some("Surname Vertex Buffer"),
            contents: bytemuck::cast_slice(&VERTICES),
            usage: wgpu::BufferUsages::VERTEX,
        });

        Self {
            pipeline,
            vertex_buf,
        }
    }

    fn render(
        &mut self,
        view: &TextureView,
        WgpuContext {
            instance: _,
            adapter: _,
            device,
            queue,
        }: &WgpuContext,
    ) {
        let mut encoder = device.create_command_encoder(&CommandEncoderDescriptor {
            label: Some("Render Encoder"),
        });

        let mut rpass = encoder.begin_render_pass(&RenderPassDescriptor {
            label: Some("Render Pass"),
            color_attachments: &[Some(wgpu::RenderPassColorAttachment {
                view,
                resolve_target: None,
                ops: Operations {
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
        let len = VERTICES.len();
        rpass.draw(0..len as u32, 0..1);

        drop(rpass);

        queue.submit(std::iter::once(encoder.finish()));
    }
}
