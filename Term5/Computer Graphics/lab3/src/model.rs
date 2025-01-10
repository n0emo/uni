use std::{mem, ops::Range};

use framework::WgpuContext;
use wgpu::{
    util::{BufferInitDescriptor, DeviceExt as _},
    Buffer, BufferUsages, VertexAttribute, VertexBufferLayout, VertexStepMode,
};

use crate::material::Material;

pub struct Model {
    #[allow(unused)]
    pub vertices: Vec<Vertex>,
    pub vertex_buf: Buffer,
    pub indices: Vec<u16>,
    pub index_buf: Buffer,
    pub material: Material,
}

impl Model {
    pub fn create_cube(material: Material, ctx: &WgpuContext) -> Self {
        #[rustfmt::skip]
        let vertices = vec![
            // front
            Vertex::new([-1.0, -1.0, -1.0], [0.0, 0.0]), // 0
            Vertex::new([ 1.0, -1.0, -1.0], [1.0, 0.0]), // 1
            Vertex::new([-1.0,  1.0, -1.0], [0.0, 1.0]), // 2
            Vertex::new([ 1.0,  1.0, -1.0], [1.0, 1.0]), // 3
            // right
            Vertex::new([ 1.0, -1.0, -1.0], [0.0, 0.0]), // 4
            Vertex::new([ 1.0, -1.0,  1.0], [1.0, 0.0]), // 5
            Vertex::new([ 1.0,  1.0, -1.0], [0.0, 1.0]), // 6
            Vertex::new([ 1.0,  1.0,  1.0], [1.0, 1.0]), // 7
            // back
            Vertex::new([ 1.0, -1.0,  1.0], [0.0, 0.0]), // 8
            Vertex::new([-1.0, -1.0,  1.0], [1.0, 0.0]), // 9
            Vertex::new([ 1.0,  1.0,  1.0], [0.0, 1.0]), // 10
            Vertex::new([-1.0,  1.0,  1.0], [1.0, 1.0]), // 11
            // left
            Vertex::new([-1.0, -1.0,  1.0], [0.0, 0.0]), // 12
            Vertex::new([-1.0, -1.0, -1.0], [1.0, 0.0]), // 13
            Vertex::new([-1.0,  1.0,  1.0], [0.0, 1.0]), // 14
            Vertex::new([-1.0,  1.0, -1.0], [1.0, 1.0]), // 15
            // top
            Vertex::new([-1.0,  1.0, -1.0], [0.0, 0.0]), // 16
            Vertex::new([ 1.0,  1.0, -1.0], [1.0, 0.0]), // 17
            Vertex::new([-1.0,  1.0,  1.0], [0.0, 1.0]), // 18
            Vertex::new([ 1.0,  1.0,  1.0], [1.0, 1.0]), // 19
            // bottom
            Vertex::new([-1.0, -1.0,  1.0], [0.0, 0.0]), // 20
            Vertex::new([ 1.0, -1.0,  1.0], [1.0, 0.0]), // 21
            Vertex::new([-1.0, -1.0, -1.0], [0.0, 1.0]), // 22
            Vertex::new([ 1.0, -1.0, -1.0], [1.0, 1.0]), // 23
        ];

        let vertex_buf = ctx.device.create_buffer_init(&BufferInitDescriptor {
            label: None,
            contents: bytemuck::cast_slice(&vertices),
            usage: BufferUsages::VERTEX,
        });

        #[rustfmt::skip]
        let indices = vec![
            0,  2,  1,  1,  2,  3,  // front
            4,  6,  5,  5,  6,  7,  // right
            8,  10, 9,  9,  10, 11, // back
            12, 14, 13, 13, 14, 15, // left
            16, 18, 17, 17, 18, 19, // top
            20, 22, 21, 21, 22, 23, // bottom
        ];

        let index_buf = ctx.device.create_buffer_init(&BufferInitDescriptor {
            label: None,
            contents: bytemuck::cast_slice(&indices),
            usage: BufferUsages::INDEX,
        });

        Self {
            vertices,
            vertex_buf,
            indices,
            index_buf,
            material,
        }
    }

    pub fn draw(&self, rpass: &mut wgpu::RenderPass, range: Range<u32>) {
        rpass.set_vertex_buffer(0, self.vertex_buf.slice(..));
        rpass.set_index_buffer(self.index_buf.slice(..), wgpu::IndexFormat::Uint16);
        rpass.set_bind_group(0, &self.material.bind_group, &[]);
        rpass.draw_indexed(0..self.indices.len() as u32, 0, range);
    }

    pub fn draw_instanced(&self, rpass: &mut wgpu::RenderPass, buf: &Buffer, len: u32) {
        rpass.set_vertex_buffer(1, buf.slice(..));
        self.draw(rpass, 0..len);
    }
}

#[repr(C)]
#[derive(Clone, Copy, bytemuck::Pod, bytemuck::Zeroable)]
pub struct Vertex {
    pub pos: [f32; 3],
    pub tex_coords: [f32; 2],
}

impl Vertex {
    const ATTRIBUTES: &'static [VertexAttribute] =
        &wgpu::vertex_attr_array![0 => Float32x3, 1 => Float32x2];

    pub fn new(pos: [f32; 3], tex_coords: [f32; 2]) -> Self {
        Self { pos, tex_coords }
    }

    pub fn layout() -> VertexBufferLayout<'static> {
        VertexBufferLayout {
            array_stride: mem::size_of::<Vertex>() as wgpu::BufferAddress,
            step_mode: VertexStepMode::Vertex,
            attributes: Self::ATTRIBUTES,
        }
    }
}
