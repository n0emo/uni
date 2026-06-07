// TODO: внимательно проверить раздел SDK
// TODO: возможно, уменьшить нагрузку листингами
// TODO: проверить целостность изложения
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
компилирующихся в WASM-компоненты. Поддерживает языки: Rust, C, C++, C\#, Go, Python и JavaScript.

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

Wassel не предоставляет официального SDK для иных языков кроме Rust и Python, однако для других
языков возможно использование WIT напрямую для генерации привязок и сборки компонента. В качестве
документации был разработан репозиторий примеров~@wassel-examples-github, содержащий примеры
плагинов на Go, C\#, JavaScript и C++. Наличие примеров плагинов на разных языках доказывает тезис о
возможности разработки многоязыковых приложений.

=== Пример плагина на Go

Для разработки компонента на Go используется компилятор TinyGo~@tinygo версии 0.34.0 и выше,
обеспечивающий нативную поддержку Component Model и WASI~0.2. Помимо TinyGo, необходимо установить
инструменты `wasm-tools`~@wasm-tools и `wit-bindgen-go`.

Процесс сборки компонента состоит из трёх шагов, которые объединены в команду сборки манифеста
`plugin.toml` (рисунок~@listing-go-plugin-toml):

+ Кодирование WIT-пакета в бинарный формат Component Model с помощью `wasm-tools component wit`.
+ Генерация Go-привязок из WIT-файла с помощью `wit-bindgen-go generate`.
+ Компиляция компонента в WASM с помощью `tinygo build -target=wasip2`.

#figure(
  caption: [Манифест плагина на Go],
  kind: image,
  ```toml
  id = "go-example"
  name = "Go Example"
  version = "0.0.0"
  endpoint = "/examples/go/"
  component = "plugin.wasm"

  [build]
  cmd = """\
      wasm-tools component wit ../wit -o wassel.wasm --wasm && \
      go tool wit-bindgen-go generate \
          --world http-plugin \
          --out internal \
          ./wassel.wasm && \
      tinygo build \
          -target=wasip2 \
          -o plugin.wasm \
          --wit-package ./wassel.wasm \
          --wit-world http-plugin \
          main.go
  """
  ```,
) <listing-go-plugin-toml>

В отличие от Rust и Python, в Go отсутствует высокоуровневый SDK: привязки генерируются
`wit-bindgen-go` непосредственно из WIT-файла, и разработчик работает с ними напрямую. Регистрация
обработчика осуществляется в функции `init` через присваивание замыкания полю
`httphandler.Exports.HandleRequest` (рисунок~@listing-go-init).

#figure(
  caption: [Регистрация обработчика в функции init],
  kind: image,
  ```go
  func init() {
      httphandler.Exports.HandleRequest = handleRequest
  }

  func main() {}
  ```,
) <listing-go-init>

Функция `handleRequest` читает путь запроса из опционального значения, возвращаемого методом
`PathWithQuery` (рисунок~@listing-go-path).

#figure(
  caption: [Чтение пути входящего запроса],
  kind: image,
  ```go
  func handleRequest(
      request     httphandler.IncomingRequest,
      responseOut httphandler.ResponseOutparam,
  ) {
      path := "/"
      if p := request.PathWithQuery().Some(); p != nil {
          path = *p
      }
      sendResponse(responseOut, []byte("Hello, "+path+"!"))
  }
  ```,
) <listing-go-path>

Вспомогательная функция `sendResponse` формирует исходящий ответ: создаёт заголовки, выделяет тело,
записывает байты в поток и финализирует ресурсы (рисунок~@listing-go-response).

#figure(
  caption: [Формирование исходящего HTTP-ответа],
  kind: image,
  ```go
  func sendResponse(responseOut httphandler.ResponseOutparam, content []byte) {
      toField := func(b []byte) httptypes.FieldValue {
          l := cm.ToList[[]uint8, uint8](b)
          return *(*httptypes.FieldValue)(unsafe.Pointer(&l))
      }

      fields := httptypes.NewFields()
      fields.Append("content-length",
          toField([]byte(fmt.Sprintf("%d", len(content)))))

      out := httptypes.NewOutgoingResponse(fields)
      body := out.Body().OK()
      stream := body.Write().OK()
      stream.BlockingWriteAndFlush(cm.ToList[[]uint8, uint8](content))
      stream.ResourceDrop()

      httptypes.OutgoingBodyFinish(*body, cm.None[httptypes.Trailers]())
      httptypes.ResponseOutparamSet(
          responseOut,
          cm.OK[cm.Result[
              httptypes.ErrorCodeShape,
              httptypes.OutgoingResponse,
              httptypes.ErrorCode,
          ]](out),
      )
  }
  ```,
) <listing-go-response>

