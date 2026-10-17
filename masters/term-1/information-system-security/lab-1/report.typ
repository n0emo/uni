#import "../common.typ": *
#import "@preview/cetz:0.4.2"

#show: report.with(
  number: "1",
  title: "Создание реляционной БД под управлением СУБД Microsoft SQL Server",
)

#let tables = (
  products: (
    col: 0,
    row: 0,
    columns: (
      ("product_id", "PK"),
      ("name", "U"),
      ("category", ""),
      ("price", ""),
      ("is_available", ""),
    ),
  ),
  order_items: (
    col: 1,
    row: 0,
    columns: (
      ("order_item_id", "PK"),
      ("order_id", "FK"),
      ("product_id", "FK"),
      ("photo_id", "FK"),
      ("quantity", ""),
      ("unit_price", ""),
    ),
  ),
  orders: (
    col: 2,
    row: 0,
    columns: (
      ("order_id", "PK"),
      ("customer_id", "FK"),
      ("soldier_id", "FK"),
      ("manager_id", "FK"),
      ("designer_id", "FK"),
      ("created_at", ""),
      ("status", ""),
      ("total_amount", ""),
      ("issued_at", ""),
    ),
  ),
  payments: (
    col: 3,
    row: 0,
    columns: (
      ("payment_id", "PK"),
      ("order_id", "FK"),
      ("amount", ""),
      ("paid_at", ""),
      ("method", ""),
    ),
  ),
  photos: (
    col: 0,
    row: 1,
    columns: (
      ("photo_id", "PK"),
      ("session_id", "FK"),
      ("file_name", "U"),
      ("taken_at", ""),
      ("review_status", ""),
      ("reviewer_id", "FK"),
      ("reviewed_at", ""),
      ("review_comment", ""),
    ),
  ),
  employees: (
    col: 1,
    row: 1,
    columns: (
      ("employee_id", "PK"),
      ("last_name", ""),
      ("first_name", ""),
      ("patronymic", ""),
      ("position", ""),
      ("phone", "U"),
      ("hired_on", ""),
      ("login_name", "U"),
    ),
  ),
  customers: (
    col: 2,
    row: 1,
    columns: (
      ("customer_id", "PK"),
      ("last_name", ""),
      ("first_name", ""),
      ("patronymic", ""),
      ("phone", "U"),
      ("email", ""),
      ("address", ""),
      ("registered_at", ""),
    ),
  ),
  relatives: (
    col: 3,
    row: 1,
    columns: (
      ("soldier_id", "PK, FK"),
      ("customer_id", "PK, FK"),
      ("kinship", ""),
    ),
  ),
  photo_soldiers: (
    col: 0,
    row: 2,
    columns: (
      ("photo_id", "PK, FK"),
      ("soldier_id", "PK, FK"),
    ),
  ),
  photo_sessions: (
    col: 1,
    row: 2,
    columns: (
      ("session_id", "PK"),
      ("kind", ""),
      ("unit_id", "FK"),
      ("customer_id", "FK"),
      ("photographer_id", "FK"),
      ("session_date", ""),
      ("location", ""),
    ),
  ),
  military_units: (
    col: 2,
    row: 2,
    columns: (
      ("unit_id", "PK"),
      ("designation", "U"),
      ("garrison", ""),
      ("contact_phone", ""),
    ),
  ),
  soldiers: (
    col: 3,
    row: 2,
    columns: (
      ("soldier_id", "PK"),
      ("unit_id", "FK"),
      ("personal_number", "U"),
      ("last_name", ""),
      ("first_name", ""),
      ("patronymic", ""),
      ("birth_date", ""),
      ("military_rank", ""),
      ("call_up_date", ""),
      ("discharge_date", ""),
    ),
  ),
)

