const EPSILON: f32 = 0.001;
const MAX_DISTANCE: f32 = 100.0;
const MAX_ITERATIONS: i32 = 200;
const SHADOW_SHARPNESS: f32 = 30.0;

struct VertexInput {
    @location(0) pos: vec2<f32>,
}

struct VertexOutput {
    @builtin(position) pos: vec4<f32>,
}

struct StateUniform {
    time: f32,
    width: f32,
    height: f32,
    camera_angle_horizontal: f32,
    camera_angle_vertical: f32,
    camera_zoom: f32,
}

@group(0) @binding(0)
var<uniform> state: StateUniform;

@vertex
fn vs_main(in: VertexInput) -> VertexOutput {
    var out: VertexOutput;
    out.pos = vec4<f32>(in.pos, 0.0, 1.0);
    return out;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let ratio = state.width / state.height;
    let uv = vec2<f32>(
        ratio * (in.pos.x / state.width - 0.5),
        1.0 - in.pos.y / state.height - 0.5,
    );

    var ro = vec3<f32>(0.0, 0.0, -state.camera_zoom);
    var rd = normalize(vec3<f32>(uv, 1));

    // Rotate vertical
    let ry = mat_rot_2d(state.camera_angle_vertical);
    let royz = ro.yz * ry;
    ro = vec3<f32>(ro.x, royz);
    let rdyz = rd.yz * ry;
    rd = vec3<f32>(rd.x, rdyz);

    // Rotate horizontal
    let rx = mat_rot_2d(state.camera_angle_horizontal);
    let roxz = ro.xz * rx;
    ro = vec3<f32>(roxz.x, ro.y, roxz.y);
    let rdxz = rd.xz * rx;
    rd = vec3<f32>(rdxz.x, rd.y, rdxz.y);

    var travelled = 0.0;
    var color = vec3<f32>(1.0);

    var i = 0;
    var point: vec3<f32>;
    for (; i < MAX_ITERATIONS; i += 1) {
        point = ro + rd * travelled;
        let distance = scene(point, &color);
        travelled += distance;

        if distance < 0.001 || travelled > 100.0 {
            break;
        }
    }

    apply_lights(point, rd, &color);

    return vec4<f32>(color, 1.0);
}

fn scene(pos: vec3<f32>, color: ptr<function, vec3<f32>>) -> f32 {
    let s = sponge(pos, color);
    let b = bottom(pos, color);
    return min(s, b);
}

// **************************************
//              Objects
// **************************************

fn bottom(pos: vec3<f32>, color: ptr<function, vec3<f32>>) -> f32 {
    let t = temple(pos, color);
    var c2 = vec3<f32>(0.0);
    let g = ground_sdf(pos - vec3<f32>(0.0, -2.0, 0.0));
    let d = smin(t, g, 0.1);

    if d < EPSILON  && g > EPSILON {
        *color = vec3<f32>(1.0, 1.0, 0.7);
    } else if g < EPSILON {
        *color = vec3<f32>(1.0, 1.0, 0.5);
    }

    return d;

}

fn temple(pos: vec3<f32>, color: ptr<function, vec3<f32>>) -> f32 {
    let q_c = pos - vec3<f32>(0.0, -2.8, 0.0);
    let c = capped_cylinder_sdf(q_c, 2.0, 0.4) - 0.03;

    let size = vec2<i32>(2, 2);
    let rep = 4.7;
    let rep_v = repeat_rectangular(pos.xz, size, rep);
    let q_p = vec3<f32>(rep_v.x, pos.y, rep_v.y);
    let p = capped_cylinder_sdf(q_p, 2.8, 0.3);

    let q_r = pos - vec3<f32>(0.0, 2.7, 0.0);
    let r = box_sdf(q_r, vec3<f32>(2.9, 0.1, 2.9)) - 0.05;

    let q_b = pos - vec3<f32>(0.0, -2.0, 0.0);
    let b = box_sdf(q_b, vec3<f32>(3.0, 0.15, 3.0)) - 0.05;

    let s = 0.05;
    let d = smin(p,
            smin(c,
            smin(b, r, s), s), s);

    if d < EPSILON {
        *color = vec3<f32>(1.0, 1.0, 0.7);
    }

    return d;
}

fn sponge(pos: vec3<f32>, color: ptr<function, vec3<f32>>) -> f32 {
    let q = rot_3d(
        pos - vec3<f32>(0.0, sin(state.time * 2.0) * 0.1, 0.0),
        normalize(vec3<f32>(1.0, 1.0, 1.0)),
        3.141592 * fract(state.time * 0.2) * 2.0
    );

    let scale = 0.25;
    let d = sponge_sdf(q / scale) * scale - 0.001;

    if d < EPSILON {
        *color = vec3<f32>(0.49, 0.604, 0.89);
    }

    return d;
}

