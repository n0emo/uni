= Определение WIT

WIT~---~это IDL, позволяющий определить контракт взаимодействия между хостом (средой выполнения) и
гостем (плагином). Определения WIT компилируются инструментом `wit-bindgen` в привязки для
конкретных языков программирования, обеспечивая взаимодействие между компонентами. В системе
определяется WIT-пакет "`wassel:foundation`", на основе которого:

+ Определяются интерфейсы для компоновщика Wasmtime.
+ Определяется структура SDK (@section-sdk).

== Структура WIT-пакета

Полный исходный текст WIT-пакета представлен в приложении~@appendix-wit.

Пакет поделён на 4 файла:

- *wassel.wit*~---~определения миров пакета;
- *http-client.wit*~---~определения интерфейса исходящих HTTP-запросов;
- *postgres.wit*~---~определения интерфейса SQL-запросов к Postgres;
- *redis.wit*~---~определения интерфейса исходящих запросов к Redis.

=== Миры

Пакет определяет два мира~(рисунок~@listing-wassel-wit). Мир `platform` описывает совокупность всех
импортируемых интерфейсов: стандартные интерфейсы WASI (конфигурация, файловая система, HTTP,
ввод-вывод, генератор случайных чисел, сокеты, CLI) и собственные интерфейсы Wassel (HTTP-клиент,
Postgres, Redis). Мир `http-plugin` расширяет `platform` и дополнительно экспортирует интерфейс
`http-handler`, который плагин должен реализовать.

#figure(
  caption: [Определение миров пакета `wassel:foundation`],
  kind: image,
  ```wit
  world platform {
    include wasi:config/imports@0.2.0-rc.1;
    include wasi:http/imports@0.2.10;
    // ...
    import wassel:http-client/http-client;
    import wassel:postgres/postgres;
    import wassel:redis/redis;
  }
  world http-plugin {
    include platform;
    export http-handler;
  }
  ```,
) <listing-wassel-wit>

== Импортируемые интерфейсы

=== Интерфейс http-client

Интерфейс `http-client` предоставляет единственную функцию `send` для выполнения исходящих
HTTP-запросов~(рисунок~@listing-http-client-wit). Функция принимает URL в виде строки и ресурс
исходящего запроса `outgoing-request`, возвращая либо ресурс входящего ответа `incoming-response`,
либо код ошибки `error-code`. Типы запроса и ответа используются из стандартного интерфейса
`wasi:http/types`, что обеспечивает совместимость с экосистемой WASI.

#figure(
  caption: [Интерфейс `wassel:http-client/http-client`],
  kind: image,
  ```wit
  interface http-client {
    use wasi:http/types@0.2.10.{
      outgoing-request, incoming-response, error-code
    };
    type url = string;
    send: func(
      url: url,
      req: outgoing-request
    ) -> result<incoming-response, error-code>;
  }
  ```,
) <listing-http-client-wit>

=== Интерфейс postgres

Интерфейс `postgres` предоставляет доступ к СУБД Postgres. Он включает два ресурса:
`connection-config` для хранения строки подключения и `connection` для выполнения
запросов~(рисунок~@listing-postgres-resources-wit). Ресурс `connection` создаётся статической
функцией `open`, принимающей конфигурацию. Метод `query` возвращает набор строк `row-set`, метод
`execute`~---~количество затронутых строк.

#figure(
  caption: [Ресурсы интерфейса `wassel:postgres/postgres`],
  kind: image,
  ```wit
  resource connection-config {
    constructor(connection-string: string);
  }
  resource connection {
    open: static func(
      config: connection-config
    ) -> result<connection, error>;
    query: func(
      sql: string,
      params: list<parameter>
    ) -> result<row-set, error>;
    execute: func(
      sql: string,
      params: list<parameter>
    ) -> result<u64, error>;
  }
  ```,
) <listing-postgres-resources-wit>

Параметры запросов и значения результатов представлены типом-вариантом `value`, охватывающим весь
спектр типов данных Postgres~(таблица~@table-postgres-types).

#figure(
  caption: [Типы данных интерфейса Postgres],
  table(
    columns: (1fr, 2.2fr),
    table.header([*Тип WIT*], [*Описание*]),
    [`boolean`], [Булево значение],
    [`int16`, `int32`, `int64`], [Целочисленные типы],
    [`float32`, `float64`], [Типы с плавающей запятой],
    [`decimal`], [Число произвольной точности (строковое представление)],
    [`money`], [Денежное значение (`s64`)],
    [`uuid`], [UUID (4 поля: `u32`, `u16`, `u16`, `u64`)],
    [`text`], [Строка],
    [`binary`], [Бинарные данные (`list<u8>`)],
    [`date`, `time`, `datetime`], [Типы даты и времени],
    [`interval`], [Временной интервал (месяцы, дни, микросекунды)],
    [`range-int32`, `range-int64`, `range-decimal`], [Диапазоны числовых типов],
    [`array-int32`, `array-int64`, `array-decimal`, `array-str`], [Массивы скалярных типов],
    [`jsonb`], [JSON в бинарном представлении (`list<u8>`)],
    [`hstore`], [Хранилище пар ключ--значение],
    [`point`, `circle`, `line`, `line-segment`, `path`, `polygon`, `cube`], [Геометрические типы],
    [`pg-null`], [Значение `NULL`],
    [`other`], [Нераспознанный тип (сырые байты)],
  ),
) <table-postgres-types>

