struct VertexInput {
    @location(0) position: vec3<f32>,
    @location(1) tex_coords: vec2<f32>,
    @location(2) normal: vec3<f32>,
}

struct Instance {
    @location(3) position: vec3<f32>,
}

struct VertexOutput {
    @builtin(position) position: vec4<f32>,
    @location(0) tex_coords: vec2<f32>,
    @location(1) world_position: vec3<f32>,
    @location(2) normal: vec3<f32>,
}

struct CameraUniform {
    view_proj: mat4x4<f32>,
}

struct Light {
    position: vec3<f32>,
    color: vec3<f32>,
}

@group(0) @binding(0)
var basecolor_texture: texture_2d<f32>;
@group(0) @binding(1)
var basecolor_sampler: sampler;

@group(1) @binding(0)
var<uniform> camera: CameraUniform;

@group(2) @binding(0)
var<uniform> light: Light;

@vertex
fn vs_main(
    in: VertexInput,
    instance: Instance,
) -> VertexOutput {
    var out: VertexOutput;

    out.tex_coords = in.tex_coords;
    out.world_position = in.position + instance.position;
    out.position = camera.view_proj * vec4<f32>(in.position + instance.position, 1.0);
    out.normal = in.normal;

    return out;
}

@fragment
fn fs_main(
    in: VertexOutput,
) -> @location(0) vec4<f32> {
    let basecolor = textureSample(basecolor_texture, basecolor_sampler, in.tex_coords);

    let light_dir = normalize(light.position - in.world_position);

    let diffuse_strength = max(dot(in.normal, light_dir), 0.0);
    let diffuse_color = light.color * diffuse_strength;

    let ambient = 0.1;
    let light = diffuse_color + ambient;

    return vec4<f32>(basecolor.xyz * light, basecolor.w);
}
