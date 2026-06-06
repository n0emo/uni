= SDK <section-sdk>

== Понятие SDK

=== Определение SDK в контексте работы

SDK предоставляет доступ к низкоуровневым привязкам к импортируем интерфейсам, высокоуровневые
идиоматичные привязки (далее "фреймворк"), а так же функции для реализации экспортируемых
интерфейсов.

SDK позволяет разработчику приступить к разработке приложения без необходимости поддержки
собственных привязок и работы с инструментами WASM.

=== Роль wit-bindgen в генерации привязок

Wit-bindgen -- набор инструментов для генерации привязок на основе определений WIT для языков,
компилирующихся в WebAssembly-компоненты. Поддерживает языки: Rust, C, C++, C\#, Go, Python и
JavaScript.

Этот инструмент играет ключевую роль в разработке SDK. Он позволяет упростить разработку
низкоуровневых привязок, освобождая ресурсы для разработки среды выполнения и фреймворка.

=== Критерии оценивания SDK

- Полнота привязок: SDK должен предоставлять весь набор импортируемых функций.
- Идиоматичность фреймворка: фреймворк должен упрощать разработку и предоствращать частые ошибки
  разработчика и баги.
- Время компиляции: использование SDK не должно оказывать значительного влияния на время,
  затрачиваемое на сборку компонента.

== SDK для Rust

=== Архитектура

Низкоуровневые привязки генерируются на основе пакета `wit_bindgen` с использованием пакета `wasip2`
для интерфейсов WASI. Это позволяет использовать слой совместимости интерфейсов и стандартной
библиотеки Rust. К примеру, `wasip2` предоставляет реализацию типажа Read для тела входящего
HTTP-запроса и HTTP-ответа.

=== Привязки wasi:http к пакету http

Для упрощения работы с привязками фреймворк предоставляет слой совместимости с популярным пакетом
`http`, реализуя функции конвертации между типами WASI и пакета. Помимо этого, фреймворк добавляет
типажи `FromRequest` и `IntoResponse`, предлагающие более идиоматичный интерфейс взаимодействия с
SDK.

=== Макрос #[handler]

На основе типажей `FromRequest` и `IntoResponse` реализован процедурный макрос-атрибут `#[handler]`.
Он применяется к функции, тип единственного параметра которой реализует типаж `FromRequest`, а тип
возвращаемого значнеия реализует `IntoResponse`. В результате макрос генерирует гостевую реализацию
экспортируемого интерфейса `http-handler`.

=== HTTP-клиент

Для упрощения осуществления исходящих HTTP-запросов реализована структура "`RequestBuilder`",
позволяющая сконструировать запрос, и расширение для типа "`http::Request`", предоставляющее метод
для конвертации запроса в тип WASI и его отправки.

Модуль "`wassel_sdk::http::client`" экспортирует функции-помощники "`get`", "`post`", "`delete`" и
др., позволяющие более лаконичный способ создания экземпляра "`RequestBuilder`". Пример
использования модуля показан на рисунке~@listing-http-client-example.

#figure(
  caption: [Пример выполнения HTTP-запроса],
  kind: image,
  ```rust
  let id = 123;
  let url = format!("https://jsonplaceholder.typicode.com/todos/{id}");
  let response = client::get(url).send()?;
  ```,
) <listing-http-client-example>

=== Postgres-клиент

Модуль "`wassel_sdk::postgres`" включает функции для выполнения SQL-запросов, а так же типажи для
эргономичной конвертации значений между типами Rust и Postgres. Для выполнения запросов необходимо
создать экземпляр ресурса "`Connection`". Ресурс предоставляет методы "`query`" и "`execute`",
принимающие строку с SQL-запросом и итератор параметров. Пример использования клиента показан на
рисунке~@listing-postgres-example.

#figure(
  caption: [Пример выполнения запроса к базе данных Postgres],
  kind: image,
  ```rust
  const CONNECTION_STRING: &str =
      "host=127.0.0.1 user=plugin password=hunter42 dbname=plugin";

  let config = postgres::ConnectionConfig::new(CONNECTION_STRING);
  let conn = postgres::Connection::open(config)?;
  let (num,) = conn.query::<(i32,)>("SELECT $1 + $2", &[34, 35])?.first()?;
  ```,
) <listing-postgres-example>

=== Redis-клиент

Модуль "`wassel_sdk::redis`" содержит функции для выполнения запросов к Redis. Аналогично с
Postgres, для выполнения запросов необходимо создать экземпляр "`Connection`" и вызывать метод
"`execute`". Пример использования клиента показан на рисунке~@listing-redis-example.