// Сетка 4 × 3: строки выровнены по верхнему краю, между ними — полосы для связей
#let er-diagram = cetz.canvas(length: 1cm, {
  import cetz.draw: *

  let width = 3.6
  let step = 4.1
  let header = 0.55
  let line-height = 0.38
  let gap = 1.1

  let height(t) = header + tables.at(t).columns.len() * line-height
  let row-height(r) = calc.max(
    ..tables.values().filter(t => t.row == r).map(t => header + t.columns.len() * line-height),
  )
  let row-top(r) = -range(r).map(i => row-height(i) + gap).sum(default: 0)
  let row-bottom(r) = row-top(r) - row-height(r)

  let left(t) = tables.at(t).col * step
  let right(t) = left(t) + width
  let top(t) = row-top(tables.at(t).row)
  let bottom(t) = top(t) - height(t)
  let x(t, dx) = left(t) + dx
  let y(t, column) = {
    let i = tables.at(t).columns.position(c => c.first() == column)
    top(t) - header - (i + 0.5) * line-height
  }
  let lane(r) = row-bottom(r) - gap / 2

  for (name, t) in tables {
    let x0 = left(name)
    let y0 = top(name)
    rect((x0, y0), (x0 + width, y0 - header), fill: luma(225), stroke: 0.6pt)
    content((x0 + width / 2, y0 - header / 2), text(size: 7.5pt, weight: "bold", raw(name)))
    rect((x0, y0 - header), (x0 + width, bottom(name)), stroke: 0.6pt)
    for (i, (column, key)) in t.columns.enumerate() {
      let yc = y0 - header - (i + 0.5) * line-height
      content((x0 + 0.12, yc), anchor: "west", text(size: 7pt, raw(column)))
      if key != "" {
        content((x0 + width - 0.12, yc), anchor: "east", text(size: 6pt, fill: luma(80), key))
      }
    }
  }

  let link(..points) = line(
    ..points,
    stroke: 0.5pt,
    mark: (end: ">", fill: black, scale: 0.5),
  )
  // связь соседних по горизонтали таблиц: от столбца FK к столбцу PK с изломом в промежутке
  let side(child, fk, parent, pk, dx: 0.25) = {
    let (x1, x2, xm) = if left(child) > left(parent) {
      (left(child), right(parent), left(child) - dx)
    } else {
      (right(child), left(parent), left(parent) - dx)
    }
    link((x1, y(child, fk)), (xm, y(child, fk)), (xm, y(parent, pk)), (x2, y(parent, pk)))
  }

  side("order_items", "product_id", "products", "product_id")
  side("order_items", "order_id", "orders", "order_id")
  side("payments", "order_id", "orders", "order_id")
  side("photos", "reviewer_id", "employees", "employee_id")
  side("relatives", "customer_id", "customers", "customer_id", dx: 0.35)
  side("photo_sessions", "unit_id", "military_units", "unit_id")
  side("soldiers", "unit_id", "military_units", "unit_id")

  link(
    (x("order_items", 0.6), bottom("order_items")),
    (x("order_items", 0.6), lane(0)),
    (
      x("photos", 2.0),
      lane(0),
    ),
    (x("photos", 2.0), top("photos")),
  )
  link(
    (x("orders", 0.5), bottom("orders")),
    (x("orders", 0.5), lane(0) + 0.2),
    (x("employees", 2.6), lane(0) + 0.2),
    (x("employees", 2.6), top("employees")),
  )
  link(
    (x("orders", 0.8), bottom("orders")),
    (x("orders", 0.8), lane(0) - 0.2),
    (x("employees", 2.9), lane(0) - 0.2),
    (x("employees", 2.9), top("employees")),
  )
  link((x("orders", 1.8), bottom("orders")), (x("customers", 1.8), top("customers")))
  link(
    (x("orders", 3.2), bottom("orders")),
    (x("orders", 3.2), lane(0)),
    (left("relatives") - 0.15, lane(0)),
    (left("relatives") - 0.15, lane(1)),
    (x("soldiers", 0.8), lane(1)),
    (x("soldiers", 0.8), top("soldiers")),
  )
  link((x("relatives", 1.8), bottom("relatives")), (x("soldiers", 1.8), top("soldiers")))

  link((x("photo_soldiers", 1.5), top("photo_soldiers")), (x("photos", 1.5), bottom("photos")))
  link(
    (x("photos", 3.0), bottom("photos")),
    (x("photos", 3.0), lane(1)),
    (x("photo_sessions", 0.6), lane(1)),
    (x("photo_sessions", 0.6), top("photo_sessions")),
  )
  link(
    (x("photo_sessions", 1.8), top("photo_sessions")),
    (x("employees", 1.8), bottom("employees")),
  )
  link(
    (x("photo_sessions", 3.0), top("photo_sessions")),
    (x("photo_sessions", 3.0), lane(1)),
    (x("customers", 1.8), lane(1)),
    (x("customers", 1.8), bottom("customers")),
  )
  link(
    (x("photo_soldiers", 1.8), bottom("photo_soldiers")),
    (x("photo_soldiers", 1.8), lane(2)),
    (x("soldiers", 1.8), lane(2)),
    (x("soldiers", 1.8), bottom("soldiers")),
  )
})

== Цель работы

