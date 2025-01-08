use std::mem;

use wgpu::{BufferAddress, VertexBufferLayout, VertexStepMode};

#[repr(C)]
#[derive(Clone, Copy, bytemuck::Pod, bytemuck::Zeroable)]
pub struct Instance {
    pub pos: [f32; 3],
}

impl Instance {
    const ATTRIBUTES: &[wgpu::VertexAttribute] = &wgpu::vertex_attr_array![2 => Float32x3];

    pub fn layout() -> VertexBufferLayout<'static> {
        VertexBufferLayout {
            array_stride: mem::size_of::<Instance>() as BufferAddress,
            step_mode: VertexStepMode::Instance,
            attributes: Self::ATTRIBUTES,
        }
    }
}

pub fn make_surname_instances() -> Vec<Instance> {
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

    #[rustfmt::skip]
    let mut instances = Vec::new();

    for (y, row) in matrix.iter().enumerate() {
        for (x, elem) in row.iter().enumerate() {
            match elem {
                b' ' => {}
                b'#' => {
                    let x = x as f32 * 2.0;
                    let y = y as f32 * 2.0;
                    instances.push(Instance {
                        pos: [x - w, h - y, 0.0],
                    });
                }
                _ => unreachable!(),
            }
        }
    }

    instances
}
