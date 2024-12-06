use std::{borrow::Cow, sync::{Arc, Mutex}};

use leptos::{html, logging::log, prelude::*, task::spawn_local};
use web_sys::HtmlCanvasElement;
use winit::{
    event::{Event, WindowEvent}, event_loop::{EventLoop, EventLoopBuilder}, platform::web::{EventLoopExtWebSys, WindowExtWebSys}, window::{Window, WindowBuilder}
};

#[derive(Clone)]
pub struct Application {
}


pub struct Context {
}

#[derive(Debug, Clone, Copy)]
enum UserEvent {
    Close,
}

#[component]
pub fn FullName() -> impl IntoView {
    let container = NodeRef::<html::Div>::new();
    let (_app, _) = signal(Application {  });

    let event_loop = loop {
        let l = EventLoopBuilder::<UserEvent>::with_user_event()
            .build();
        match l {
            Ok(l) => break l,
            e => panic!("Cannot create event loop: {e:?}"),
        }
    };
    let window = Arc::new(WindowBuilder::new().build(&event_loop).unwrap());
    let canvas: HtmlCanvasElement = window.canvas().unwrap();
    canvas.style("display: block; width: 100%; height: 100%; aspect-ratio: 16 / 9");

    container.on_load(move |c| {
        c.append_child(&canvas).unwrap();
    });

    let event_loop_proxy = Arc::new(Mutex::new(event_loop.create_proxy()));
    on_cleanup(move || {
        let _ = event_loop_proxy.lock().unwrap().send_event(UserEvent::Close);
        log!("Sent close event to EventLoop");
    });

    spawn_local(run(event_loop, window));

    view!(
        <h1>"Лабораторная работа №1 - ФИО на WebGPU"</h1>
        <div node_ref=container />
    )
}

async fn run(event_loop: EventLoop<UserEvent>, window: Arc<Window>) {
    let mut size = window.inner_size();
    size.width = size.width.max(1);
    size.height = size.height.max(1);

    let instance = wgpu::Instance::default();

    let surface = instance.create_surface(window.clone()).unwrap();
    let adapter = instance
        .request_adapter(&wgpu::RequestAdapterOptions {
            power_preference: wgpu::PowerPreference::default(),
            force_fallback_adapter: false,
            // Request an adapter which can render to our surface
            compatible_surface: Some(&surface),
        })
        .await
        .expect("Failed to find an appropriate adapter");

    // Create the logical device and command queue
    let (device, queue) = adapter
        .request_device(
            &wgpu::DeviceDescriptor {
                label: None,
                required_features: wgpu::Features::empty(),
                // Make sure we use the texture resolution limits from the adapter, so we can support images the size of the swapchain.
                required_limits: wgpu::Limits::downlevel_webgl2_defaults()
                    .using_resolution(adapter.limits()),
                memory_hints: wgpu::MemoryHints::MemoryUsage,
            },
            None,
        )
        .await
        .expect("Failed to create device");

    // Load the shaders from disk
    let shader = device.create_shader_module(wgpu::ShaderModuleDescriptor {
        label: None,
        source: wgpu::ShaderSource::Wgsl(Cow::Borrowed(include_str!("shader.wgsl"))),
    });

    let pipeline_layout = device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
        label: None,
        bind_group_layouts: &[],
        push_constant_ranges: &[],
    });

    let swapchain_capabilities = surface.get_capabilities(&adapter);
    let swapchain_format = swapchain_capabilities.formats[0];

    let render_pipeline = device.create_render_pipeline(&wgpu::RenderPipelineDescriptor {
        label: None,
        layout: Some(&pipeline_layout),
        vertex: wgpu::VertexState {
            module: &shader,
            entry_point: Some("vs_main"),
            buffers: &[],
            compilation_options: Default::default(),
        },
        fragment: Some(wgpu::FragmentState {
            module: &shader,
            entry_point: Some("fs_main"),
            compilation_options: Default::default(),
            targets: &[Some(swapchain_format.into())],
        }),
        primitive: wgpu::PrimitiveState::default(),
        depth_stencil: None,
        multisample: wgpu::MultisampleState::default(),
        multiview: None,
        cache: None,
    });

    let mut config = surface
        .get_default_config(&adapter, size.width, size.height)
        .unwrap();
    surface.configure(&device, &config);

    event_loop.spawn(move |event, target| {
        // Have the closure take ownership of the resources.
        // `event_loop.run` never returns, therefore we must do this to ensure
        // the resources are properly cleaned up.
        let _ = (&instance, &adapter, &shader, &pipeline_layout);

        match event {
            Event::WindowEvent { window_id: _, event } => match event {
                WindowEvent::Resized(new_size) => {
                    // Reconfigure the surface with the new size
                    config.width = new_size.width.max(1);
                    config.height = new_size.height.max(1);
                    surface.configure(&device, &config);
                    // // On macos the window needs to be redrawn manually after resizing
                    window.request_redraw();
                }
                WindowEvent::RedrawRequested => {
                    let frame = surface
                        .get_current_texture()
                        .expect("Failed to acquire next swap chain texture");
                    let view = frame
                        .texture
                        .create_view(&wgpu::TextureViewDescriptor::default());
                    let mut encoder =
                    device.create_command_encoder(&wgpu::CommandEncoderDescriptor {
                        label: None,
                    });
                    {
                        let mut rpass =
                        encoder.begin_render_pass(&wgpu::RenderPassDescriptor {
                            label: None,
                            color_attachments: &[Some(wgpu::RenderPassColorAttachment {
                                view: &view,
                                resolve_target: None,
                                ops: wgpu::Operations {
                                    load: wgpu::LoadOp::Clear(wgpu::Color::GREEN),
                                    store: wgpu::StoreOp::Store,
                                },
                            })],
                            depth_stencil_attachment: None,
                            timestamp_writes: None,
                            occlusion_query_set: None,
                        });
                        rpass.set_pipeline(&render_pipeline);
                        rpass.draw(0..3, 0..1);
                    }

                    queue.submit(Some(encoder.finish()));
                    frame.present();
                },
                WindowEvent::CloseRequested => target.exit(),
                _ => {},
            }
            Event::UserEvent(UserEvent::Close) => {
                log!("Closing EventLoop");
                target.exit();
            }
            _ => {},
        }
    });
}
