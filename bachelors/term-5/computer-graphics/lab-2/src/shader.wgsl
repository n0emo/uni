struct Vertex {
    @location(0) pos: vec3<f32>,
    @location(1) col: vec3<f32>,
}

struct VertexOutput {
    @builtin(position) pos: vec4<f32>,
    @location(1) col: vec3<f32>,
}

@vertex
fn vs_main(
    vertex: Vertex,
) -> VertexOutput {
    var out: VertexOutput;

    out.pos = vec4<f32>(vertex.pos.x * 9.0 / 16.0, vertex.pos.yz, 1.0);
    out.col = vertex.col;

    return out;
}

@fragment
fn fs_main(
    in: VertexOutput,
) -> @location(0) vec4<f32> {
    return vec4<f32>(in.col, 1.0);
}
