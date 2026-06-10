= Среда выполнения

== Оргазизация сервера

Для обработки входящих запросов создана структура `Server`, включающая в себя стек
плагинов~(рисунок~@listing-server-struct).

#figure(
  caption: [Структура `Server`],
  kind: image,
  ```rust
  pub struct Server {
      config: Config,
      stack: Stack,
  }
  ```,
) <listing-server-struct>

С помощью `tokio` открывается сокет с асинхронным интерфейсом, после чего в цикле принимаются
входящие подключения~(рисунок~@listing-serve-loop). При получении входящего подключения создаётся
новая задача `tokio` (зелёный поток), обрабатывающая подключение как HTTP-запрос.

#figure(
  caption: [Обработка входящих подключений сервером],
  kind: image,
  ```rust
  impl Server {
      pub async fn serve(&self) -> anyhow::Result<()> {
          let listener = self.bind().await?;

          loop {
              let (tcp, _) = listener.accept().await
                .context("Accepting connection")?;
              let io = TokioIo::new(tcp);
              let stack = self.stack.clone();
              tokio::task::spawn(Self::handle_connection(io, stack));
          }
      }
  ```,
) <listing-serve-loop>

Благодаря такой архитектуре возможна одновременная обработка множества входящих
подключений~---~гораздо большего числа, чем при использовании потоков ОС.

Для обработки HTTP-запросов используется `hyper`, предоставляющий высокоэффективный парсинг запросов
версий "HTTP/1.1" и "HTTP/2" (рисунок~@listing-handle-connection). `hyper` интегрирован с экосистему
`tokio` и для обработки запросов использует сервисы Tower. В контексте проекта, в качестве сервиса
используется стек плагинов~(раздел @section-plugin-stack[]), реализующий типаж `tower::Service`.

#figure(
  caption: [Обработчик HTTP-запросов],
  kind: image,
  ```rust
  impl Server {
      async fn handle_connection(io: TokioIo<TcpStream>, stack: Stack) {
          if let Err(e) = auto::Builder::new(TokioExecutor::new())
              .serve_connection_with_upgrades(io, stack)
              .await
          {
              error!("Error serving: {e:?}");
          }
      }
  }
  ```,
) <listing-handle-connection>

== Стек плагинов <section-plugin-stack>

Ключевой структурой системы является структура `Stack`~(рисунок~@listing-stack-struct). Структура
содержит таблицу образов плагинов, среду выполнения "Wasmtime" и роутер для сопоставления пути
запроса к образу плагина. Стек управляет всеми этапами жизненного цикла
плагина~(раздел~@section-plugin-execution).

#figure(
  caption: [Структура `Stack`],
  kind: image,
  ```rust
  #[derive(Clone)]
  pub struct Stack(Arc<StackInner>);

  pub struct StackInner {
      map: HashMap<String, PluginImage>,
      engine: Engine,
      router: matchit::Router<String>,
  }
  ```,
) <listing-stack-struct>

`Stack` реализует типаж `tower::Service`~(рисунок~@listing-stack-service). Такой подход примечателен
тем, что сторонний разработчик, использующий Wassel в качестве библиотеки может организовать сервер
самостоятельно. Например, популярный веб-фреймворк Axum интегрирован с сервисами Tower.

#figure(
  caption: [Реализация типажа `Service`],
  kind: image,
  ```rust
  impl Service<Request<Incoming>> for Stack {
      type Response = Response;
      type Error = Error;
      type Future = Pin<Box<dyn Future<
        Output = Result<Self::Response, Self::Error>> + Send>>;

      fn call(&self, req: Request<Incoming>) -> Self::Future {
          let s = self.clone();
          (Box::pin(
              async move { handle_request(s, req).await }
              .instrument(span!(Level::DEBUG, "handling request")),
          )) as _
      }
  }
  ```,
) <listing-stack-service>

Для обработки запросов~(рисунок~@listing-stack-handle-request) стек получает соответствующий плагин
по пути запроса и вызывает его метод `handle`. В целях отладки, после успешной обработки запроса
плагином в ответ вставляется заголовок #box["`x-wassel-plugin`"], содержащий ID плагина.

#figure(
  caption: [Обработка запросов стеком],
  kind: image,
  ```rust
  async fn handle_request(s: Stack, req: Request<Incoming>)
      -> (Response, Option<String>) {
      let plugin = match s.get_plugin(req.uri().path()).await {
          Ok(Some(p)) => p,
          Ok(None) => return (NOT_FOUND.into_response(), None),
          Err(e) => return (INTERNAL_SERVER_ERROR.into_response(), None),
      };
      let id = plugin.id().to_owned();
      let response = match plugin.handle(req).await {
          Ok(response) => response,
          Err(e) =>
              return (ServeError::PluginError(e).into_response(), Some(id)),
      };
      let (mut parts, body) = response.into_parts();
      parts.headers.insert(
          "x-wassel-plugin",
          id.parse().expect("Plugin ID should not be invalid header value"),
      );
      (
          Response::from_parts(parts, Body::new(body.map_err(Error::new))),
          Some(id),
      )
  }
  ```,
) <listing-stack-handle-request>

