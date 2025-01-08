use cgmath::{perspective, Deg, Matrix4, Point3, Vector3};
use wgpu::{
    util::DeviceExt as _, BindGroup, BindGroupDescriptor, BindGroupLayout,
    BindGroupLayoutDescriptor, BindingType, Buffer, BufferUsages, Device, Queue, RenderPass,
    ShaderStages,
};

pub struct Camera {
    pub params: CameraParams,
    pub buffer: Buffer,
    pub bind_group: BindGroup,
}

impl Camera {
    pub fn bind(&self, rpass: &mut RenderPass) {
        rpass.set_bind_group(1, &self.bind_group, &[]);
    }

    pub fn update_buffer(&self, queue: &Queue) {
        let matrix = self.params.compute_view_projection_matrix();
        queue.write_buffer(&self.buffer, 0, bytemuck::bytes_of(&matrix));
    }

    pub fn new(device: &Device, params: CameraParams) -> Self {
        let (buffer, bind_group) = Self::create_buffer(&params, &device);
        Self {
            params,
            buffer,
            bind_group,
        }
    }

    pub fn create_buffer(params: &CameraParams, device: &Device) -> (Buffer, BindGroup) {
        let buffer = device.create_buffer_init(&wgpu::util::BufferInitDescriptor {
            label: Some("Camera Buffer"),
            usage: BufferUsages::UNIFORM | BufferUsages::COPY_DST,
            contents: bytemuck::bytes_of(&params.compute_view_projection_matrix()),
        });

        let bind_group = Self::bind_group(device, &buffer);

        (buffer, bind_group)
    }

    pub fn bind_group_layout(device: &Device) -> BindGroupLayout {
        device.create_bind_group_layout(&BindGroupLayoutDescriptor {
            label: Some("Camera Bind Group Layout"),
            entries: &[wgpu::BindGroupLayoutEntry {
                binding: 0,
                visibility: ShaderStages::VERTEX,
                ty: BindingType::Buffer {
                    ty: wgpu::BufferBindingType::Uniform,
                    has_dynamic_offset: false,
                    min_binding_size: None,
                },
                count: None,
            }],
        })
    }

    pub fn bind_group(device: &Device, buf: &Buffer) -> BindGroup {
        device.create_bind_group(&BindGroupDescriptor {
            label: Some("Camera Bind Group"),
            layout: &Self::bind_group_layout(device),
            entries: &[wgpu::BindGroupEntry {
                binding: 0,
                resource: buf.as_entire_binding(),
            }],
        })
    }
}

pub struct CameraParams {
    pub eye: Point3<f32>,
    pub target: Point3<f32>,
    pub up: Vector3<f32>,
    pub fovy: Deg<f32>,
    pub aspect: f32,
    pub znear: f32,
    pub zfar: f32,
}

impl CameraParams {
    #[rustfmt::skip]
    pub const OPENGL_TO_WGPU_MATRIX: Matrix4<f32> = Matrix4::new(
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 0.5, 0.5,
        0.0, 0.0, 0.0, 1.0,
    );

    pub fn compute_view_projection_matrix(&self) -> [[f32; 4]; 4] {
        let view = Matrix4::look_at_rh(self.eye, self.target, self.up);
        let proj = perspective(self.fovy, self.aspect, self.znear, self.zfar);
        let matrix = Self::OPENGL_TO_WGPU_MATRIX * proj * view;
        matrix.into()
    }
}

impl Default for CameraParams {
    fn default() -> Self {
        Self {
            eye: Point3 {
                x: 0.0,
                y: 0.0,
                z: 0.0,
            },
            target: Point3 {
                x: 0.0,
                y: 0.0,
                z: 0.0,
            },
            up: Vector3::unit_y(),
            fovy: Deg(45.0),
            aspect: 16.0 / 9.0,
            znear: 0.1,
            zfar: 100.0,
        }
    }
}