#figure(
  caption: [Пример выполнения запроса к Redis],
  kind: image,
  ```rust
  const CONNECTION_STRING: &str = "redis://localhost:6379";
  let config = redis::ConnectionConfig::new(CONNECTION_STRING);
  let conn = redis::Connection::open(config)?;
  conn.execute("SET", &["my:value", "Hello"])?;
  let my_value = conn.execute::<String>("GET", &["my:value"])?;
  ```,
) <listing-redis-example>

#pagebreak()

=== Пример плагина

На рисунке~@listing-rust-example представлен пример плагина, который выполняет HTTP-запрос к
стороннему API и возвращает его ответ. В примере демонстрируются показанные ранее макрос
"`#[handler]`" и функции выполнения исходящих HTTP-запросов.

#figure(
  caption: [Пример использования Rust SDK],
  kind: image,
  ```rust
  use wassel_sdk::http::{
      IntoResponse, Request, Response, StatusCode,
      client::{self, RequestError},
      handler,
  };

  #[handler]
  fn handle_request(request: Request) -> Result<Response, Error> {
      let path = request.uri().path();
      let id = path.strip_prefix("/todos/").ok_or(Error::NotFound)?;
      let url = format!("https://jsonplaceholder.typicode.com/todos/{id}");
      let response = client::get(url).send().map_err(Error::Request)?;
      Ok(response)
  }

  enum Error {
      NotFound,
      Request(RequestError),
  }
  ```,
) <listing-rust-example>

Проверить работу плагина можно с помощью CURL (рисунок~@image-curl-rust).

#figure(
  caption: [Результат выполнение запроса к плагину на Rust],
  kind: image,
  ```json
  $ curl localhost:9000/rust/http-request/todos/123
  {
    "userId": 7,
    "id": 123,
    "title": "esse et quis iste est earum aut impedit",
    "completed": false
  }
  ```,
) <image-curl-rust>

== SDK для Python

=== Архитектура

Низкоуровневые привязки для Python генерируются с помощью инструмента `componentize-py`
@componentize-py-github. В отличие от Rust, где привязки генерируются на этапе компиляции макросом
`wit_bindgen`, для Python привязки генерируются и встраиваются непосредственно в процессе сборки
компонента. Команда сборки `componentize-py -w http-plugin componentize app` компилирует модуль
`app.py` в WASM-компонент с применением интерфейса `http-plugin`.

=== Высокоуровневые привязки

Модуль `wassel_sdk.http` предоставляет высокоуровневые типы для работы с HTTP: `Request`, `Response`
и вспомогательные типы полей заголовков. Класс `Request` даёт доступ к методу (`method`), пути
(`path`), заголовкам и телу входящего запроса. Класс `Response` принимает необязательные аргументы
`status`, `body` и `headers`, что позволяет конструировать ответы лаконично.

=== Абстрактный класс Handler

Для реализации обработчика запросов разработчику необходимо унаследоваться от класса
`http.HttpHandler` и переопределить метод `handle`. Метод принимает объект `Request` и должен
возвращать объект `Response`. Пример простого обработчика показан на
рисунке~@listing-python-hello-example.

#figure(
  caption: [Пример простого плагина на Python],
  kind: image,
  ```python
  from wassel_sdk import http

  class HttpHandler(http.HttpHandler):
      def handle(self, request: http.Request) -> http.Response:
          _ = request
          return http.Response(body=b"Hello from my super plugin")
  ```,
) <listing-python-hello-example>

Аннотация `@override` из модуля `typing` рекомендуется для явного указания намерения переопределить
метод базового класса, что позволяет статическим анализаторам обнаруживать опечатки в именах
методов.

=== HTTP-клиент

Для осуществления исходящих HTTP-запросов используются типы `OutgoingRequest` и `Fields` из модуля
`wassel_sdk.http`, а функция `http.client.send` принимает URL и объект запроса и возвращает объект
входящего ответа. Пример HTTP-клиента показан на рисунке~@listing-python-http-client-example.

#figure(
  caption: [Пример выполнения исходящего HTTP-запроса на Python],
  kind: image,
  ```python
  from wassel_sdk.http import Fields, OutgoingRequest, client

  req = OutgoingRequest(Fields())
  res = client.send("https://jsonplaceholder.typicode.com/todos/1", req)
  status = res.status()
  body = res.consume().stream().blocking_read(64 * 1024)
  ```,
) <listing-python-http-client-example>

Тело ответа представлено потоком байт: метод `blocking_read` принимает максимальное количество
считываемых байт. Для полного считывания тела следует читать поток в цикле до получения исключения
`StreamError_Closed`, как показано в полном примере плагина (@listing-python-full-example).

=== Postgres-клиент