Структурные типы определены как записи (`record`). Так, тип `datetime` содержит поля `date`, `time`
и опциональное смещение часового пояса в часах~(рисунок~@listing-postgres-datetime-wit).

#figure(
  caption: [Определение типов даты и времени в интерфейсе Postgres],
  kind: image,
  ```wit
  record date     { year: s32, month: u8, day: u8 }
  record time     { hour: u8, minute: u8, second: u8, nanosecond: u32 }
  record datetime { date: date, time: time, offset: option<s16> }
  record interval { months: s32, days: s32, microseconds: s64 }
  ```,
) <listing-postgres-datetime-wit>

Тип ошибки `error` является вариантом с тремя ветвями: `database`~---~структурированная ошибка от
сервера Postgres, `query`~---~ошибка выполнения запроса, `other`~---~прочие ошибки. Вариант
`database` представлен записью `database-error`, содержащей все поля диагностического сообщения
протокола PostgreSQL: уровень серьёзности, код, текст сообщения, подсказку, позицию ошибки в
запросе, а также имена схемы, таблицы, столбца и ограничения.

=== Интерфейс redis

Интерфейс `redis` предоставляет доступ к Redis. Аналогично Postgres, он определяет ресурсы
`connection-config` и `connection`~(рисунок~@listing-redis-resources-wit). Ресурс `connection`
предоставляет единственный метод `execute`, принимающий имя команды и список аргументов типа
`redis-argument`. Такой подход позволяет выполнять произвольные команды Redis, не ограничивая
разработчика фиксированным набором методов.

#figure(
  caption: [Ресурсы интерфейса `wassel:redis/redis`],
  kind: image,
  ```wit
  resource connection-config {
    constructor(connection-string: string);
  }
  resource connection {
    open: static func(
      config: connection-config
    ) -> result<connection, error>;
    execute: func(
      command: string,
      arguments: list<redis-argument>
    ) -> result<redis-value, error>;
  }
  ```,
) <listing-redis-resources-wit>

Аргументы команды представлены вариантом `redis-argument` с двумя ветвями: `i64` для целых чисел и
`str` для строк. Возвращаемое значение представлено вариантом `redis-value`, охватывающим все типы
значений протокола RESP3~(таблица~@table-redis-types).

#figure(
  caption: [Типы значений интерфейса Redis],
  table(
    columns: (1fr, 2fr),
    table.header([Тип WIT], [Описание]),
    [`nil`], [Пустое значение],
    [`int`], [Целое число (`s64`)],
    [`bulk-string`], [Бинарная строка (`list<u8>`)],
    [`simple-string`], [Простая строка],
    [`okay`], [Подтверждение успешной операции],
    [`double`], [Число с плавающей запятой (`f64`)],
    [`boolean`], [Булево значение],
    [`big-number`], [Большое целое число (строковое представление)],
    [`array`, `set`], [Упорядоченный и неупорядоченный наборы значений],
    [`map`], [Словарь пар ключ--значение],
    [`attribute`], [Значение с метаданными],
    [`verbatim-string`], [Строка с указанием формата (текст или Markdown)],
    [`push`], [Push-сообщение (подписки, инвалидация кэша и др.)],
  ),
) <table-redis-types>

Поскольку тип `redis-value` является рекурсивным~---~массивы, множества, словари и атрибуты содержат
вложенные значения~---~для разрыва рекурсии вводится ресурс `lazy-redis-value`. Вложенные значения
передаются не напрямую, а через дескриптор этого ресурса, что соответствует ограничениям
компонентной модели WASM на рекурсивные типы.

== Экспортируемые интерфейсы

Интерфейс `http-handler` определяет единственную функцию `handle-request`, которую плагин обязан
экспортировать~(рисунок~@listing-http-handler-wit). Функция принимает два параметра: ресурс
входящего запроса `incoming-request` и ресурс выходного параметра ответа `response-outparam`. Оба
типа заимствуются из стандартного интерфейса `wasi:http/types`.

#figure(
  caption: [Интерфейс `http-handler`],
  kind: image,
  ```wit
  interface http-handler {
    use wasi:http/types@0.2.10.{
      incoming-request, response-outparam
    };
    handle-request: func(
      request: incoming-request,
      response-out: response-outparam
    );
  }
  ```,
) <listing-http-handler-wit>

Использование `response-outparam` вместо возвращаемого значения функции обусловлено требованиями
протокола HTTP: заголовки ответа должны быть зафиксированы до начала потоковой передачи тела. Такая
модель позволяет плагину начать запись тела ответа до его полного формирования, что важно для
потоковых сценариев.
