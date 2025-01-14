# Computer Graphics

This project is a Cargo workspace containing WebGPU/winit framework, web
application, 3 laboratory works and course project for the "Computer Graphics"
discipline.

## Build

### Prerequisites

Make sure you have `cargo` and `rustc` installed.

#### Web

If you are going to build web application, make sure `wasm32-unknown-unknown`
target is added. If not, you can do so using `rustup`:

```console
$ rustup target add wasm32-unknown-unknown
```

Make sure you have `~/.cargo/bin` (or alternative location) in your PATH.
Install `trunk` and `stylance` using `cargo`:

```console
$ cargo install trunk stylance-cli
```

### Build native

You can build `lab1`, `lab2`, `lab3` and `course-project` using `cargo`:

```console
$ cargo build --package lab1 # Lab 1 (or any other)

$ cargo run --package lab1 # Build and immediately run
```

### Build web

Go to `web` directory and build using `trunk`. This will generate a `dist`
directory with build result, which you can serve using your favorite web server.
See `nginx.conf` and `Dockerfile` for an example.

```console
$ cd web
$ trunk build
```

You may also serve web app locally using `trunk` itself:

```console
$ trunk serve
```

## Screenshots

![Web Application](https://raw.githubusercontent.com/n0emo/uni/main/Term5/Computer%20Graphics/screenshots/webapp.png)

![Course Project](https://raw.githubusercontent.com/n0emo/uni/main/Term5/Computer%20Graphics/screenshots/course-project.png)

## Acknowledgments

- [wgpu](https://wgpu.rs/) - safe and portable graphics library for Rust based on the WebGPU API
- [Learn Wgpu](https://sotrh.github.io/learn-wgpu/) - good and informative guide to wgpu
- [Tour of WGSL](https://google.github.io/tour-of-wgsl/) - WebGPU shader language introduction
- [An introduction to Raymarching](https://youtu.be/khblXafu7iA?si=Xiw5PBCybeg3hjfK) - great kishimisu's tutorial on Raymarching
- [Ultra cheap exact Menger sponge](https://www.shadertoy.com/view/sdSBWc)

