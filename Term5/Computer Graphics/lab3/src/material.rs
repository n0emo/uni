use framework::WgpuContext;
use wgpu::{
    BindGroupDescriptor, BindGroupEntry, BindGroupLayoutDescriptor, BindGroupLayoutEntry,
    BindingType, ShaderStages, TextureSampleType,
};

use crate::texture::Texture;

pub struct Material {
    #[allow(unused)]
    pub basecolor: Texture,
    #[allow(unused)]
    pub normal: Texture,
    pub bind_group: wgpu::BindGroup,
}

impl Material {
    pub fn from_texture_bytes(
        basecolor: &[u8],
        normal: &[u8],
        ctx: &WgpuContext,
    ) -> anyhow::Result<Self> {
        let basecolor = Texture::from_bytes(basecolor, ctx)?;
        let normal = Texture::from_bytes(normal, ctx)?;

        let bind_group = ctx.device.create_bind_group(&BindGroupDescriptor {
            layout: &Self::bind_group_layout(&ctx.device),
            entries: &[
                BindGroupEntry {
                    binding: 0,
                    resource: wgpu::BindingResource::TextureView(&basecolor.view),
                },
                BindGroupEntry {
                    binding: 1,
                    resource: wgpu::BindingResource::Sampler(&basecolor.sampler),
                },
            ],
            label: None,
        });

        Ok(Self {
            basecolor,
            normal,
            bind_group,
        })
    }

    pub fn bind_group_layout(device: &wgpu::Device) -> wgpu::BindGroupLayout {
        device.create_bind_group_layout(&BindGroupLayoutDescriptor {
            entries: &[
                BindGroupLayoutEntry {
                    binding: 0,
                    visibility: ShaderStages::FRAGMENT,
                    ty: BindingType::Texture {
                        sample_type: TextureSampleType::Float { filterable: true },
                        view_dimension: wgpu::TextureViewDimension::D2,
                        multisampled: false,
                    },
                    count: None,
                },
                BindGroupLayoutEntry {
                    binding: 1,
                    visibility: ShaderStages::FRAGMENT,
                    ty: wgpu::BindingType::Sampler(wgpu::SamplerBindingType::Filtering),
                    count: None,
                },
            ],
            label: None,
        })
    }
}