Вспомогательная функция `toField` вынесена внутрь `sendResponse` --- при необходимости её можно
поднять на уровень пакета, если она потребуется в нескольких местах.

Так как `wit-bindgen-go` генерирует низкоуровневые привязки, работа с HTTP-телом ответа требует
явного управления ресурсами: получения потока записи (`body.Write`), записи байт через
`BlockingWriteAndFlush`, освобождения потока (`ResourceDrop`) и финализации тела ответа
(`OutgoingBodyFinish`). Это существенно многословнее, чем аналогичный код на Rust или Python, однако
даёт полный контроль над жизненным циклом ресурсов.

Проверить работу плагина можно с помощью CURL (рисунок~@image-curl-go).

#figure(
  caption: [Результат выполнения запроса к плагину на Go],
  kind: image,
  ```
  $ curl localhost:9000/examples/go/hello
  Hello, /hello!
  ```,
) <image-curl-go>

=== Пример плагина на C\#

Для разработки компонента на C\# используется NuGet-пакет `componentize-dotnet`
@csharp-wasm-component-model, объединяющий в себе компилятор NativeAOT-LLVM, генератор привязок
`wit-bindgen`, инструмент `wasm-tools` и WASI SDK. Такой подход даёт разработчику опыт, сравнимый с
Rust: одна команда `dotnet build` собирает готовый WASM-компонент.

Проект настроен в файле `WasselPlugin.csproj` (рисунок~@listing-csharp-csproj). Ключевыми
параметрами являются `RuntimeIdentifier` со значением `wasi-wasm`, режим AoT-компиляции через
`PublishTrimmed` и `SelfContained`, а также ссылка на WIT-пакет с указанием мира `http-plugin`.

#figure(
  caption: [Файл проекта WasselPlugin.csproj],
  kind: image,
  ```xml
  <Project Sdk="Microsoft.NET.Sdk">
    <PropertyGroup>
      <OutputType>Library</OutputType>
      <TargetFramework>net10.0</TargetFramework>
      <RuntimeIdentifier>wasi-wasm</RuntimeIdentifier>
      <PublishTrimmed>true</PublishTrimmed>
      <SelfContained>true</SelfContained>
      <AllowUnsafeBlocks>true</AllowUnsafeBlocks>
    </PropertyGroup>
    <ItemGroup>
      <PackageReference
        Include="BytecodeAlliance.Componentize.DotNet.Wasm.SDK"
        Version="0.7.0-preview*" />
    </ItemGroup>
    <ItemGroup>
      <Wit Include="../../wit" World="http-plugin" />
    </ItemGroup>
  </Project>
  ```,
) <listing-csharp-csproj>

Сборка запускается одной командой, указанной в манифесте `plugin.toml`
(рисунок~@listing-csharp-plugin-toml).

#figure(
  caption: [Манифест плагина на C\#],
  kind: image,
  ```toml
  id = "csharp-example"
  name = "C# Example"
  version = "0.0.0"
  endpoint = "/examples/csharp/"
  component = "WasselPlugin/bin/Release/net10.0/wasi-wasm/publish/WasselPlugin.wasm"

  [build]
  cmd = "dotnet build -c Release WasselPlugin"
  ```,
) <listing-csharp-plugin-toml>

Обработчик реализуется классом, наследующим сгенерированный `wit-bindgen` интерфейс `IHttpHandler`.
Подход аналогичен абстрактному классу в Python, однако здесь используется статический метод
`HandleRequest` вместо метода экземпляра. Формирование заголовков и тела ответа показано на
рисунке~@listing-csharp-headers.