== Исполнение плагинов и обработка запросов <section-plugin-execution>

Для загрузки и исполнения плагинов используется среда выполнения "Wasmtime". Жизненный цикл плагина
включает фазы подготовки, загрузки, исполнения и уничтожения.

=== Фаза подготовки

Сборка плагина осуществляется с помощью `wassel-cli` (раздел @section-cli). В манифесте
`plugin.toml` (рисунок~@image-plugin-manifest) должны быть указаны команда сборки плагина
`build.cmd` и путь к программе WASM `component`. Перед загрузкой плагина вызывается указанная
команда.

#figure(
  caption: [Пример манифеста плагина],
  kind: image,
  ```toml
  id = "rust-fibonacci"
  name = "Rust Fibonacci Plugin"
  version = "0.0.0"
  component = "target/wasm32-wasip2/release/rust_fibonacci.wasm"
  endpoint = "/rust/fibonacci/"
  build.cmd = "cargo build --target wasm32-wasip2 --release"
  ```,
) <image-plugin-manifest>

=== Фаза загрузки

При запуске сервера среда выполнения сначала пытается прочитать `plugin.cwasm` (прекомпилированный
компонент), затем `plugin.wasm` (программа WASM) в случае неудачи. Пользователь не может
предоставить собственный `plugin.cwasm`~---~этот файл может создать только среда выполнения на
основе программы WASM.

Если была прочитана программа WASM, происходит её валидация: Wasmtime проверяет байт-код плагина.
После этого происходит компиляция байт-кода в машинный код платформы хоста с помощью оптимизирующего
JIT-компилятора Cranelift. Если для хоста недоступен Cranelift (например для RISC-V или Raspberry Pi
на ARMv7), стадия компиляции пропускается и при выполнении плагина байт-код интерпретируется с
помощью Pulley.

Следующим этапом является компоновка плагина. Компоновщик wasmtime использует все предоставленные
импорты и компонует их в плагин. Если плагину требуются импорты, которые не были предоставлены,
будет сгенерирована ошибка загрузки плагина.

Затем происходит прединстанциирование: wasmtime выполняет все необходимые подготовительные операции
перед тем, как создать инстанс плагина. Конкретные операции, выполняемые на данном этапе, являются
деталью реализации Wasmtime.

=== Исполнение и уничтожение

При входящем HTTP-запросе среда выполнения создаёт новый инстанс плагина, используя линейную память
из пула. Благодаря прединстанциированию, время непосредственного создания инстанса плагина
оказывается меньше миллисекунды, что делает такую архитектуру пригодной даже в ситуациях, где
предъявляются повышенные требования к задержке обработки запросов.

Выполнение запросов происходёт посредством вызова функции `handle-request` интерфейса `http-handler`
из определения WIT. Входящий HTTP-запрос оборачивается в ресурс WASI, что позволяет плагину получить
доступ к параметрам запроса: путь, метод, заголовки и тело. Для получения ответа от плагина
формируется ресурс `response-outparam`, позволяющий плагину установить статус ответа, заголовки, а
также записать тело запроса.

После обработки запроса инстанс освобождается и память возвращается в пул.

== Реализация импортируемых интерфейсов WIT

Реализация интерфейсов вынесена в отдельные крейты и использует паттерн реализации интерфейсов
"Wasmtime WASI". Крейт `wassel_world` содержит функцию~(рисунок~@listing-add-to-linker), добавляющая
в компоновщик все реализации интерфейсов. Функция обобщённая по типу состояния компонента и требует
реализацию типажей "View". Каждый интерфейс Wassel определяет свой типаж, для которого реализуется
поведение хоста.

#figure(
  caption: [Функция `wassel_world::add_to_linker`],
  kind: image,
  ```rust
  pub fn add_to_linker<
      T: WasiView + WasiHttpView + WasiConfigView
       + HttpClientView + PostgresView + RedisView
       + Send + 'static,
  >(
      linker: &mut Linker<T>,
  ) -> wasmtime::Result<()> {
      wasmtime_wasi::p2::add_to_linker_async(linker)?;
      wasmtime_wasi_http::p2::add_only_http_to_linker_async(linker)?;
      wasmtime_wasi_config::add_to_linker(
        linker, |c| WasiConfig::from(c.wasi_config().variables))?;
      wassel_interface_http_client::add_to_linker(linker)?;
      wassel_interface_postgres::add_to_linker(linker)?;
      wassel_interface_redis::add_to_linker(linker)?;
      Ok(())
  }
  ```,
) <listing-add-to-linker>

