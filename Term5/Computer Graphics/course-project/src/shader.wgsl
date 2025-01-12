const EPSILON: f32 = 0.001;
const MAX_DISTANCE: f32 = 100.0;
const MAX_ITERATIONS: i32 = 120;

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

    let ray_origin = vec3<f32>(0, 0, -3);
    let ray_direction = normalize(vec3<f32>(uv, 1));

    var travelled = 0.0;
    var color = vec3<f32>(1.0);

    var i = 0;
    var point: vec3<f32>;
    for (; i < MAX_ITERATIONS; i += 1) {
        point = ray_origin + ray_direction * travelled;
        let distance = scene(point, &color);
        travelled += distance;

        if distance < 0.001 || travelled > 100.0 {
            break;
        }
    }

    apply_lights(point, ray_direction, &color);

    return vec4<f32>(color, 1.0);
}

fn scene(pos: vec3<f32>, color: ptr<function, vec3<f32>>) -> f32 {
    let s = sponge(pos, color);
    let g = ground(pos, color);
    return min(s, g);
}

// **************************************
//              Objects
// **************************************

fn ground(pos: vec3<f32>, color: ptr<function, vec3<f32>>) -> f32 {
    let d = ground_sdf(pos - vec3<f32>(0.0, -5.0, 0.0));

    if d < EPSILON {
        *color = vec3<f32>(1.0, 1.0, 0.5);
    }

    return d;
}

fn sponge(pos: vec3<f32>, color: ptr<function, vec3<f32>>) -> f32 {
    let q = rot_3d(
        pos - vec3<f32>(0.0, sin(state.time) * 1.5, 4.0),
        normalize(vec3<f32>(1.0, 1.0, 1.0)),
        3.141592 * fract(state.time * 0.2) * 2.0
    );

    let d = sponge_sdf(q);

    if d < EPSILON {
        *color = vec3<f32>(1.0, 0.0, 0.0);
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

    *color = (*color) * light + 15.0 * pow(light_specular, 4.0);
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
        result = min(result, 10 * d / travelled);
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

fn rot_3d(p: vec3<f32>, axis: vec3<f32>, angle: f32) -> vec3<f32> {
    let m = mix(dot(axis, p) * axis, p, cos(angle));
    let c = cross(axis, p) * sin(angle);
    return m + c;
}