#figure(
  caption: [Формирование заголовков и тела ответа],
  kind: image,
  ```cs
  var path = request.PathWithQuery() ?? "/";
  var content = System.Text.Encoding.UTF8.GetBytes($"Hello, {path}!");
  var contentLength = System.Text.Encoding.UTF8
      .GetBytes(content.Length.ToString());

  var headers = new ITypes.Fields();
  headers.Append("content-length", contentLength);

  var response = new ITypes.OutgoingResponse(headers);
  ```,
) <listing-csharp-headers>

Запись тела ответа осуществляется через поток, управляемый конструкцией `using`
(рисунок~@listing-csharp-body). Блок `using` гарантирует вызов `Dispose` и освобождение ресурса
потока --- аналогично `stream[Symbol.dispose]()` в JavaScript и `ResourceDrop` в Go.

#figure(
  caption: [Запись тела и финализация ответа],
  kind: image,
  ```cs
  var body = response.Body();
  using (var stream = body.Write())
  {
      stream.BlockingWriteAndFlush(content);
  }
  ITypes.OutgoingBody.Finish(body, null);
  ITypes.ResponseOutparam.Set(
      responseOut,
      Result<ITypes.OutgoingResponse, ITypes.ErrorCode>.Ok(response)
  );
  ```,
) <listing-csharp-body>

Полная реализация класса-обработчика приведена на рисунке~@listing-csharp-full.

#figure(
  caption: [Полная реализация обработчика на C\#],
  kind: image,
  ```cs
  using HttpPluginWorld;
  using HttpPluginWorld.wit.imports.wasi.http.v0_2_10;

  public class HttpHandlerImpl
      : HttpPluginWorld.wit.exports.wassel.foundation.IHttpHandler
  {
      public static void HandleRequest(
          ITypes.IncomingRequest request,
          ITypes.ResponseOutparam responseOut)
      {
          var path = request.PathWithQuery() ?? "/";
          var content = System.Text.Encoding.UTF8
              .GetBytes($"Hello, {path}!");
          var contentLength = System.Text.Encoding.UTF8
              .GetBytes(content.Length.ToString());

          var headers = new ITypes.Fields();
          headers.Append("content-length", contentLength);

          var response = new ITypes.OutgoingResponse(headers);
          var body = response.Body();
          using (var stream = body.Write())
          {
              stream.BlockingWriteAndFlush(content);
          }

          ITypes.OutgoingBody.Finish(body, null);
          ITypes.ResponseOutparam.Set(
              responseOut,
              Result<ITypes.OutgoingResponse, ITypes.ErrorCode>.Ok(response)
          );
      }
  }
  ```,
) <listing-csharp-full>

Проверить работу плагина можно с помощью CURL (рисунок~@image-curl-csharp).

#figure(
  caption: [Результат выполнения запроса к плагину на C\#],
  kind: image,
  ```
  $ curl localhost:9000/examples/csharp/hello
  Hello, /hello!
  ```,
) <image-curl-csharp>

=== Пример плагина на JavaScript

Для разработки компонента на JavaScript используется инструмент `jco`~@componentize-js-github,
объединяющий компоновку, генерацию типов и сборку компонентов. Под капотом `jco` использует движок
StarlingMonkey~@starling-monkey-github --- WASM-совместимую среду выполнения JavaScript,
оптимизированную для компонентной модели. Установка `jco` осуществляется через пакетный менеджер
`npm`:

#figure(
  caption: [Установка jco],
  kind: image,
  ```
  npm install -g @bytecodealliance/jco
  ```,
)

Сборка компонента выполняется одной командой `jco componentize`, которая принимает JS-модуль,
WIT-пакет и имя мира, после чего выдаёт готовый WASM-компонент. Команда сборки объявлена в манифесте
`plugin.toml` (рисунок~@listing-js-plugin-toml).

#figure(
  caption: [Манифест плагина на JavaScript],
  kind: image,
  ```toml
  id = "javascript-example"
  name = "JavaScript Example"
  version = "0.0.0"
  endpoint = "/examples/javascript/"
  component = "plugin.wasm"

  [build]
  cmd = """
      npx jco componentize app.js \
          --wit ../wit \
          --world-name http-plugin \
          --out plugin.wasm
  """
  ```,
) <listing-js-plugin-toml>

В отличие от Go, где привязки генерируются в виде отдельных файлов, `jco` встраивает привязки
непосредственно в среду выполнения StarlingMonkey. Разработчик работает с импортами из
`wasi:http/types` напрямую, без промежуточного шага генерации кода.

