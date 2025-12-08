== 6.1 Инициализация сервера

Библиотека предоставляет удобный способ запуска сервера. Достаточно указать все
настройки в структуре HttpServerSettings и передать её вместе с указателем на
структуру сервера в функцию mew_http_server_init. @example-main показывает
пример точки входа возможного приложения.

#figure(
  ```c
  #include <mew/http.h>
  #include <mew/log.h>

  bool handler(HttpRequest *request, HttpResponse *response, void *user_data);

  int main(void) {
      HttpServer server;
      HttpServerSettings settings;
      settings.port = 8080;
      settings.host = "127.0.0.1";
      settings.handler = handler;
      if (!http_server_init(&server, settings)) {
          log_error("Error initializing server");
          return 1;
      }
      http_server_start(&server);
      return 0;
  }

  ```,
  kind: image,
  caption: [Объявление функции main в примере сервера],
) <example-main>

== 6.2 Определение функции-обработчика

Функция-обработчик определяется пользозвателем и используется для обработки
запроса и формирования ответа сервера. Логика обработки может быть сколь угодно
сложной. В текущей работе достаточно наглядным примером будет простой
файловый сервер (см. рисунок #ref(label("example-handler"), supplement: none)).

#figure(
  ```c
  bool handler(HttpRequest *request, HttpResponse *response, void *user_data) {
      serve_dir(response, request->resource_path, cstr_to_sv("."));
      return true;
  }

  ```,
  kind: image,
  caption: [Определение функции-обработчика файлового сервера],
) <example-handler>

== 6.3 Запуск и проверка сервера

При запуске сервера в консоли появятся логи, дающие информацию о том, что
происходит на сервере
(см. рисунок #ref(label("example-logs"), supplement: none)).

#figure(
  ```console
  $ ./build/examples/http_file_server
  [2025:12:08 04:34:33] INFO Serving at 127.0.0.1:8080
  [2025:12:08 04:34:36] INFO GET /README.md: 200
  [2025:12:08 04:34:36] DEBUG Sending file ./README.md with size 45
  [2025:12:08 04:34:49] INFO GET /something.non: 404
  [2025:12:08 04:34:49] DEBUG Response was none
  ```,
  kind: image,
  caption: [Пример логов сервера],
) <example-logs>

Проверить работоспособность сервера можно с помощью утилиты curl. Поскольку
сервер запущен в директории с исходным кодом, через HTTP должны быть доступны
файлы этого кода. @example-curl показывает пример получения файла LICENSE.

#figure(
  image("/assets/curl.png"),
  caption: [CURL-запрос к серверу]
) <example-curl>