=== Интерфейс конфигурации

В качестве интерфейса конфигурации выбран пакет WIT `wasi:config`. Его реализацию содержит сторонний
пакет `wasmtime_wasi_config`, для которого написан небольшой
типаж-адаптер~(рисунок~@listing-wasi-config). Конфигурация наполняется переменнами (variables) из
манифестов `wassel.toml` и `plugin.toml`.

#figure(
  caption: [Типаж `WasiConfigView`],
  kind: image,
  ```rust
  pub trait WasiConfigView {
      fn wasi_config(&mut self) -> WasiConfigCtxView<'_>;
  }

  pub struct WasiConfigCtxView<'a> {
      pub variables: &'a WasiConfigVariables,
  }
  ```,
) <listing-wasi-config>

=== Интерфейс исходящих HTTP-запросов

Для выполнения исходящих запросов используется `reqwest`, обрабатывающий TLS-соединения и
использующий пул подключений для повышения производительности. Крейт `wassel-interface-http-client`
определяет типаж `HttpClientView`~(рисунок~@listing-http-client-view).

#figure(
  kind: image,
  ```rust
  pub trait HttpClientView {
      fn http_client(&mut self) -> HttpClientCtxView<'_>;
  }

  pub struct HttpClientCtxView<'a> {
      pub table: &'a mut ResourceTable,
      pub client: &'a reqwest::Client,
  }

  pub struct HttpClient;

  impl HasData for HttpClient {
      type Data<'a> = HttpClientCtxView<'a>;
  }
  ```,
) <listing-http-client-view>

Для структуры `HttpClientCtxView` реализуется сгенерированный "wit-bindgen" типаж
`http_client::Host`~(рисунок~@listing-http-client-host). Из-за несовместимости типов `http` и
`reqwest` необходимо выполнять конвертацию запроса и ответа при каждом вызове `send`. Эту проблему
возможно ликвидировать, написав собственную реализацию пула подключений и обработки TLS, однако на
момент написаний работы эта задача не была приоритетной.

#figure(
  caption: [Реализация функции `send` на хосте],
  kind: image,
  ```rust
  impl http_client::Host for HttpClientCtxView<'_> {
      async fn send(
          &mut self,
          url: http_client::Url,
          req: Resource<OutgoingRequest>,
      ) -> Result<Resource<IncomingResponse>, ErrorCode> {
          let req = self.table.get_mut(&req)
              .map_err(|e| ErrorCode::InternalError(None))?;
          let method = convert_wasi_method_to_reqwest_method(&req.method)
              .map_err(|_| ErrorCode::HttpRequestMethodInvalid)?;
          let mut request = self.client
              .request(method, url).headers(req.headers.clone().into());
          if let Some(body) = req.body.take() {
              let body = reqwest::Body::wrap_stream(body.into_data_stream());
              request = request.body(body);
          }
          let response = request.send().await
              .map_err(convert_reqwest_error_to_error_code)?;
          let status = response.status().into();
          let headers = response.headers().to_owned();
          let body_stream = Box::pin(response.bytes_stream());
          let hyper_body = UnsyncBoxBody::new(StreamBody::new(body_stream));
          let incoming_body = HostIncomingBody::new(
              hyper_body, Duration::from_secs(5));
          let response = IncomingResponse {
              status,
              headers: FieldMap::new_immutable(headers),
              body: Some(incoming_body),
          };
          let resource = self.table.push(response)
              .map_err(|_| ErrorCode::InternalError(None))?;
          Ok(resource)
      }
  }
  ```,
) <listing-http-client-host>

=== Интерфейс исходящих запросов к Postgres

Для работы с базой данных Postgres используется крейт `tokio-postgres`. Крейт
`wassel-interface-postgres` определяет типаж `PostgresView`~(рисунок~@listing-postgres-view).

#figure(
  kind: image,
  caption: [Типаж `PostgresView`],
  ```rust
  pub trait PostgresView {
      fn postgres(&mut self) -> PostgresCtxView<'_>;
  }

  pub struct PostgresCtxView<'a> {
      pub table: &'a mut ResourceTable,
  }
  ```,
) <listing-postgres-view>