Закрепить навыки проектирования и разработки реляционных баз данных, освоить средства Microsoft SQL
Server для создания и наполнения БД и создать основу для последующих лабораторных работ по
дисциплине.

== Задачи

+ Выбрать и согласовать с преподавателем предметную область для последующей разработки базы данных
  (БД).
+ Разработать схему БД для выбранной предметной области.
+ Создать БД в СУБД Microsoft SQL Server.
+ Заполнить БД с использованием средств языка Transact-SQL.
+ Выполнить простейшие запросы на выборку данных с помощью SQL-оператора `select`.
+ Выполнить SQL-запросы на модификацию, удаление записей из таблиц БД.

== Ход работы

=== Описание предметной области

В качестве предметной области выбрана деятельность ООО «Памятный кадр» — фотостудии, которая
проводит выездные фотосъёмки в воинских частях (принятие присяги, повседневная служба, дембельский
альбом) и изготавливает по их результатам фотокниги, отпечатки и портреты в рамках для
военнослужащих и их родственников. Кроме того, студия обслуживает гражданских клиентов: в салоне
можно заказать студийную или выездную фотосессию, печать снимков и фотокнигу.

В БД хранятся сведения:
- о воинских частях (условное наименование вида «в/ч 12345», место дислокации) и проходящих в них
  службу военнослужащих (личный номер, звание, даты призыва и увольнения в запас);
- о клиентах студии и их родственных связях с военнослужащими — заказывать снимки военнослужащего
  могут его родители, супруга или невеста, братья, сёстры, бабушки и дедушки;
- о сотрудниках студии шести категорий: директор, менеджер по заказам, фотограф,
  дизайнер-верстальщик, специалист по защите информации, бухгалтер;
- о фотосъёмках, сделанных на них снимках и запечатлённых военнослужащих;
- о товарах и услугах студии, заказах, их позициях и оплатах.

Военная специфика делает часть данных конфиденциальной: условные наименования и места дислокации
частей, персональные данные военнослужащих и непроверенные снимки. Снимок, сделанный на территории
части, может быть напечатан только после того, как специалист по защите информации убедится, что в
кадр не попали вооружение, техника и объекты охраны, и одобрит его. Результат проверки (статус,
проверяющий, дата, причина отказа) хранится вместе со снимком.

=== Схема БД

Схема БД представлена на рисунке~@fig-er. Стрелки направлены от внешнего ключа (FK) к первичному
ключу (PK) таблицы, на которую он ссылается; U обозначает уникальный столбец.

#figure(
  er-diagram,
  caption: [Схема БД «Памятный кадр»],
) <fig-er>

Назначение таблиц приведено в таблице~@tbl-tables.

#figure(
  {
    set text(size: 0.85em)
    set par(justify: false)
    table(
      columns: (auto, 1fr, auto, 1.3fr),
      align: left,
      table.header[*Имя таблицы*][*Назначение*][*Первичный ключ*][*Примечание*],
      `military_units`,
      [Хранит сведения о воинских частях],
      `unit_id`,
      [`designation` — условное наименование вида «в/ч 12345», `garrison` — место дислокации],

      `soldiers`,
      [Хранит сведения о военнослужащих],
      `soldier_id`,
      [`personal_number` — личный номер вида «АБ-123456», `call_up_date` и `discharge_date` — даты
        призыва и увольнения в запас],

      `customers`,
      [Хранит сведения о клиентах студии],
      `customer_id`,
      [Клиентами бывают как родственники военнослужащих, так и гражданские лица],

      `relatives`,
      [Реализует связь военнослужащих с их родственниками-клиентами],
      [(`soldier_id`, `customer_id`)],
      [`kinship` — степень родства],

      `employees`,
      [Хранит сведения о сотрудниках студии],
      `employee_id`,
      [`position` — одна из шести должностей, `login_name` — имя логина сотрудника на сервере БД],

      `photo_sessions`,
      [Хранит сведения о фотосъёмках],
      `session_id`,
      [Военная съёмка (`kind` — присяга, повседневная служба, дембельский альбом) ссылается на часть
        `unit_id`, гражданская — на клиента `customer_id`],

      `photos`,
      [Хранит сведения о снимках и результатах их проверки],
      `photo_id`,
      [`review_status` — статус проверки, `reviewer_id` — проверивший снимок специалист по защите
        информации],

      `photo_soldiers`,
      [Реализует связь снимков с запечатлёнными на них военнослужащими],
      [(`photo_id`, `soldier_id`)],
      [],

      `products`,
      [Хранит каталог товаров и услуг],
      `product_id`,
      [`is_available` — признак того, что позиция продаётся],

      `orders`,
      [Хранит сведения о заказах],
      `order_id`,
      [`soldier_id` — военнослужащий, для которого заказаны снимки (пусто для гражданского заказа),
        `manager_id` и `designer_id` — ответственные сотрудники, `total_amount` — сумма заказа],

      `order_items`,
      [Хранит позиции заказов],
      `order_item_id`,
      [`photo_id` — снимок для печати, `unit_price` — цена на момент оформления заказа],

      `payments`,
      [Хранит платежи по заказам],
      `payment_id`,
      [`method` — способ оплаты: наличные, карта или перевод],
    )
  },
  caption: [Таблицы БД],
) <tbl-tables>

