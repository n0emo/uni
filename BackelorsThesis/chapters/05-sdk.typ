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

=== Высокоуровневые привязки

=== Абстрактный класс Handler

=== HTTP-клиент

=== Postgres-клиент

=== Redis-клиент

=== Пример использования

== Примеры плагинов на других языках

=== Пример плагина на Go

=== Пример плагина на C\#

=== Пример плагина на JavaScript

=== Пример плагина на C++