Модуль `wassel_sdk.postgres` предоставляет классы `Connection` и `ConnectionConfig` для выполнения
SQL-запросов. Конфигурация подключения задаётся строкой в формате libpq. Метод `Connection.query`
принимает SQL-запрос и список значений типа `postgres.Value_*` и возвращает объект результата с
полем `rows`. Пример использования клиента показан на рисунке~@listing-python-postgres-example.

#figure(
  caption: [Пример выполнения запроса к базе данных Postgres на Python],
  kind: image,
  ```python
  from wassel_sdk import postgres

  CONNECTION_STRING = (
      "host=127.0.0.1 port=25432 "
      "user=plugin password=hunter42 dbname=plugin"
  )

  config = postgres.ConnectionConfig(CONNECTION_STRING)
  conn = postgres.Connection.open(config)
  rows = conn.query(
      "SELECT $1 + $2",
      [postgres.Value_Int32(34), postgres.Value_Int32(35)],
  )
  num = rows.rows[0][0]
  assert isinstance(num, postgres.Value_Int32)
  ```,
) <listing-python-postgres-example>

Значения параметров передаются в виде дискриминированных объединений `postgres.Value_*`, например
`Value_Int32`, `Value_Text` и т.д. Аналогично, каждая ячейка результата имеет тип
`postgres.Value_*`, который необходимо привести к нужному типу.

=== Redis-клиент

Модуль `wassel_sdk.redis` предоставляет классы `Connection` и `ConnectionConfig` для выполнения
Redis-команд. Метод `Connection.execute` принимает имя команды и список аргументов типа
`RedisArgument_*`. Пример использования клиента показан на рисунке~@listing-python-redis-example.

#figure(
  caption: [Пример выполнения запроса к Redis на Python],
  kind: image,
  ```python
  from wassel_sdk import redis
  from wassel_sdk.redis import RedisArgument_Str, RedisValue_BulkString

  CONNECTION_STRING = "redis://localhost:6379"

  config = redis.ConnectionConfig(CONNECTION_STRING)
  conn = redis.Connection.open(config)
  conn.execute("SET", [RedisArgument_Str("my:value"), RedisArgument_Str("Hello")])
  s = conn.execute("GET", [RedisArgument_Str("my:value")])
  assert isinstance(s, RedisValue_BulkString)
  ```,
) <listing-python-redis-example>

Возвращаемое значение `execute` имеет тип `RedisValue_*` и должно быть приведено к нужному типу,
например `RedisValue_BulkString` для строковых значений.

#pagebreak()

=== Пример плагина

На рисунке~@listing-python-full-example представлен полный пример плагина, который выполняет
HTTP-запрос к стороннему API и возвращает его ответ. В примере показаны абстрактный класс
`HttpHandler`, функция отправки исходящего запроса и вспомогательная функция для полного считывания
тела ответа.

#figure(
  caption: [Пример использования Python SDK],
  kind: image,
  ```python
  from typing import override
  from wassel_sdk import http
  from wassel_sdk.http import (
      Err, Fields, IncomingBody, OutgoingRequest,
      StreamError_Closed,
  )

  STREAM_READ_COUNT = 1024 * 64

  class HttpHandler(http.HttpHandler):
      @override
      def handle(self, request: http.Request) -> http.Response:
          if not request.path.startswith("/todos/"):
              return http.Response(status=404)
          try:
              path = request.path.removeprefix("/todos/")
              id = int(path)
              url = f"https://jsonplaceholder.typicode.com/todos/{id}"
              req = OutgoingRequest(Fields())
              res = http.client.send(url, req)
              body = read_body(res.consume())
              return http.Response(status=res.status(), body=body)
          except ValueError as e:
              return http.Response(status=400, body=str(e).encode())
          except Exception as e:
              return http.Response(status=500, body=str(e).encode())

  def read_body(body: IncomingBody) -> bytes:
      buf = bytes()
      try:
          with body.stream() as stream:
              while True:
                  buf += stream.blocking_read(STREAM_READ_COUNT)
      except Err as e:
          if isinstance(e.value, StreamError_Closed):
              return buf
          raise e
      finally:
          IncomingBody.finish(body)
  ```,
) <listing-python-full-example>

Проверить работу плагина можно с помощью CURL (рисунок~@image-curl-python).

#figure(
  caption: [Результат выполнения запроса к плагину на Python],
  kind: image,
  ```json
  $ curl localhost:9000/python/http-client/todos/123
  {
    "userId": 7,
    "id": 123,
    "title": "esse et quis iste est earum aut impedit",
    "completed": false
  }
  ```,
) <image-curl-python>

== Примеры плагинов на других языках

=== Пример плагина на Go

=== Пример плагина на C\#

=== Пример плагина на JavaScript

=== Пример плагина на C++

