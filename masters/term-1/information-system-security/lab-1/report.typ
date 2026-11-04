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

= Цель работы

Освоить создание и заполнение реляционной БД в Microsoft SQL Server. Разработать базу данных для
последующих лабораторных работ.

= Задачи

+ Выбрать предметную область и разработать схему БД.
+ Создать и заполнить БД средствами Transact-SQL.
+ Выполнить запросы на выборку, изменение и удаление данных.

= Ход работы

== Описание предметной области

Для разработки БД выбрана фотостудия ООО «Памятный кадр». Студия проводит съёмки в воинских частях и
изготавливает фотокниги, отпечатки и портреты для военнослужащих и их родственников. Гражданским
клиентам доступны студийные и выездные съёмки, печать снимков и фотокниг.

В БД хранятся сведения:
- о воинских частях (условное наименование вида «в/ч 12345», место дислокации) и проходящих в них
  службу военнослужащих (личный номер, звание, даты призыва и увольнения в запас);
- о клиентах студии и их родственных связях с военнослужащими — заказывать снимки военнослужащего
  могут его родители, супруга или невеста, братья, сёстры, бабушки и дедушки;
- о сотрудниках студии шести категорий: директор, менеджер по заказам, фотограф,
  дизайнер-верстальщик, специалист по защите информации, бухгалтер;
- о фотосъёмках, сделанных на них снимках и запечатлённых военнослужащих;
- о товарах и услугах студии, заказах, их позициях и оплатах.

Доступ к местам дислокации частей, персональным данным военнослужащих и непроверенным снимкам должен
быть ограничен. Перед печатью снимков из воинских частей специалист по защите информации проверяет,
что в кадр не попали вооружение, техника и объекты охраны. Статус проверки, сотрудник, дата и
причина отказа хранятся вместе со снимком.

== Схема БД

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

Целостность данных поддерживают первичные и внешние ключи, ограничения уникальности и `check`.
Значения по умолчанию задают начальное состояние записей. Ограничения `check` проверяют допустимые
звания, должности, виды съёмок и статусы, формат личного номера и наименования части, а также даты.

Связанные поля одной строки проверяются совместно. Военная съёмка относится к части, гражданская — к
клиенту. У проверенного снимка должны быть указаны сотрудник и дата проверки, у выданного заказа —
дата выдачи. Правила, затрагивающие несколько таблиц, будут реализованы в лабораторной работе №~5.

При удалении заказа каскадно удаляются его позиции, при удалении снимка — отметки военнослужащих.
Остальные внешние ключи запрещают удаление записей, на которые есть ссылки.

== Рабочее окружение

Для работы используется SQL Server 2022 Developer в контейнере Docker. Запросы выполняются утилитой
`sqlcmd`, результаты сохраняются в текстовые файлы и включаются в отчёт. Конфигурация контейнера
приведена в файле `compose.yml`. Каталог дисциплины доступен в контейнере по пути `/work` только для
чтения.

#code-file(read("../compose.yml"), name: "compose.yml")

Изменения БД оформлены миграциями `migrations/NNN_название.sql`. Лабораторной работе №~N
соответствуют номера N01–N99. Для запуска контейнера, применения миграций и выполнения запросов
используется `bk` (baursak). Задачи определены в файле `baursak.lua`:
- `bk up`, `bk down` — запуск контейнера и его удаление вместе с данными;
- `bk migrate [N]` — применение миграций до номера N включительно. Применённые миграции записываются
  в `master.dbo.schema_migrations`, ошибка прерывает выполнение;
- `bk reset [N]` — пересоздание контейнера и применение миграций до N;
- `bk sql <сценарий | запрос> [файл]` — выполнение SQL с сохранением результата и сообщений об
  ошибках. Ошибка отдельного запроса не прерывает сценарий.

#code-file(read("../baursak.lua"), name: "baursak.lua")

БД подготовлена командой `bk reset 199`. Запросы выполнены командами вида
`bk sql lab-1/queries/01-soldiers-of-unit.sql lab-1/output/01-soldiers-of-unit.txt`. В отчёте
приведены сохранённые результаты этих запросов.

== Создание БД

Миграция 101 создаёт БД `pamyatny_kadr` с упорядочением `Cyrillic_General_100_CI_AS`. Для текстовых
столбцов используется тип `nvarchar`. Русский язык сообщений задаётся параметром `default language`,
для существующего логина `sa` — отдельной командой `alter login`.