Для структуры `PostgresCtxView` реализуются сгенерированные `wit-bindgen` типажи
`postgres::HostConnection` и `postgres::HostConnectionConfig`. Ресурс подключения
`postgres::Connection` создаётся через статический метод `open`, принимающий ресурс конфигурации.
Под капотом при вызове `open` открывается соединение с базой данных через
`tokio-postgres::connect`~(рисунок~@listing-pg-connection). Фоновая задача `tokio`, опрашивающая
соединение, хранится внутри структуры и прерывается при её уничтожении.

#figure(
  kind: image,
  caption: [Установка соединения с Postgres],
  ```rust
  impl PgConnection {
      pub async fn new(
          config: &PgConnectionConfig,
      ) -> Result<Self, tokio_postgres::Error> {
          let (client, conn) = connect(&config.string, NoTls).await?;
          let handle = tokio::spawn(async {
              if let Err(e) = conn.await {
                  eprintln!("Error polling connection: {e}");
              }
          });
          Ok(Self { client, connection_task: handle })
      }
  }
  ```,
) <listing-pg-connection>

Методы `query` и `execute` ресурса `Connection` принимают SQL-строку и список параметров типа
`postgres::Parameter`. Параметры конвертируются в типы `tokio-postgres` посредством реализации
типажей `ToSql` и `FromSql` (рисунок~@listing-pg-query). Результат запроса `query` возвращается как
`postgres::RowSet`, содержащий метаданные столбцов и строки значений.

#figure(
  kind: image,
  caption: [Реализация метода `query` на хосте],
  ```rust
  async fn query(
      &mut self,
      self_: Resource<postgres::Connection>,
      sql: String,
      params: Vec<postgres::Parameter>,
  ) -> Result<postgres::RowSet, postgres::Error> {
      let conn = self.table.get(&self_)?;
      let rows = conn.query(&sql, &params).await?;
      let columns = rows[0].columns().iter().map(Into::into).collect();
      let rows = rows
          .into_iter()
          .map(|row| {
              (0..row.len())
                  .map(|i| row.try_get(i))
                  .collect::<Result<Vec<postgres::Value>, _>>()
          })
          .collect::<Result<Vec<_>, _>>()
          .map_err(|e| postgres::Error::Query(e.to_string()))?;
      Ok(postgres::RowSet { columns, rows })
  }
  ```,
) <listing-pg-query>

=== Интерфейс исходящих запросов к Redis

Для работы с Redis используется крейт `redis`. Крейт `wassel-interface-redis` определяет типаж
`RedisView`~(рисунок~@listing-redis-view). Структура `RedisCtxView` реализует типажи
`HostConnection`, `HostConnectionConfig` и `HostLazyRedisValue`.

#figure(
  kind: image,
  caption: [Типаж `RedisView`],
  ```rust
  pub trait RedisView {
      fn redis(&mut self) -> RedisCtxView<'_>;
  }

  pub struct RedisCtxView<'a> {
      pub table: &'a mut ResourceTable,
  }
  ```,
) <listing-redis-view>

Подключение к Redis создаётся через `redis::Client::open` и хранится в структуре
`RedisConnection`~(рисунок~@listing-redis-connection). При каждом вызове метода `execute`
открывается мультиплексированное асинхронное соединение, что позволяет обслуживать несколько
одновременных запросов через единственный клиент без явного пула соединений.

#figure(
  kind: image,
  caption: [Установка соединения и выполнение команды Redis],
  ```rust
  impl RedisConnection {
      pub fn open(config: &RedisConnectionConfig)
          -> Result<Self, redis::RedisError>
      {
          let client = redis::Client::open(config.url.clone())?;
          Ok(Self { client })
      }

      pub async fn execute(
          &self,
          command: &str,
          args: &[RedisArgument],
      ) -> Result<redis::Value, redis::RedisError> {
          let mut conn = self.client
              .get_multiplexed_async_connection().await?;
          let mut cmd = redis::cmd(command);
          for arg in args {
              match arg {
                  RedisArgument::I64(num) => cmd.arg(num),
                  RedisArgument::Str(str) => cmd.arg(str),
              };
          }
          cmd.query_async(&mut conn).await
      }
  }
  ```,
) <listing-redis-connection>

Возвращаемое значение типа `redis::Value` конвертируется в тип WIT `RedisValue` посредством функции
`redis_value_to_wasm`. Поскольку `RedisValue` является рекурсивным типом (массивы, карты и атрибуты
содержат вложенные значения), вложенные значения оборачиваются в ресурс `LazyRedisValue` и
помещаются в таблицу ресурсов~(рисунок~@listing-redis-convert).

