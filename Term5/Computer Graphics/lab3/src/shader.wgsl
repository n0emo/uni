struct Vertex {
    @location(0) pos: vec3<f32>,
    @location(1) tex_coords: vec2<f32>,
}

struct Instance {
    @location(2) pos: vec3<f32>,
}

struct VertexOutput {
    @builtin(position) pos: vec4<f32>,
    @location(0) tex_coords: vec2<f32>,
}

struct CameraUniform {
    view_proj: mat4x4<f32>,
}

@group(0) @binding(0)
var basecolor_texture: texture_2d<f32>;
@group(0) @binding(1)
var basecolor_sampler: sampler;

@group(1) @binding(0)
var<uniform> camera: CameraUniform;

@vertex
fn vs_main(
    vertex: Vertex,
    instance: Instance,
) -> VertexOutput {
    var out: VertexOutput;

    out.tex_coords = vertex.tex_coords;
    out.pos = camera.view_proj * vec4<f32>(vertex.pos + instance.pos, 1.0);

    return out;
}

@fragment
fn fs_main(
    in: VertexOutput,
) -> @location(0) vec4<f32> {
    return textureSample(basecolor_texture, basecolor_sampler, in.tex_coords);
}
