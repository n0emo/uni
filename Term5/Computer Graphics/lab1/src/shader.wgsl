struct Vertex {
    @location(0) pos: vec3<f32>,
    @location(1) col: vec3<f32>,
}

struct VertexOutput {
    @builtin(position) pos: vec4<f32>,
    @location(1) color: vec3<f32>,
};

@vertex
fn vs_main(
    vertex: Vertex,
) -> VertexOutput {
    var out: VertexOutput;

    out.pos = vec4<f32>(vertex.pos, 1.0);
    out.color = vertex.col;

    return out;
}

@fragment
fn fs_main(
    in: VertexOutput
) -> @location(0) vec4<f32> {
    let x = in.color.x * (1.0 - 0.35 * sin(0.01 * in.pos.x / in.pos.w));
    let y = in.color.y * (1.0 - 0.35 * cos(0.02 * in.pos.y / in.pos.w));
    let z = in.color.z;
    let color = vec3<f32>(x, y, z);
    return vec4<f32>(color, 1.0);
}