#figure(
  kind: image,
  caption: [Конвертация значения Redis в тип WIT],
  ```rust
  pub fn redis_value_to_wasm(
      table: &mut ResourceTable,
      v: redis::Value,
  ) -> Result<RedisValue, Error> {
      let val = match v {
          redis::Value::Nil          => RedisValue::Nil,
          redis::Value::Int(v)       => RedisValue::Int(v),
          redis::Value::BulkString(v)=> RedisValue::BulkString(v),
          redis::Value::SimpleString(v) => RedisValue::SimpleString(v),
          redis::Value::Okay         => RedisValue::Okay,
          redis::Value::Double(v)    => RedisValue::Double(v),
          redis::Value::Boolean(v)   => RedisValue::Boolean(v),
          redis::Value::Array(v) =>
              RedisValue::Array(convert_vec_to_wasm(table, v)?),
          // ...
          redis::Value::ServerError(e) =>
              return Err(Error::ServerError(e.to_string())),
          other =>
              return Err(Error::TypeError(format!("{other:?}"))),
      };
      Ok(val)
  }
  ```,
) <listing-redis-convert>

== Тестирование среды выполнения

=== Тестирование примерами

Для проверки корректности работы среды выполнения в репозиториях Rust SDK и Python SDK, разработаны
эталонные плагины, каждый из которых задействует отдельную функцию среды: конфигурацию, файловую
систему, исходящие HTTP-запросы, подключение к Postgres и Redis. Успешная сборка и запуск каждого
плагина подтверждают корректность соответствующего интерфейса среды выполнения.

=== Интеграционное тестирование интерфейса Postgres

Для проверки корректности реализации интерфейса Postgres разработан тестовый плагин, реализующий два
эндпоинта. Эндпоинт `/select` проверяет корректность чтения значений различных типов из базы данных.
Эндпоинт `/bind` проверяет корректность передачи параметров в SQL-запросы. Каждый тест-кейс
выполняет SQL-запрос и сравнивает полученное значение с ожидаемым. Результаты всех тест-кейсов
возвращаются в теле ответа; HTTP-статус ответа~---~"`200 OK`" при успехе всех тестов и
"`500 Internal Server Error`" при наличии хотя бы одного сбоя.

Результаты выполнения тестов представлены на рисунке~@listing-postgres-test-results.

#figure(
  caption: [Результаты интеграционного тестирования интерфейса Postgres],
  kind: image,
  ```
  $ curl -i localhost:9000/test/postgres/select
  HTTP/1.1 200 OK
  x-wassel-plugin: test-postgres

  'SELECT 1::BOOLEAN'             => OK
  'SELECT 123::INT2'              => OK
  'SELECT 123::INT4'              => OK
  'SELECT 123::INT8'              => OK
  'SELECT 123::REAL'              => OK
  'SELECT 123::DOUBLE PRECISION'  => OK
  'SELECT 'Hello, World!'::TEXT'  => OK
  'SELECT 'Hello, World!'::BYTEA' => OK

  $ curl -i localhost:9000/test/postgres/bind
  HTTP/1.1 200 OK
  x-wassel-plugin: test-postgres

  'SELECT $1 = 1::BOOLEAN'              => OK
  'SELECT $1 = 123::INT2'               => OK
  'SELECT $1 = 123::INT4'               => OK
  'SELECT $1 = 123::INT8'               => OK
  'SELECT $1 = 123::REAL'               => OK
  'SELECT $1 = 123::DOUBLE PRECISION'   => OK
  'SELECT $1 = 'Hello, World!'::TEXT'   => OK
  'SELECT $1 = 'Hello, World!'::BYTEA'  => OK
  ```,
) <listing-postgres-test-results>

== Выполнение и проверка требований безопасности

Ключевым нефункциональным требованием, определённым в разделе~@section-criteria, является изоляция
кода плагинов. Среда выполнения размещает каждый WASM-компонент в изолированной «песочнице»,
полностью отсекающей прямое взаимодействие с операционной системой хоста: у плагина отсутствуют
доступ к файловой системе (кроме явно переданных директорий), переменным окружения и сетевым
сокетам. Любое обращение к внешним ресурсам возможно исключительно через явно предоставленные
WIT-интерфейсы, зарегистрированные хостом.

Песочница строится на трёх уровнях защиты:
- *Изоляция памяти*: каждый экземпляр плагина получает собственную линейную память, адресное
  пространство которой полностью отделено от хостового процесса и других инстансов. Выход за
  допустимые границы немедленно вызывает прерывание (trap), безопасно завершающее выполнение, не
  затрагивая операционную систему.
- *Строгий контроль импортов*: единственный способ для Wasm-модуля взаимодействовать с
  окружением~---~вызов функций, определённых в WIT-спецификациях и явно подключённых хостом
  (например, `wasi:http/outgoing-handler`, `wasi:config/store`, клиентские интерфейсы Redis и
  PostgreSQL). Все иные системные вызовы, включая работу с сетью, отсутствуют в таблице импортов и
  не могут быть использованы.