Целостность данных обеспечивается декларативными ограничениями: первичными и внешними ключами,
ограничениями уникальности, значениями по умолчанию и ограничениями `check`. Последние задают
допустимые значения перечислимых столбцов (звание, должность, вид съёмки, статусы), формат личного
номера и условного наименования части, согласованность дат, а также правила внутри строки: военная
съёмка привязана к части и не имеет клиента, гражданская — наоборот; одобренный или отклонённый
снимок обязан иметь проверяющего и дату проверки; дата выдачи заказа указана тогда и только тогда,
когда заказ выдан. Правила, затрагивающие несколько таблиц (например, печать только одобренных
снимков), декларативными средствами не выражаются и будут реализованы триггерами в лабораторной
работе~№~5.

Позиции заказа удаляются вместе с заказом (`on delete cascade`), как и связи снимка с
военнослужащими. Остальные внешние ключи запрещают удаление строки, на которую есть ссылки.

=== Рабочее окружение

Вместо установленного локально SQL Server и SQL Server Management Studio используется SQL Server
2022 (редакция Developer) в контейнере Docker, а сценарии выполняются утилитой `sqlcmd`. Это делает
окружение воспроизводимым: БД в любой момент пересоздаётся с нуля одной командой, а вывод каждого
запроса сохраняется в файл и попадает в отчёт без ручного копирования. Контейнер описан в файле
`compose.yml`; каталог дисциплины монтируется в контейнер как `/work` только для чтения, чтобы
`sqlcmd` мог выполнять сценарии из него.

#code-file(read("../compose.yml"), name: "compose.yml")

Изменения структуры и данных БД оформляются как пронумерованные миграции
`migrations/NNN_название.sql`, общие для всех лабораторных работ: работе №~N принадлежат номера
N01–N99. Применение миграций и запуск запросов автоматизированы задачами исполнителя `bk` (baursak),
описанными на языке Lua в файле `baursak.lua`:
- `bk up` и `bk down` — запуск контейнера и его удаление вместе с данными;
- `bk migrate [N]` — применение ещё не применённых миграций с номерами до N включительно
  (`sqlcmd -b` прерывает выполнение на первой ошибке), применённые миграции фиксируются в таблице
  `master.dbo.schema_migrations`;
- `bk reset [N]` — пересоздание контейнера и применение миграций до N;
- `bk sql <сценарий | запрос> [файл]` — выполнение сценария или запроса в БД `pamyatny_kadr` с
  сохранением вывода в файл; ошибки не прерывают сценарий и попадают в вывод.

#code-file(read("../baursak.lua"), name: "baursak.lua")

Состояние БД после лабораторной работы №~1 получено командой `bk reset 199`, после чего каждый
запрос из каталога `queries` выполнен командой вида
`bk sql lab-1/queries/01-soldiers-of-unit.sql lab-1/output/01-soldiers-of-unit.txt`. Результаты
запросов в отчёте построены по этим файлам.

=== Создание БД

БД создаётся первой миграцией. Она же переключает сервер на русский язык сообщений:
`sp_configure 'default language', 21` задаёт язык по умолчанию для логинов, которые будут созданы
позже, а для уже существующего логина `sa` язык меняется явно. Для хранения кириллицы выбрано
упорядочение `Cyrillic_General_100_CI_AS`; все текстовые столбцы имеют тип `nvarchar`.

#code-file(
  read("../migrations/101_create_database.sql"),
  name: "migrations/101_create_database.sql",
)

Таблицы и ограничения создаются второй миграцией. Уникальность имени логина сотрудника задана
фильтруемым уникальным индексом: ограничение `unique` в SQL Server допускает лишь одно значение
`null`, а логин заводится не каждому сотруднику.

