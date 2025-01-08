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
            Vertex { pos: [-1.0, -1.0, -1.0], texture_coord: [0.0, 0.0], }, // 0
            Vertex { pos: [ 1.0, -1.0, -1.0], texture_coord: [1.0, 0.0], }, // 1
            Vertex { pos: [-1.0,  1.0, -1.0], texture_coord: [0.0, 1.0], }, // 2
            Vertex { pos: [ 1.0,  1.0, -1.0], texture_coord: [1.0, 1.0], }, // 3
            Vertex { pos: [-1.0, -1.0,  1.0], texture_coord: [1.0, 1.0], }, // 4
            Vertex { pos: [ 1.0, -1.0,  1.0], texture_coord: [0.0, 1.0], }, // 5
            Vertex { pos: [-1.0,  1.0,  1.0], texture_coord: [1.0, 0.0], }, // 6
            Vertex { pos: [ 1.0,  1.0,  1.0], texture_coord: [0.0, 0.0], }, // 7
        ];

        let vertex_buf = ctx.device.create_buffer_init(&BufferInitDescriptor {
            label: None,
            contents: bytemuck::cast_slice(&vertices),
            usage: BufferUsages::VERTEX,
        });

        #[rustfmt::skip]
        let indices = vec![
            0, 2, 1, 1, 2, 3, // front
            1, 3, 5, 5, 3, 7, // right
            4, 6, 0, 0, 6, 2, // left
            4, 5, 6, 6, 5, 7, // back
            0, 1, 4, 4, 1, 5, // bottom
            2, 6, 7, 7, 3, 2, // top
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
    pub texture_coord: [f32; 2],
}

impl Vertex {
    const ATTRIBUTES: &'static [VertexAttribute] =
        &wgpu::vertex_attr_array![0 => Float32x3, 1 => Float32x2];

    pub fn layout() -> VertexBufferLayout<'static> {
        VertexBufferLayout {
            array_stride: mem::size_of::<Vertex>() as wgpu::BufferAddress,
            step_mode: VertexStepMode::Vertex,
            attributes: Self::ATTRIBUTES,
        }
    }
}