- *Ограниченная виртуальная файловая система*: доступные плагину пути ограничены директориями,
  перечисленными в секции `[build.data]` манифеста `plugin.toml`. Хост монтирует только эти
  директории в виртуальную ФС Wasm; любые попытки обращения к иным путям возвращают ошибки
  отсутствия файла или недостатка прав.

Для верификации перечисленных механизмов было проведено тестирование трёх сценариев, имитирующих
попытки обойти изоляцию.

Первый сценарий проверял способность плагина прочитать произвольный системный файл, например
`/etc/passwd`, с помощью стандартной функции `std::fs::read`. Попытка была блокирована: виртуальная
файловая система не содержала такого пути, и операция завершилась ошибкой, не оказав влияния на
хост.

Второй сценарий пытался получить переменную окружения хоста через `std::env::var`. Так как
переменные среды операционной системы не экспортируются в изолированное окружение, а конфигурация
передаётся плагину исключительно через вызовы `wasi_config::store::get`, прямой запрос вернул
признак отсутствия переменной.

Третий сценарий нацеливался на установку прямого TCP-соединения с использованием
`std::net::TcpStream`. Поскольку среда выполнения не предоставляет импорт стандартных сетевых
сокетов, функция была недоступна. Весь исходящий HTTP-трафик направляется только через управляемый
хостом интерфейс `wasi:http/outgoing-handler`, реализующий авторизованные запросы с соблюдением
политик безопасности.

Все три попытки были остановлены на этапе выполнения: соответствующие операции вернули ошибки, при
этом не возникло ни паники, ни нарушения стабильности хост-системы. Тестирование проводилось как при
использовании JIT-компилятора Cranelift, так и в режиме интерпретации через Pulley, что подтвердило
идентичность изоляционных свойств независимо от способа исполнения.

Результаты верификации подтверждают полное соответствие реализованной системы требованию изоляции
исполняемого кода: плагин не способен читать или модифицировать файлы вне разрешённых директорий,
получать доступ к окружению хоста или устанавливать произвольные сетевые соединения. Такая
архитектура гарантирует, что даже вредоносный или ошибочный код остаётся строго ограничен рамками
выделенной песочницы.

== CLI для управления сервером <section-cli>

CLI-приложение `wassel-cli` является ключевым при разработке и эксплуатации плагинов. Для его
разработки используется `clap`~---~библиотека, предоставляющая эргономичные функции парсинга
аргументов командной строки. Для парсинга аргументов определены структуры `Args` и
`Command`~(рисунок~@listing-args-struct)

#figure(
  caption: [Структуры `Args` и `Command`],
  kind: image,
  ```rust
  #[derive(Debug, Parser)]
  struct Args {
      #[command(subcommand)]
      cmd: Command,
  }

  #[derive(Debug, Subcommand)]
  enum Command {
      Stack(StackArgs),
      Plugin(PluginArgs),
  }
  ```,
) <listing-args-struct>

Типаж `Parser` предоставляет функцию `parse`, которая возвращает экземпляр `Args` в случае успешного
парсинга аргументов, иначе завершает программу с кодом "USAGE"~(рисунок @listing-cli-main).

#figure(
  caption: [Точка входа CLI],
  kind: image,
  ```rust
  fn main() -> anyhow::Result<()> {
      let _ = dotenvy::dotenv();
      let args = Args::parse();
      match args.cmd {
          Command::Stack(stack_args) => stack::run(stack_args),
          Command::Plugin(plugin_args) => plugin::run(plugin_args),
      }
  }
  ```,
) <listing-cli-main>

Обработчик команды `stack` включает в себя подкоманды `build` и
`serve`~(рисунок~@listing-stack-cmd).

#figure(
  caption: [Обработчик команды `stack`],
  kind: image,
  ```rust
  pub fn run(args: StackArgs) -> anyhow::Result<()> {
      match args.command {
          StackCommand::Build => cmd_build(&args.manifest_path),
          StackCommand::Serve => cmd_serve(&args.manifest_path),
      }
  }
  ```,
) <listing-stack-cmd>

Обработчик команды `stack build`~(рисунок @listing-stack-build-cmd) выполняет чтение манифеста и
сборку каждого плагина.

#figure(
  caption: [Обработчик команды `stack build`],
  kind: image,
  ```rust
  pub fn cmd_build(path: &Path) -> anyhow::Result<()> {
      build_entire_stack(path)?;
      Ok(())
  }
  ```,
) <listing-stack-build-cmd>

Обработчик команды `stack serve`~(рисунок @listing-stack-serve-cmd) вызывает сборку стека и, в
случае успеха, запускает сервера стека и административной панели.

