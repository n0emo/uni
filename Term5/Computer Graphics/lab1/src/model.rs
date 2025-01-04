use std::mem;

use lazy_static::lazy_static;
use wgpu::{VertexAttribute, VertexBufferLayout, VertexStepMode};

lazy_static! {
    pub static ref VERTICES: Vec<Vertex> = make_vertices();
}

#[repr(C)]
#[derive(Clone, Copy, bytemuck::Pod, bytemuck::Zeroable)]
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

fn make_vertices() -> Vec<Vertex> {
    let matrix = &[
        b"# # #                      ",
        b"# # #                      ",
        b"# # # ### ##### # # ### ###",
        b"# # # #   # # # # # #   # #",
        b"# # # ### ##### ### ### ###",
        b"# # # #     #   # # #   #  ",
        b"##### ###   #   # # ### #  ",
    ];

    let w = matrix[0].len() as f32;
    let h = matrix.len() as f32;
    let xsize = 1.9 / w;
    let ysize = 1.4 / h;

    let mut vertices = Vec::<Vertex>::new();

    for (y, row) in matrix.iter().enumerate() {
        for (x, elem) in row.iter().enumerate() {
            match elem {
                b' ' => {}
                b'#' => {
                    let x = (x as f32 + 1.0) * xsize - 1.025;
                    let y = 0.65 - (y as f32 + 1.0) * ysize;
                    let col: [f32; 3] = [0.9, 0.1, 0.2];
                    let top_right = Vertex {
                        pos: [x + xsize, y + ysize, 0.0],
                        col,
                    };
                    let top_left = Vertex {
                        pos: [x, y + ysize, 0.0],
                        col,
                    };
                    let bottom_left = Vertex {
                        pos: [x, y, 0.0],
                        col,
                    };
                    let bottom_right = Vertex {
                        pos: [x + xsize, y, 0.0],
                        col,
                    };

                    vertices.extend(&[
                        top_right,
                        top_left,
                        bottom_left,
                        top_right,
                        bottom_left,
                        bottom_right,
                    ])
                }
                _ => unreachable!(),
            }
        }
    }

    vertices
}