// **************************************
//       Signed Distance Functions
// **************************************

fn scene_sdf(pos: vec3<f32>) -> f32 {
    var color = vec3<f32>(0.0);
    return scene(pos, &color);
}

fn ground_sdf(pos: vec3<f32>) -> f32 {
    return pos.y;
}

fn capped_cylinder_sdf(p: vec3<f32>, h: f32, r: f32) -> f32 {
    let d = abs(vec2(length(p.xz), p.y)) - vec2(r, h);
    return min(max(d.x, d.y), 0.0) + length(max(d, vec2<f32>(0.0)));
}

fn sponge_sdf(pos: vec3<f32>) -> f32 {
    let scale = 81.0;

    var p = pos * scale;
    for (var s = scale; s >= 1.0; s /= 3.0) {
        p = trans(p, s);
    }

    return box_sdf(p, vec3<f32>(0.5)) / scale;
}

fn box_sdf(p: vec3<f32>, b: vec3<f32>) -> f32 {
    let q = abs(p) - b;
    return length(max(q, vec3<f32>(0.0))) + min(max(q.x, max(q.y, q.z)), 0.0);
}

// **************************************
//           Light and shadows
// **************************************

fn apply_lights(point: vec3<f32>, ray_direction: vec3<f32>, color: ptr<function, vec3<f32>>) {
    let sun = normalize(vec3<f32>(20.0, 10.0, -10.0));
    let normal = scene_normal(point);

    let light_diffuse = max(dot(normal, sun), 0.0);
    let light_ambient = 0.2;
    let light_bounce = max(dot(normal, -sun), 0.0);
    let shadow = max(scene_shadow(point, sun), 0.2);
    let light = min((light_diffuse + 0.1 * light_bounce) * shadow + light_ambient, 1.0);
    let light_specular = max(dot((ray_direction + normal) * 0.5, sun), 0.0);

    *color = (*color) * light + 1.5 * pow(light_specular, 4.0);
}

fn scene_normal(p: vec3<f32>) -> vec3<f32> {
    let e = vec2<f32>(1.0, -1.0) * 0.5773 * 0.0005;
    return normalize(
        e.xyy * scene_sdf(p + e.xyy) +
        e.yyx * scene_sdf(p + e.yyx) +
        e.yxy * scene_sdf(p + e.yxy) +
        e.xxx * scene_sdf(p + e.xxx)
    );
}

fn scene_shadow(origin: vec3<f32>, direction: vec3<f32>) -> f32 {
    var travelled = 0.1;
    var result = 1.0;

    for (var i = 0; i < MAX_ITERATIONS; i++) {
        let point = origin + travelled * direction;
        let d = scene_sdf(point);
        result = min(result, SHADOW_SHARPNESS * d / travelled);
        travelled += d;

        if travelled > MAX_DISTANCE {
            return result;
        } else if d < EPSILON {
            break;
        }
    }

    return 0.0;
}

// **************************************
//               Utilities
// **************************************

fn trans(pos: vec3<f32>, s: f32) -> vec3<f32> {
    //Mirror
    var p = abs(pos) - 1.0 * s;
    p *= -1.0;

    //Reflect column
    if p.x - p.y > 0.0 {
        p = vec3<f32>(p.y, p.x, p.z);
    }
    if p.z - p.y > 0.0 {
        p = vec3<f32>(p.x, p.z, p.y);
    }

    //construct column
    p.y = abs(p.y - 0.5 * s) - 0.5 * s;

    return p;
}

fn mat_rot_2d(angle: f32) -> mat2x2<f32> {
    return mat2x2<f32>(cos(angle), -sin(angle), sin(angle), cos(angle));
}

fn rot_3d(p: vec3<f32>, axis: vec3<f32>, angle: f32) -> vec3<f32> {
    let m = mix(dot(axis, p) * axis, p, cos(angle));
    let c = cross(axis, p) * sin(angle);
    return m + c;
}

fn smin(d1: f32, d2: f32, k: f32) -> f32 {
    let h = clamp(0.5 + 0.5 * (d2 - d1) / k, 0.0, 1.0);
    return mix(d2, d1, h) - k * h * (1.0 - h);
}

fn repeat_rectangular(pos: vec2<f32>, size: vec2<i32>, spacing: f32) -> vec2f {
    var p = abs(pos / spacing) - (vec2<f32>(size) * 0.5 - 0.5);
    if p.x < p.y {
        p = p.yx;
    }

    p.y -= min(0.0, round(p.y));

    return p*spacing;
}