#figure(
  caption: [Обработчик команды `stack serve`],
  kind: image,
  ```rust
  pub fn cmd_serve(path: &Path) -> anyhow::Result<()> {
      build_entire_stack(path)?;
      let log_receiver = wassel_subscriber::init_tracing_subscriber();
      runtime::Builder::new().enable_all().build().block_on(async {
          let stack = Stack::load(path).await?;
          tokio::select! {
              e = run_server(stack.clone()) => e,
              e = run_admin_dashboard(stack.clone(), log_receiver) => e,
      }})
  }
  ```,
) <listing-stack-serve-cmd>

Помимо функций парсинга `clap` предоставляет автоматическую генерацию страницы
"Help"~(рисунок~@cli-help). Это позволяет значительно упростить разработку и сопровождение
приложений командной строки.

#figure(
  caption: [Результат вызова команды `help stack`],
  kind: image,
  ```
  $ wassel-cli help stack
  Manage application stack

  Usage: wassel-cli stack [OPTIONS] <COMMAND>

  Commands:
    build
    serve
    help   Print this message or the help of the given subcommand(s)

  Options:
    -m, --manifest-path <MANIFEST_PATH>  [default: .]
    -h, --help                           Print help
  ```,
) <cli-help>

== FFI среды выполнения

Для возможности использования среды выполнения Wassel из других языков программирования разработаны
привязки C~---~Libwassel~@libwassel-github.

=== Структура пакета FFI

Пакет включает в себя крейт на Rust, конфигурацию cbindgen~@cbindgen-github, скрипт сборки,
вызывающий cbindgen, директорию include с результатами генерации привязок, и файл CMakeLists.txt для
включения в сторонние проекты~(рисунок~@libwassel-tree).

#figure(
  caption: [Структура проекта Libwassel],
  kind: image,
  ```
  libwassel
  ├── include
  │   └── wassel.h
  ├── src
  │   └── lib.rs
  ├── build.rs
  ├── Cargo.lock
  ├── Cargo.toml
  ├── cbindgen.toml
  └── CMakeLists.txt
  ```,
) <libwassel-tree>

=== Определение экспортируемых функций

При экспорте функций из Rust неизбежно использование unsafe-кода и работы с указателями.
Дополнительно задача осложняется тем, что большая часть функций библиотеки Wassel асинхронная. Для
оборачивания асинхронные функций Rust используется функция
`block_on`~(рисунок~@listing-ffi-example).

#figure(
  caption: [Пример функции FFI],
  kind: image,
  ```rust
  #[unsafe(no_mangle)]
  pub unsafe extern "C" fn wassel_stack_load(path: *const c_char)
      -> *mut wassel_Stack {
      let path = unsafe {
          let path = CStr::from_ptr(path);
          path.to_string_lossy().to_string()
      };

      block_on(async move {
          let stack = Stack::load(Path::new(&path)).await.unwrap();
          let stack = Box::new(wassel_Stack { stack });
          Box::into_raw(stack)
      })
  }
  ```,
) <listing-ffi-example>

Реализация функции использует глобальную среду выполнения `tokio`~(рисунок~@listing-block-on).
Каждая операция блокирует текущий поток, поэтому использование библиотеки Wassel требует создания
дополнительных потоков ОС, если требуется параллельная обработка запросов.

#figure(
  caption: [Реализация функции `block_on`],
  kind: image,
  ```rust
  fn block_on<F: Future>(f: F) -> F::Output {
      tokio::task::block_in_place(move || get_tokio_runtime().block_on(f))
  }
  ```,
) <listing-block-on>

=== Генерация привязок

Cbindgen парсит исходный код на Rust~(рисунок~@listing-cbindgen-result\.а) и извлекает определения
структур и функций. На основании функций, имеющих атрибуты "`extern "C"`" и
"`#[unsafe(no_mangle)]`", генерируются определения функций; на основании структур, имеющих атрибут
"`#[repr(C)]`" генерируются определения структур (рисунок~@listing-cbindgen-result\.б).

#[
  #show figure.where(kind: image): it => {
    block(breakable: false)[
      #it.body
      #it.caption
    ]
  }
  #figure(
    caption: [Пример генерации привязок],
    kind: image,
    grid(
      columns: 2,
      column-gutter: 0pt,
      row-gutter: 1.15em,
      rect(stroke: 0.5pt, ```rust
      #[unsafe(no_mangle)]
      pub unsafe extern "C"
      fn wassel_stack_load(
        path: *const c_char
      ) -> *mut wassel_Stack { ... }

      #[repr(C)]
      pub struct wassel_HttpHeaderMap {
          keys: *const *const c_char,
          values: *const *const c_char,
          count: usize,
      }
      ```),
      rect(stroke: 0.5pt, ```c

      struct wassel_Stack *
      wassel_stack_load(const char *path);




      typedef struct wassel_HttpHeaderMap {
            const char *const *keys;
            const char *const *values;
            size_t count;
      } wassel_HttpHeaderMap;
      ```),

      [а) Определение Rust], [б) Результат C],
    ),
  ) <listing-cbindgen-result>
]

