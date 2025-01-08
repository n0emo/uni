use std::{f32::consts::PI, mem};

use cgmath::{vec3, Basis3, InnerSpace as _, Rad, Rotation as _, Rotation3 as _};
use lazy_static::lazy_static;
use wgpu::{VertexAttribute, VertexBufferLayout, VertexStepMode};

lazy_static! {
    pub static ref CUBE: Cube = make_cube();
}

#[repr(C)]
#[derive(Clone, Copy, bytemuck::Pod, bytemuck::Zeroable, Debug)]
pub struct Vertex {
    pub pos: [f32; 3],
    pub col: [f32; 3],
}

impl Vertex {
    const ATTRIBUTES: &'static [VertexAttribute] =
        &wgpu::vertex_attr_array![0 => Float32x3, 1 => Float32x3];

    pub fn layout() -> VertexBufferLayout<'static> {
        VertexBufferLayout {
            array_stride: mem::size_of::<Vertex>() as wgpu::BufferAddress,
            step_mode: VertexStepMode::Vertex,
            attributes: Self::ATTRIBUTES,
        }
    }
}

#[derive(Debug)]
pub struct Cube {
    pub vertices: Vec<Vertex>,
    pub indices: Vec<u16>,
}

fn make_cube() -> Cube {
    #[rustfmt::skip]
    let vertices = [
        vec3(-1.0, -1.0, -1.0),
        vec3( 1.0, -1.0, -1.0),
        vec3(-1.0,  1.0, -1.0),
        vec3( 1.0,  1.0, -1.0),
        vec3(-1.0, -1.0,  1.0),
        vec3( 1.0, -1.0,  1.0),
        vec3(-1.0,  1.0,  1.0),
        vec3( 1.0,  1.0,  1.0),
    ]
    .into_iter()
    .map(|v| v * 0.2)
    .map(|v| {
        Basis3::from_axis_angle(vec3(1.0, 1.0, 1.0).normalize(), Rad(PI * 0.2)).rotate_vector(v)
    })
    .map(|v| vec3(v.x, v.y, v.z.clamp(0.0, 1.0)));

    let colors = [
        vec3(1.0, 0.2, 0.2),
        vec3(0.2, 1.0, 0.2),
        vec3(0.2, 0.2, 1.0),
        vec3(1.0, 0.2, 1.0),
        vec3(1.0, 0.3, 0.2),
        vec3(1.0, 1.0, 0.5),
        vec3(0.4, 0.2, 1.0),
        vec3(0.5, 0.2, 0.5),
    ];

    let vertices = vertices
        .zip(colors.into_iter().cycle())
        .map(|(v, c)| Vertex {
            pos: v.into(),
            col: c.into(),
        })
        .collect();

    #[rustfmt::skip]
    let indices = vec![
        0, 2, 1, 1, 2, 3, // front
        1, 3, 5, 5, 3, 7, // right
        4, 6, 0, 0, 6, 2, // left
        4, 5, 6, 6, 5, 7, // back
        0, 1, 4, 4, 1, 5, // bottom
        2, 6, 7, 7, 3, 2, // top
    ];

Cube { vertices, indices }
}
