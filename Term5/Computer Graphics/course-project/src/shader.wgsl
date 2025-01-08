struct VertexInput {
    @location(0) pos: vec2<f32>,
}

struct VertexOutput {
    @builtin(position) pos: vec4<f32>,
}

@vertex
fn vs_main(in: VertexInput) -> VertexOutput {
    var out: VertexOutput;
    out.pos = vec4<f32>(in.pos, 0.0, 1.0);
    return out;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let ratio = 1498.0 / 842.0;
    let uv = vec2<f32>(
        ratio * (in.pos.x / 1498.0 - 0.5),
        1.0 - in.pos.y / 842.0 - 0.5,
    );

    let ray_origin = vec3<f32>(0, 0, -3);
    let ray_direction = normalize(vec3<f32>(uv, 1));

    var travelled = 0.0;

    var i = 0;
    for (; i < 80; i += 1) {
        let point = ray_origin + ray_direction * travelled;
        let distance = scene_sdf(point);
        travelled += distance;

        if distance < 0.001 || travelled > 100.0 {
            break;
        }
    }

    var col = vec3<f32>(travelled * 0.04 + f32(i) * 0.005);

    return vec4<f32>(col, 1.0);
}

fn scene_sdf(point: vec3<f32> ) -> f32 {
    let s1 = length(point + vec3<f32>(-0.9, 0.0, 0.0)) - 1.0;
    let s2 = length(point + vec3<f32>( 0.9, 0.0, 0.0)) - 1.0;
    return min(s1, s2);
}