Обработчик запросов реализуется в виде ES-модуля, экспортирующего объект `httpHandler` с методом
`handleRequest`. Метод принимает объекты входящего запроса и выходного параметра ответа ---
аналогично функции `init` в Go, но в идиоматичном для JavaScript стиле. Пример плагина показан на
рисунке~@listing-js-main.

#figure(
  caption: [Пример плагина на JavaScript],
  kind: image,
  ```js
  import {
      Fields, OutgoingBody, OutgoingResponse, ResponseOutparam,
  } from "wasi:http/types@0.2.10";

  export const httpHandler = {
      handleRequest(request, responseOut) {
          const path = request.pathWithQuery() ?? "/";
          const content = new TextEncoder().encode(`Hello, ${path}!`);
          const contentLength = new TextEncoder()
              .encode(String(content.length));

          const headers = new Fields();
          headers.append("content-length", contentLength);

          const response = new OutgoingResponse(headers);
          const body = response.body();
          const stream = body.write();
          stream.blockingWriteAndFlush(content);
          stream[Symbol.dispose]();

          OutgoingBody.finish(body, undefined);
          ResponseOutparam.set(responseOut, { tag: "ok", val: response });
      }
  };
  ```,
) <listing-js-main>

Управление ресурсами в JavaScript осуществляется через протокол `Symbol.dispose`, что является
аналогом метода `ResourceDrop` в Go и деструктора в Rust. Для явного освобождения ресурса потока
записи тела ответа необходимо вызвать `stream[Symbol.dispose]()` до финализации тела. Это соглашение
соответствует черновику спецификации Explicit Resource Management~@tc39-using для JavaScript.

Проверить работу плагина можно с помощью CURL (рисунок~@image-curl-js).

#figure(
  caption: [Результат выполнения запроса к плагину на JavaScript],
  kind: image,
  ```
  $ curl localhost:9000/examples/javascript/hello
  Hello, /hello!
  ```,
) <image-curl-js>

=== Пример плагина на C++

Для разработки компонента на C++ используется WASI SDK~@wasi-sdk --- набор инструментов на базе
Clang с поддержкой цели `wasm32-wasip2`. Помимо WASI SDK, необходим инструмент `wit-bindgen` для
генерации привязок из WIT-файла.

Процесс сборки описан в скрипте `build.sh` и состоит из трёх шагов (рисунок~@listing-cpp-build):

+ Генерация C-привязок из WIT-пакета с помощью `wit-bindgen c`.
+ Компиляция сгенерированного файла `http_plugin.c` компилятором `wasm32-wasip2-clang`.
+ Компиляция основного файла `lib.cpp` и компоновка с объектными файлами привязок.

#figure(
  caption: [Скрипт сборки плагина на C++],
  kind: image,
  ```bash
  wit-bindgen c ../wit -w http-plugin --out-dir bindings

  CC=/opt/wasi-sdk/bin/wasm32-wasip2-clang
  CXX=/opt/wasi-sdk/bin/wasm32-wasip2-clang++

  cp ./bindings/http_plugin_component_type.o ./build/
  $CC -Ibindings -o ./build/http_plugin.o -x c -c ./bindings/http_plugin.c
  $CXX -std=c++20 -Ibindings -o plugin.wasm -mexec-model=reactor \
      ./src/lib.cpp build/*.o
  ```,
) <listing-cpp-build>

Флаг `-mexec-model=reactor` указывает компилятору собрать компонент в модели реактора --- аналогично
библиотеке, а не исполняемому файлу. Это соответствует требованиям компонентной модели WASM:
компонент не имеет точки входа `main`, а экспортирует набор функций.

В отличие от Rust и Python, в C++ отсутствует высокоуровневый SDK: `wit-bindgen` генерирует
низкоуровневые C-привязки, и весь код работает с ними напрямую. Исходный файл `lib.cpp` организован
в виде набора вспомогательных функций в пространстве имён `plugin`.

Вспомогательные функции для преобразования типов и формирования заголовков ответа показаны на
рисунке~@listing-cpp-helpers.