#code-file(read("../migrations/102_schema.sql"), name: "migrations/102_schema.sql")

=== Заполнение таблиц

Для заполнения таблиц использован следующий сценарий. В БД внесены четыре воинские части, 12
военнослужащих, 15 клиентов (12 родственников и трое гражданских), восемь сотрудников всех
категорий, восемь фотосъёмок с 21 снимком в разных статусах проверки, девять товаров и восемь
заказов с позициями и оплатами.

#code-file(read("../migrations/103_seed.sql"), name: "migrations/103_seed.sql")

=== Простейшая выборка записей

После первоначального заполнения таблиц выполнены следующие запросы на выборку. Первый выводит
список военнослужащих одной части.

#code-file(read("queries/01-soldiers-of-unit.sql"), name: "queries/01-soldiers-of-unit.sql")
#sql-output(read("output/01-soldiers-of-unit.txt"))

Следующий запрос формирует очередь снимков для специалиста по защите информации.

#code-file(read("queries/02-photos-on-review.sql"), name: "queries/02-photos-on-review.sql")
#sql-output(read("output/02-photos-on-review.txt"))

Менеджеру перед дембельским сезоном нужны контакты родственников тех, кто скоро увольняется в запас:
у Егорова и Николаева родственники не зарегистрированы, поэтому их в выборке нет.

#code-file(read("queries/03-soldier-relatives.sql"), name: "queries/03-soldier-relatives.sql")
#sql-output(read("output/03-soldier-relatives.txt"))

Запрос с группировкой подводит итоги работы фотографов. Снимки гражданских съёмок проверки не
требуют, поэтому сумма трёх последних столбцов может быть меньше числа снимков.

#code-file(
  read("queries/04-photographer-workload.sql"),
  name: "queries/04-photographer-workload.sql",
)
#sql-output(read("output/04-photographer-workload.txt"))

Последний запрос сопоставляет сумму каждого заказа с поступившими оплатами.

#code-file(read("queries/05-order-balance.sql"), name: "queries/05-order-balance.sql")
#sql-output(read("output/05-order-balance.txt"))

=== Модификация, удаление записей

После заполнения выполнено изменение и удаление данных по различным условиям с последующей выборкой,
показывающей результат. Сценарии выполнялись в приведённом порядке над одной и той же БД.

Специалист по защите информации проверяет снимки съёмки повседневной службы: два снимка одобряет,
один отклоняет с указанием причины. Попытка одобрить снимок, не указав проверяющего, отклоняется
ограничением `ck_photos_review`.

#code-file(read("queries/06-review-photos.sql"), name: "queries/06-review-photos.sql")
#sql-output(read("output/06-review-photos.txt"))

Цены на фотокниги повышаются на 10~%. Поскольку цена позиции копируется в `order_items` при
оформлении заказа, сумма уже принятых заказов не меняется.

#code-file(read("queries/07-raise-prices.sql"), name: "queries/07-raise-prices.sql")
#sql-output(read("output/07-raise-prices.txt"))

Отменённый заказ №~7 удаляется вместе со своей позицией благодаря каскадному удалению. Удалить
оплаченный заказ №~4 нельзя: на него ссылается платёж, и внешний ключ `fk_payments_orders` запрещает
операцию.

#code-file(read("queries/08-delete-order.sql"), name: "queries/08-delete-order.sql")
#sql-output(read("output/08-delete-order.txt"))

Аналогично внешний ключ `fk_soldiers_military_units` не позволяет удалить часть, в которой проходят
службу военнослужащие, тогда как часть без связанных записей удаляется. Последний запрос удаляет
клиента, который не сделал ни одного заказа и не связан с военнослужащими; предложение `output`
выводит удалённую строку.

#code-file(read("queries/09-delete-unit.sql"), name: "queries/09-delete-unit.sql")
#sql-output(read("output/09-delete-unit.txt"))

== Выводы

В ходе работы спроектирована и создана в Microsoft SQL Server реляционная БД фотостудии «Памятный
кадр» из 12 таблиц, а целостность данных обеспечена декларативными ограничениями. БД заполнена
сценарием на Transact-SQL, выполнены запросы на выборку, изменение и удаление данных; попытки
нарушить ограничения `check` и внешних ключей отклонены сервером. Окружение на основе Docker и
миграций позволяет воспроизвести состояние БД одной командой и служит основой для следующих
лабораторных работ, в которых для сотрудников студии будут настроены роли и права доступа,
шифрование конфиденциальных данных, электронная подпись и триггерные правила целостности.