#code-file(
  read("../migrations/101_create_database.sql"),
  name: "migrations/101_create_database.sql",
)

Миграция 102 создаёт таблицы и ограничения. Для `employees.login_name` используется фильтруемый
уникальный индекс: он допускает несколько строк без логина и проверяет уникальность заполненных
значений.

#code-file(read("../migrations/102_schema.sql"), name: "migrations/102_schema.sql")

== Заполнение таблиц

Миграция 103 заполняет БД учебными данными: четыре воинские части, 12 военнослужащих, 15 клиентов,
восемь сотрудников, восемь съёмок и 21 снимок. В каталог внесены девять товаров, оформлены восемь
заказов с позициями и платежами.

#code-file(read("../migrations/103_seed.sql"), name: "migrations/103_seed.sql")

== Простейшая выборка записей

Первый запрос выводит военнослужащих выбранной части.

#code-file(read("queries/01-soldiers-of-unit.sql"), name: "queries/01-soldiers-of-unit.sql")
#sql-output(read("output/01-soldiers-of-unit.txt"))

Следующий запрос выводит снимки, ожидающие проверки специалистом по защите информации.

#code-file(read("queries/02-photos-on-review.sql"), name: "queries/02-photos-on-review.sql")
#sql-output(read("output/02-photos-on-review.txt"))

Для связи с родственниками составлена выборка контактов военнослужащих, увольняющихся до конца 2026
года. В неё входят только военнослужащие с зарегистрированными родственниками. Егоров и Николаев
увольняются в 2027 году и не проходят отбор по дате.

#code-file(read("queries/03-soldier-relatives.sql"), name: "queries/03-soldier-relatives.sql")
#sql-output(read("output/03-soldier-relatives.txt"))

Группировка по фотографам позволяет получить число съёмок и снимков в каждом статусе. Гражданским
снимкам проверка не требуется, поэтому они учитываются только в общем числе снимков.

#code-file(
  read("queries/04-photographer-workload.sql"),
  name: "queries/04-photographer-workload.sql",
)
#sql-output(read("output/04-photographer-workload.txt"))

Для каждого заказа рассчитан остаток к оплате.

#code-file(read("queries/05-order-balance.sql"), name: "queries/05-order-balance.sql")
#sql-output(read("output/05-order-balance.txt"))

== Модификация, удаление записей

Запросы на изменение и удаление выполнены последовательно в одной БД. После каждой операции сделана
контрольная выборка.

Специалист по защите информации одобряет два снимка и отклоняет один с указанием причины. Одобрение
без указания проверяющего отклоняется ограничением `ck_photos_review`.

#code-file(read("queries/06-review-photos.sql"), name: "queries/06-review-photos.sql")
#sql-output(read("output/06-review-photos.txt"))

Цены фотокниг пересчитаны с повышением на 10~% и округлением до 100 рублей. Цены в уже оформленных
позициях заказа сохранены в `order_items` и от изменения прайса не зависят.

#code-file(read("queries/07-raise-prices.sql"), name: "queries/07-raise-prices.sql")
#sql-output(read("output/07-raise-prices.txt"))

Отменённый заказ №~7 удалён вместе с позицией. Удаление оплаченного заказа №~4 отклонено внешним
ключом `fk_payments_orders`: в таблице платежей осталась ссылка на заказ.

#code-file(read("queries/08-delete-order.sql"), name: "queries/08-delete-order.sql")
#sql-output(read("output/08-delete-order.txt"))

Внешний ключ `fk_soldiers_military_units` запрещает удаление части с военнослужащими. Часть без
связанных записей удаляется успешно. Также удалён клиент без заказов и родственных связей;
предложение `output` возвращает удалённую запись.

#code-file(read("queries/09-delete-unit.sql"), name: "queries/09-delete-unit.sql")
#sql-output(read("output/09-delete-unit.txt"))

#block(breakable: false)[
  = Выводы

  В ходе работы была разработана БД фотостудии «Памятный кадр» из 12 таблиц. Созданы ключи и
  ограничения целостности, таблицы заполнены учебными данными. Выполнены запросы на выборку,
  изменение и удаление записей. Проверка показала, что сервер отклоняет операции, нарушающие
  ограничения `check` и внешних ключей. Созданная БД используется в следующих лабораторных работах.
]