#figure(
  caption: [Вспомогательные функции формирования ответа],
  kind: image,
  ```cpp
  http_plugin_string_t to_plugin_string(std::string_view s) {
    auto *ptr = static_cast<uint8_t *>(malloc(s.size()));
    memcpy(ptr, s.data(), s.size());
    return {ptr, s.size()};
  }

  wasi_http_types_own_fields_t build_headers(std::string_view content_length) {
    auto fields = wasi_http_types_constructor_fields();
    auto field_name = to_plugin_string("content-length");
    wasi_http_types_field_value_t entry{
        reinterpret_cast<uint8_t *>(
            const_cast<char *>(content_length.data())),
        content_length.size()};
    wasi_http_types_list_field_value_t values{&entry, 1};

    wasi_http_types_header_error_t error;
    if (!wasi_http_types_method_fields_set(
            wasi_http_types_borrow_fields(fields),
            &field_name, &values, &error))
      wasi_http_types_header_error_free(&error);

    http_plugin_string_free(&field_name);
    return fields;
  }
  ```,
) <listing-cpp-helpers>

Запись тела ответа в выходной поток и его финализация показаны на рисунке~@listing-cpp-body.

#figure(
  caption: [Запись тела HTTP-ответа],
  kind: image,
  ```cpp
  bool write_body(wasi_http_types_borrow_outgoing_body_t body_borrow,
                  const std::string &content) {
    wasi_http_types_own_output_stream_t stream;
    if (!wasi_http_types_method_outgoing_body_write(body_borrow, &stream))
      return false;

    http_plugin_list_u8_t data{
        reinterpret_cast<uint8_t *>(const_cast<char *>(content.data())),
        content.size()};

    wasi_io_streams_stream_error_t error;
    bool ok = wasi_io_streams_method_output_stream_blocking_write_and_flush(
        wasi_io_streams_borrow_output_stream(stream), &data, &error);

    wasi_io_streams_output_stream_drop_own(stream);
    if (!ok) wasi_io_streams_stream_error_free(&error);
    return ok;
  }

  void finish_body(wasi_http_types_own_outgoing_body_t body) {
    wasi_http_types_error_code_t error;
    if (!wasi_http_types_static_outgoing_body_finish(body, nullptr, &error))
      wasi_http_types_error_code_free(&error);
  }
  ```,
) <listing-cpp-body>

Точкой входа компонента является функция с именем по соглашению `wit-bindgen` ---
`exports_wassel_foundation_http_handler_handle_request`. Она читает путь запроса, формирует ответ и
выставляет его через `ResponseOutparam` (рисунок~@listing-cpp-entrypoint).

#figure(
  caption: [Точка входа обработчика запросов],
  kind: image,
  ```cpp
  extern "C" void
  exports_wassel_foundation_http_handler_handle_request(
      exports_wassel_foundation_http_handler_own_incoming_request_t request,
      exports_wassel_foundation_http_handler_own_response_outparam_t
          response_out)
  {
    auto borrow = wasi_http_types_borrow_incoming_request(request);

    http_plugin_string_t raw_path;
    std::string path = "/";
    if (wasi_http_types_method_incoming_request_path_with_query(
            borrow, &raw_path)) {
      path = std::string(
          reinterpret_cast<char *>(raw_path.ptr), raw_path.len);
      http_plugin_string_free(&raw_path);
    }

    auto content = "Hello, " + path + "!";
    auto response = plugin::build_response(content);

    wasi_http_types_result_own_outgoing_response_error_code_t result{
        .is_err = false, .val = {.ok = response}};
    wasi_http_types_static_response_outparam_set(response_out, &result);

    wasi_http_types_incoming_request_drop_own(request);
  }
  ```,
) <listing-cpp-entrypoint>

Управление ресурсами в C++ осуществляется вручную: каждый владеющий тип (`own_output_stream_t`,
`own_outgoing_body_t` и др.) должен быть явно освобождён вызовом соответствующей функции
`*_drop_own`. Это наиболее многословный подход из всех рассмотренных языков, однако он даёт полный
контроль над временем жизни ресурсов и не требует среды выполнения.

Проверить работу плагина можно с помощью CURL (рисунок~@image-curl-cpp).

#figure(
  caption: [Результат выполнения запроса к плагину на C++],
  kind: image,
  ```
  $ curl localhost:9000/examples/cpp/hello
  Hello, /hello!
  ```,
) <image-curl-cpp>