Конфигурация cbindgen вынесена в файл `cbindgen.toml`~(рисунок~@listing-cbindgen-toml).

#figure(
  caption: [Файл конфигурации cbindgen],
  kind: image,
  ```toml
  language = "C"
  include_guard = "WASSEL_BINDINGS_H_"
  autogen_warning = "/* Warning, this file is autogenerated by cbindgen. Don't modify this manually. */"
  include_version = true
  cpp_compat = true
  usize_is_size_t = true
  ```,
) <listing-cbindgen-toml>

Для автоматического вызова cbindgen при сборке библиотеки разработан скрипт сборки `build.rs`,
подключающий cbindgen как библиотеку и вызывающий функцию `generate`~(рисунок~@listing-build-rs).

#figure(
  caption: [Скрипт сборки `build.rs`],
  kind: image,
  ```rust
  fn main() {
      let crate_dir = std::env::var("CARGO_MANIFEST_DIR").unwrap();
      let config = cbindgen::Config::from_root_or_default(&crate_dir);
      cbindgen::Builder::new()
          .with_config(config)
          .with_crate(&crate_dir)
          .generate()
          .expect("Could not generate bindings")
          .write_to_file("include/wassel.h");
  }
  ```,
) <listing-build-rs>

В результате при вызова команды `cargo build` генерируется заголовочный файл
`include/wassel.h`~(приложение~@appendix-wassel-h). На основании этого файла возможно сгенерировать
привязки для других языков программирования при необходимости.

=== Конфигурация CMake

Для удобства пользователей разработана конфигурация CMake `CMakeLists.txt`~(рисунок~@listing-cmake).
Поскольку CMake не поддерживает сборку проектов на Rust напрямую, был определён сторонний проект
`wassel-crate`, выполняющий сборку посредством вызова команды `cargo build`.

#figure(
  caption: [Определение библиотеки CMake],
  kind: image,
  ```cmake
  ExternalProject_Add(
      wassel-crate
      INSTALL_COMMAND "${WASSEL_INSTALL_COMMAND}"
      BUILD_COMMAND
          ${CMAKE_COMMAND} -E env ${WASSEL_BUILD_ENV}
          ${WASSEL_CARGO_BINARY} build --release
            --target ${WASSEL_TARGET}
            --package libwassel
      USES_TERMINAL_BUILD TRUE
      BINARY_DIR ${CMAKE_CURRENT_SOURCE_DIR}
      BUILD_ALWAYS ${WASSEL_ALWAYS_BUILD}
      BUILD_BYPRODUCTS ${WASSEL_SHARED_FILES} ${WASSEL_STATIC_FILES}
  )
  add_library(wassel INTERFACE)
  add_dependencies(wassel wassel-crate)
  target_include_directories(wassel INTERFACE include)
  ```,
) <listing-cmake>

При вызове сборки CMake~(рисунок~@cmake-build) можно заметить выполнение команды `cargo build`.

#figure(
  caption: [Результат вызова системы сборки],
  kind: image,
  ```
  $ cmake -S . -B build -G Ninja
  -- The C compiler identification is AppleClang 17.0.0.17000404
  -- Detecting C compiler ABI info
  -- Detecting C compiler ABI info - done
  -- Check for working C compiler: /usr/bin/cc - skipped
  -- Detecting C compile features
  -- Detecting C compile features - done
  -- Configuring done (0.6s)
  -- Generating done (0.0s)
  -- Build files have been written to: wasselteam/libwassel/build

  $ cmake --build build
  [5/8] Performing build step for 'wassel-crate'
      Finished `release` profile [optimized] target(s) in 0.67s
  [8/8] Completed 'wassel-crate'
  ```,
) <cmake-build>

В результате будет сгенерирован заголовочный файл `wassel.h` и будут скомпилированы статическая и
динамическая библиотеки~(рисунок~@image-libwassel-libs).

#figure(
  caption: [Артефакты сборки Libwassel],
  kind: image,
  ```
  1.6k  Jun 07 19:43 wassel.h
  46.4M Jun 07 20:20 libwassel.a
  20.4M Jun 07 20:20 libwassel.dylib
  ```,
) <image-libwassel-libs>
