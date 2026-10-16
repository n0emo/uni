use wgpu::{
    util::{BufferInitDescriptor, DeviceExt as _},
    BindGroup, BindGroupDescriptor, BindGroupEntry, BindGroupLayout, BindGroupLayoutDescriptor,
    BindingType, Buffer, BufferBindingType, Device, Queue, RenderPass, ShaderStages,
};

pub struct Light {
    pub light_uniform: LightUniform,
    buffer: Buffer,
    bind_group: BindGroup,
}

impl Light {
    pub fn new(light_uniform: LightUniform, device: &Device) -> Self {
        let (buffer, bind_group) = light_uniform.create_buffer(device);

        Self {
            light_uniform,
            buffer,
            bind_group,
        }
    }

    pub fn bind(&self, rpass: &mut RenderPass, slot: u32) {
        rpass.set_bind_group(slot, &self.bind_group, &[]);
    }

    pub fn update_buffer(&self, queue: &Queue) {
        queue.write_buffer(&self.buffer, 0, bytemuck::bytes_of(&self.light_uniform));
    }
}

#[repr(C)]
#[derive(Debug, Copy, Clone, bytemuck::Pod, bytemuck::Zeroable, Default)]
pub struct LightUniform {
    pub position: [f32; 3],
    pub _padding1: u32,
    pub color: [f32; 3],
    pub _padding2: u32,
}

impl LightUniform {
    pub fn create_buffer(&self, device: &Device) -> (Buffer, BindGroup) {
        let buffer = device.create_buffer_init(&BufferInitDescriptor {
            label: Some("Light VB"),
            contents: bytemuck::bytes_of(self),
            usage: wgpu::BufferUsages::UNIFORM | wgpu::BufferUsages::COPY_DST,
        });
        let bind_group = Self::bind_group(device, &buffer);

        (buffer, bind_group)
    }

    pub fn bind_group_layout(device: &Device) -> BindGroupLayout {
        device.create_bind_group_layout(&BindGroupLayoutDescriptor {
            entries: &[wgpu::BindGroupLayoutEntry {
                binding: 0,
                visibility: ShaderStages::VERTEX | ShaderStages::FRAGMENT,
                ty: BindingType::Buffer {
                    ty: BufferBindingType::Uniform,
                    has_dynamic_offset: false,
                    min_binding_size: None,
                },
                count: None,
            }],
            label: None,
        })
    }

    pub fn bind_group(device: &Device, buffer: &Buffer) -> BindGroup {
        device.create_bind_group(&BindGroupDescriptor {
            layout: &Self::bind_group_layout(device),
            entries: &[BindGroupEntry {
                binding: 0,
                resource: buffer.as_entire_binding(),
            }],
            label: None,
        })
    }
}
