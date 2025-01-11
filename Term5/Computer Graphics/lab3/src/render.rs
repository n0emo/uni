use std::{cell::RefCell, rc::Rc};

use framework::WgpuContext;
use wgpu::{
    include_wgsl,
    util::{BufferInitDescriptor, DeviceExt as _},
    BindGroupLayout, BlendState, Buffer, BufferUsages, ColorTargetState, ColorWrites,
    CompareFunction, DepthBiasState, DepthStencilState, FragmentState, PipelineCompilationOptions,
    PipelineLayoutDescriptor, PrimitiveState, PrimitiveTopology, RenderPass,
    RenderPassColorAttachment, RenderPassDescriptor, RenderPipeline, RenderPipelineDescriptor,
    ShaderModule, StencilState, SurfaceConfiguration, VertexBufferLayout, VertexState,
};

use crate::{
    camera::Camera,
    instance::{make_surname_instances, Instance},
    light::{Light, LightUniform},
    material::Material,
    model::{Mesh, Model, Vertex},
    texture,
};

pub struct SurnameState {
    pipeline: RenderPipeline,
    cube: Model,
    camera: Rc<RefCell<Camera>>,
    light: Rc<RefCell<Light>>,
    instance_buf: Buffer,
    instance_len: u32,
}

impl SurnameState {
    pub fn new(
        config: &SurfaceConfiguration,
        ctx: &WgpuContext,
        camera: Rc<RefCell<Camera>>,
        light: Rc<RefCell<Light>>,
    ) -> Self {
        let shader = ctx
            .device
            .create_shader_module(include_wgsl!("shader.wgsl"));

        let bind_group_layouts = &[
            &Material::bind_group_layout(&ctx.device),
            &Camera::bind_group_layout(&ctx.device),
            &LightUniform::bind_group_layout(&ctx.device),
        ];
        let vertex_buffers = &[Vertex::layout(), Instance::layout()];
        let pipeline = crate::render::create_pipeline(
            config,
            bind_group_layouts,
            vertex_buffers,
            &shader,
            ctx,
        );

        let fabric_material =
            Material::from_texture_bytes(include_bytes!("../res/fabric_basecolor.png"), ctx)
                .unwrap();

        let cube = Model {
            mesh: Mesh::create_cube(ctx),
            material: fabric_material,
        };

        let instances = make_surname_instances();
        let instance_buf = ctx.device.create_buffer_init(&BufferInitDescriptor {
            label: Some("Surname Instance buffer"),
            contents: bytemuck::cast_slice(&instances),
            usage: BufferUsages::VERTEX,
        });
        let instance_len = instances.len() as u32;

        Self {
            pipeline,
            cube,
            camera,
            light,
            instance_buf,
            instance_len,
        }
    }

    pub fn render(&mut self, rpass: &mut RenderPass) {
        rpass.set_pipeline(&self.pipeline);
        self.camera.borrow_mut().bind(rpass, 1);
        self.light.borrow_mut().bind(rpass, 2);
        self.cube
            .draw_instanced(rpass, &self.instance_buf, self.instance_len);
    }
}

pub fn create_rpass<'a>(
    encoder: &'a mut wgpu::CommandEncoder,
    view: &wgpu::TextureView,
    depth_texture: &texture::Texture,
) -> wgpu::RenderPass<'a> {
    encoder.begin_render_pass(&RenderPassDescriptor {
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
        depth_stencil_attachment: Some(wgpu::RenderPassDepthStencilAttachment {
            view: &depth_texture.view,
            depth_ops: Some(wgpu::Operations {
                load: wgpu::LoadOp::Clear(1.0),
                store: wgpu::StoreOp::Store,
            }),
            stencil_ops: None,
        }),
        ..Default::default()
    })
}

pub struct LightSourceState {
    pipeline: RenderPipeline,
    cube: Mesh,
    camera: Rc<RefCell<Camera>>,
    light: Rc<RefCell<Light>>,
}

impl LightSourceState {
    pub fn new(
        config: &SurfaceConfiguration,
        ctx: &WgpuContext,
        camera: Rc<RefCell<Camera>>,
        light: Rc<RefCell<Light>>,
    ) -> Self {
        let shader = ctx.device.create_shader_module(include_wgsl!("light.wgsl"));

        let bind_group_layouts = &[
            &Camera::bind_group_layout(&ctx.device),
            &LightUniform::bind_group_layout(&ctx.device),
        ];
        let vertex_buffers = &[Vertex::layout()];
        let pipeline = create_pipeline(config, bind_group_layouts, vertex_buffers, &shader, ctx);

        let cube = Mesh::create_cube(ctx);

        Self {
            pipeline,
            cube,
            camera,
            light,
        }
    }

    pub fn render(&mut self, rpass: &mut RenderPass) {
        rpass.set_pipeline(&self.pipeline);
        self.camera.borrow_mut().bind(rpass, 0);
        self.light.borrow_mut().bind(rpass, 1);
        self.cube.draw(rpass, 0..1);
    }
}

fn create_pipeline(
    config: &SurfaceConfiguration,
    bind_group_layouts: &[&BindGroupLayout],
    vertex_buffers: &[VertexBufferLayout],
    shader: &ShaderModule,
    ctx: &WgpuContext,
) -> RenderPipeline {
    ctx.device
        .create_render_pipeline(&RenderPipelineDescriptor {
            label: Some("Render Pipeline"),
            layout: Some(
                &ctx.device
                    .create_pipeline_layout(&PipelineLayoutDescriptor {
                        label: Some("Pipeline Layout"),
                        bind_group_layouts,
                        push_constant_ranges: &[],
                    }),
            ),
            vertex: VertexState {
                module: shader,
                entry_point: Some("vs_main"),
                compilation_options: PipelineCompilationOptions::default(),
                buffers: vertex_buffers,
            },
            fragment: Some(FragmentState {
                module: shader,
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
                count: 1,
                mask: !0,
                alpha_to_coverage_enabled: false,
            },
            multiview: None,
            cache: None,
        })
}
