use std::f32::consts::PI;

use framework::WgpuContext;
use wgpu::{
    util::{BufferInitDescriptor, DeviceExt as _}, BindGroup, BindGroupDescriptor, BindGroupEntry, BindGroupLayoutDescriptor, BindGroupLayoutEntry, BindingType, BlendState, Buffer, BufferBindingType, BufferUsages, ColorTargetState, ColorWrites, CommandEncoderDescriptor, FragmentState, Operations, PipelineCompilationOptions, PrimitiveState, RenderPassColorAttachment, RenderPassDescriptor, RenderPipelineDescriptor, ShaderStages, VertexAttribute, VertexBufferLayout, VertexState, VertexStepMode
};
use winit::{event::WindowEvent, keyboard::{KeyCode, PhysicalKey}};

#[repr(C)]
#[derive(Debug, Clone, Copy, bytemuck::Pod, bytemuck::Zeroable, Default)]
struct StateUniform {
    time: f32,
    width: f32,
    height: f32,
    camera_angle_horizontal: f32,
    camera_angle_vertical: f32,
    camera_zoom: f32,
}

#[derive(Default, Debug)]
struct CameraController {
    rotate_left: bool,
    rotate_right: bool,
    rotate_up: bool,
    rotate_down: bool,
    zoom_in: bool,
    zoom_out: bool,
}

pub struct Application {
    pipeline: wgpu::RenderPipeline,
    vertex_buf: wgpu::Buffer,
    state_uniform: StateUniform,
    state_buffer: Buffer,
    state_bind_group: BindGroup,
    camera_controler: CameraController,
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
            usage: BufferUsages::VERTEX,
        });

        let state_uniform = StateUniform {
            width: config.width as f32,
            height: config.height as f32,
            camera_zoom: 2.0,
            ..Default::default()
        };

        let state_buffer = ctx.device.create_buffer_init(&BufferInitDescriptor {
            label: Some("State Uniform Buffer"),
            contents: bytemuck::bytes_of(&state_uniform),
            usage: BufferUsages::UNIFORM | BufferUsages::COPY_DST,
        });

        let state_bind_group_layout = ctx.device.create_bind_group_layout(&BindGroupLayoutDescriptor {
            label: Some("State Uniform Bind Group Layout"),
            entries: &[BindGroupLayoutEntry {
                binding: 0,
                visibility: ShaderStages::VERTEX_FRAGMENT,
                ty: BindingType::Buffer {
                    ty: BufferBindingType::Uniform,
                    has_dynamic_offset: false,
                    min_binding_size: None,
                },
                count: None,
            }],
        });

        let state_bind_group = ctx.device.create_bind_group(&BindGroupDescriptor {
            label: Some("State Uniform Bind Group"),
            layout: &state_bind_group_layout,
            entries: &[BindGroupEntry {
                binding: 0,
                resource: state_buffer.as_entire_binding(),
            }],
        });

        let pipeline =
            ctx.device
                .create_render_pipeline(&RenderPipelineDescriptor {
                    label: Some("Ray Marching Render Pipeline"),
                    layout: Some(&ctx.device.create_pipeline_layout(
                        &wgpu::PipelineLayoutDescriptor {
                            label: Some("Ray Marching Pipeline Layout"),
                            bind_group_layouts: &[&state_bind_group_layout],
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

        let camera_controler = CameraController::default();

        Self {
            pipeline,
            vertex_buf,
            state_uniform,
            state_buffer,
            state_bind_group,
            camera_controler,
        }
    }

    fn render(
        &mut self,
        view: &wgpu::TextureView,
        dt: f32,
        WgpuContext {
            instance: _,
            adapter: _,
            device,
            queue,
        }: &WgpuContext,
    ) {
        self.state_uniform.time += dt;

        {
            let c = &self.camera_controler;
            let u = &mut self.state_uniform;
            let a_s = dt;
            let z_s = dt * 3.0;

            if c.rotate_left  { u.camera_angle_horizontal -= a_s; }
            if c.rotate_right { u.camera_angle_horizontal += a_s; }
            if c.rotate_up    { u.camera_angle_vertical   += a_s;}
            if c.rotate_down  { u.camera_angle_vertical   -= a_s;}
            if c.zoom_in      { u.camera_zoom             -= z_s;}
            if c.zoom_out     { u.camera_zoom             += z_s;}

            u.camera_zoom = u.camera_zoom.clamp(0.01, 10.0);
            u.camera_angle_vertical %= 2.0 * PI;
            u.camera_angle_vertical =  u.camera_angle_vertical.clamp(0.0, PI * 0.3);
            u.camera_angle_horizontal %= 2.0 * PI;
        }

        queue.write_buffer(&self.state_buffer, 0, bytemuck::bytes_of(&self.state_uniform));

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
        rpass.set_bind_group(0, &self.state_bind_group, &[]);
        rpass.draw(0..6, 0..1);

        drop(rpass);

        queue.submit(std::iter::once(encoder.finish()));
    }

    fn update(&mut self, event: WindowEvent) {
        match event {
            WindowEvent::KeyboardInput { device_id: _, event, is_synthetic: _ } => {
                let PhysicalKey::Code(code) = event.physical_key else {
                    return;
                };

                let pressed = event.state.is_pressed();

                match code {
                    KeyCode::KeyW => self.camera_controler.rotate_up    = pressed,
                    KeyCode::KeyS => self.camera_controler.rotate_down  = pressed,
                    KeyCode::KeyA => self.camera_controler.rotate_left  = pressed,
                    KeyCode::KeyD => self.camera_controler.rotate_right = pressed,
                    KeyCode::KeyQ => self.camera_controler.zoom_in      = pressed,
                    KeyCode::KeyE => self.camera_controler.zoom_out     = pressed,
                    _ => {},
                }

            },
            WindowEvent::CursorMoved { device_id: _, position: _ } => {},
            WindowEvent::MouseWheel { device_id: _, delta: _, phase: _ } => {},
            WindowEvent::MouseInput { device_id: _, state: _, button: _ } => {},
            WindowEvent::TouchpadMagnify { device_id: _, delta: _, phase: _ } => {},
            WindowEvent::SmartMagnify { device_id: _ } => {},
            WindowEvent::Touch(_touch) => {},
            _ => {},
        }
    }

    fn resize(&mut self, config: &wgpu::SurfaceConfiguration, _ctx: &WgpuContext) {
        self.state_uniform.width = config.width as f32;
        self.state_uniform.height = config.height as f32;
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
