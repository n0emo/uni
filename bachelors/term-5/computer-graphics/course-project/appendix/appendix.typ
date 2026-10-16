#import "@local/pgups:0.1.0": *

#appendixes[
  = Исходный текст графического приложения <app-graphics>

  == Типаж framework::Application <app-trait>

  ```rust
  pub trait Application {
      const SRGB: bool = true;

      const NAME: &str;

      const DESCRIPTION: &str;

      fn init(config: &SurfaceConfiguration, ctx: &WgpuContext) -> Self;

      fn render(&mut self, view: &wgpu::TextureView, dt: f32, ctx: &WgpuContext);

      fn required_features() -> wgpu::Features {
          wgpu::Features::empty()
      }

      fn required_limits() -> wgpu::Limits {
          wgpu::Limits::downlevel_webgl2_defaults()
      }

      fn resize(&mut self, config: &SurfaceConfiguration, ctx: &WgpuContext) {
          let _ = (config, ctx);
      }

      fn update(&mut self, event: WindowEvent) {
          let _ = event;
      }
  }
  ```

  == course-project/src/app.rs <app-app>

  #code-file(read("/course-project/src/app.rs"), name: "course-project/src/app.rs")

  == course-project/src/shader.wgsl <app-shader>

  #code-file(read("/course-project/src/shader.wgsl"), name: "course-project/src/shader.wgsl")

  = Исходный текст веб-приложения <app-webapp>

  == Компоненты App и CourseProject <app-components>

  ```rust
  #[component]
  fn App<A: Application + 'static>(#[prop(optional)] marker: PhantomData<A>) -> impl IntoView {
      let _ = marker;

      let handle = Arc::new(Mutex::new(framework::ApplicationHandle::default()));
      let handle_cloned = handle.clone();

      let canvas = NodeRef::<html::Canvas>::new();
      canvas.on_load(|_| {
          framework::run::<A>(Some(handle_cloned));
      });

      on_cleanup(move || {
          handle.lock().unwrap().exit();
      });

      view!(
          <h1>{A::DESCRIPTION}</h1>
          <canvas node_ref=canvas id="canvas" class=style::window />
      )
  }

  #[component]
  pub fn CourseProject() -> impl IntoView {
      view!(<App marker={PhantomData::<course_project::Application>} />)
  }
  ```

  == web/Trunk.toml <app-trunk>

  #code-file(read("/web/Trunk.toml"), name: "web/Trunk.toml")

  == web/Dockerfile <app-dockerfile>

  #code-file(read("/web/Dockerfile"), name: "web/Dockerfile", lang: "dockerfile")

  = Демонстрация работы приложения <app-demo>

  #figure(
    caption: "Демонстрация работы нативного приложения для ОС на базе ядра Linux",
    image("/course-project/assets/linux.png"),
  ) <fig-linux>

  #figure(
    caption: "Демонстрация работы нативного приложения для MacOS",
    image("/course-project/assets/macos.png"),
  ) <fig-macos>

  #figure(
    caption: "Демонстрация работы веб-приложения",
    image("/course-project/assets/web.png"),
  ) <fig-web>
]
