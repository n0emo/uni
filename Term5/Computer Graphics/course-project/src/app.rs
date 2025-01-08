use framework::WgpuContext;
use wgpu::{
    util::{BufferInitDescriptor, DeviceExt as _},
    BlendState, ColorTargetState, ColorWrites, CommandEncoderDescriptor, FragmentState, Operations,
    PipelineCompilationOptions, PrimitiveState, RenderPassColorAttachment, RenderPassDescriptor,
    RenderPipelineDescriptor, VertexAttribute, VertexBufferLayout, VertexState, VertexStepMode,
};

pub struct Application {
    pipeline: wgpu::RenderPipeline,
    vertex_buf: wgpu::Buffer,
}

impl framework::Application for Application {
    const NAME: &str = "КП. Ray marching";

    const DESCRIPTION: &str =
        "Курсовой проект - реализация трёхмерной сцены с помощью Ray marching";

    fn init(config: &wgpu::SurfaceConfiguration, ctx: &WgpuContext) -> Self {
        let shader = ctx
            .device
            .create_shader_module(wgpu::include_wgsl!("shader.wgsl"));

        let vertices: [Vertex; 6] = [
            Vertex { pos: [1.0, 1.0] },
            Vertex { pos: [-1.0, 1.0] },
            Vertex { pos: [-1.0, -1.0] },
            Vertex { pos: [-1.0, -1.0] },
            Vertex { pos: [1.0, -1.0] },
            Vertex { pos: [1.0, 1.0] },
        ];

        let vertex_buf = ctx.device.create_buffer_init(&BufferInitDescriptor {
            label: Some("Screen Buffer"),
            contents: bytemuck::cast_slice(&vertices),
            usage: wgpu::BufferUsages::VERTEX,
        });

        let pipeline =
            ctx.device
                .create_render_pipeline(&RenderPipelineDescriptor {
                    label: Some("Ray Marching Render Pipeline"),
                    layout: Some(&ctx.device.create_pipeline_layout(
                        &wgpu::PipelineLayoutDescriptor {
                            label: Some("Ray MArching Pipeline Layout"),
                            bind_group_layouts: &[],
                            push_constant_ranges: &[],
                        },
                    )),
                    vertex: VertexState {
                        module: &shader,
                        entry_point: Some("vs_main"),
                        compilation_options: PipelineCompilationOptions::default(),
                        buffers: &[Vertex::layout()],
                    },
                    fragment: Some(FragmentState {
                        module: &shader,
                        entry_point: Some("fs_main"),
                        targets: &[Some(ColorTargetState {
                            format: config.view_formats[0],
                            blend: Some(BlendState::ALPHA_BLENDING),
                            write_mask: ColorWrites::ALL,
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
                    depth_stencil: None,
                    multisample: wgpu::MultisampleState {
                        count: 1,
                        mask: !0,
                        alpha_to_coverage_enabled: false,
                    },
                    multiview: None,
                    cache: None,
                });

        Self {
            pipeline,
            vertex_buf,
        }
    }

    fn render(
        &mut self,
        view: &wgpu::TextureView,
        _dt: f32,
        WgpuContext {
            instance: _,
            adapter: _,
            device,
            queue,
        }: &WgpuContext,
    ) {
        let mut encoder = device.create_command_encoder(&CommandEncoderDescriptor {
            label: Some("Ray Marching Command Encoder"),
        });

        let mut rpass = encoder.begin_render_pass(&RenderPassDescriptor {
            label: Some("Ray Marching Render Pass"),
            color_attachments: &[Some(RenderPassColorAttachment {
                view,
                resolve_target: None,
                ops: Operations {
                    load: wgpu::LoadOp::Clear(wgpu::Color {
                        r: 0.0,
                        g: 0.0,
                        b: 0.0,
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
        rpass.draw(0..6, 0..1);

        drop(rpass);

        queue.submit(std::iter::once(encoder.finish()));
    }
}

#[repr(C)]
#[derive(Clone, Copy, bytemuck::Pod, bytemuck::Zeroable)]
pub struct Vertex {
    pub pos: [f32; 2],
}

impl Vertex {
    const ATTRIBUTES: &'static [VertexAttribute] = &wgpu::vertex_attr_array![0 => Float32x2];

    pub fn layout() -> VertexBufferLayout<'static> {
        VertexBufferLayout {
            array_stride: std::mem::size_of::<Vertex>() as wgpu::BufferAddress,
            step_mode: VertexStepMode::Vertex,
            attributes: Self::ATTRIBUTES,
        }
    }
}
