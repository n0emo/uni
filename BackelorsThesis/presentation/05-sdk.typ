== SDK

#align(horizon)[
  *Идиоматичные привязки к Rust и Python*

  #show raw: set text(size: 17pt)

  ```rust
  use wassel_sdk::http::{IntoResponse, Request, handler};

  #[handler]
  fn handle_request(request: Request) -> impl IntoResponse {
      format!("Hello, {}!", request.path())
  }
  ```

  #v(1em)

  ```python
  from wassel_sdk import http

  class HttpHandler(http.HttpHandler):
    @override
    def handle(self, request):
      return http.Response(f'Hello, {request.path}!')
  ```
]

#pagebreak()

#align(horizon)[
  *Разработка плагинов на других языках*

  Пакет WIT и низкоуровневые привязки доступны для всех остальных языков.

  Для проверки работоспособности разработаны и проверены эталонные плагины на:

  - C++
  - C\#
  - Go
  - JavaScript
  - Python
  - Rust
]
