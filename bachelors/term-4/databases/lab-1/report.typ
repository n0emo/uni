#strong[ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА]

#strong[Федеральное государственное бюджетное образовательное учреждение
высшего образования]

#strong[«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ
Императора Александра I»]

Кафедра «ИНФОРМАЦИОННЫЕ И ВЫЧИСЛИТЕЛЬНЫЕ СИСТЕМЫ»

Дисциплина «Базы данных и управление данными»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № 1]

#strong[«]Разработка и наполнение схем баз данных#strong[»]

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    [Выполнил студент

    Факультет: АИТ

    Группа: ИВБ-211

    ], [Шефнер А.],
    [Проверил: проф.], [Хомоненко А. Д.],
  )]
  , kind: table
  )

#strong[Санкт-Петербург]

#quote(block: true)[
#strong[2024]
]

#strong[Задание]:

Выберите предметную область и процесс, для автоматизации которого будет
разрабатываться база данных. Для выбранного процесса разработайте
ER-модель и для неё напишите набор SQL-команд для создания и наполнения
базы данных.

Требования к сложности разрабатываемой схемы:

- не меньше 4 entity-таблиц
- минимум одно отношение \"многие-ко-многим\"
- использование типа данных timestamp для описания процесса

Отчёт по лабораторной работе должен содержать:

- краткое описание предметной области и моделируемого бизнес-процесса;
- ER-диаграмму схемы БД;
- DDL-команды создания и удаления объектов схемы.
- DML-команды заполнения, модификации и удаления данных из полученной
  базы.

#strong[Описание моделируемого процесса:]

В данной модели представлены процессы взаимодействия клиентов и их
заказов в магазине полиграфии. Клиент может заказать фотокнигу или
картину. Фотокниги могут быть выполнены из разных материалов. Так же
каждый заказ имеет свои размеры и стоимость.

#strong[ER-диаграмма:]

#box(image("./assets/100DAE190000375300004BF776CCA6FA.svg", height: 7.6563in, width: 5.5756in))#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[Разработка базы данных:]

Для работы с базой данных был выбран модуль sqlite3 языка
программирования Python. Ниже представлена функция для создания базы
данных.

def create\_tables() -\> None:

with get\_connection() as conn:

cur = conn.cursor()

sql = \"\"\"

CREATE TABLE IF NOT EXISTS Customers (

id INTEGER NOT NULL PRIMARY KEY,

name TEXT NOT NULL,

surname TEXT NOT NULL,

address TEXT NOT NULL,

phone TEXT NOT NULL

);

CREATE TABLE IF NOT EXISTS BookOrders (

id INTEGER NOT NULL PRIMARY KEY,

customerId INTEGER NOT NULL,

datetime TEXT NOT NULL,

cost REAL NOT NULL,

numberOfTurns INTEGER NOT NULL,

size TEXT NOT NULL,

materialId INTEGER NOT NULL,

FOREIGN KEY(customerId) REFERENCES Customers(id),

FOREIGN KEY(materialId) REFERENCES Materials(id)

);

CREATE TABLE IF NOT EXISTS PaintingOrders (

id INTEGER NOT NULL PRIMARY KEY,

customerId INTEGER NOT NULL,

datetime TEXT NOT NULL,

cost REAL NOT NULL,

width INTEGER NOT NULL,

height INTEGET NOT NULL,

FOREIGN KEY(customerId) REFERENCES Customers(id)

);

CREATE TABLE IF NOT EXISTS Materials (

id INTEGER NOT NULL PRIMARY KEY,

name TEXT NOT NULL,

description TEXT NOT NULL,

price REAL NOT NULL,

stock REAL NOT NULL

);

\"\"\"

cur.executescript(sql)

#strong[Заполнение таблиц: ]

Для добавления записей в базу данных реализованы следующие функции:

def add\_customer(customer: Customer) -\> None:

with get\_connection() as conn:

cur = conn.cursor()

sql = \"\"\"

INSERT INTO Customers

\(name, surname, address, phone)

VALUES (?, ?, ?, ?)

\"\"\"

cur.execute( sql, (customer.name, customer.surname, customer.address,
customer.phone))

def add\_material(material: Material) -\> None:

with get\_connection() as conn:

cur = conn.cursor()

sql = \"\"\"

INSERT INTO Materials

\(name, description, price, stock)

VALUES(?, ?, ?, ?)

\"\"\"

cur.execute(sql, (material.name, material.description, material.price,
material.stock))

def add\_book\_order(order: BookOrder) -\> None:

with get\_connection() as conn:

cur = conn.cursor()

sql = \"\"\"

INSERT INTO BookOrders

\(customerId, datetime, cost, numberOfTurns, size, materialId)

VALUES (?, ?, ?, ?, ?, ?)

\"\"\"

cur.execute(sql, (order.customer\_id, order.datetime, order.cost,
order.number\_of\_turns, order.size, order.materialId))

def add\_painting\_order(order: PaintingOrder) -\> None:

with get\_connection() as conn:

cur = conn.cursor()

sql = \"\"\"

INSERT INTO PaintingOrders

\(customerId, datetime, cost, width, height)

VALUES (?, ?, ?, ?, ?)

\"\"\"

cur.execute(sql, (order.customer\_id, order.datetime, order.cost,
order.width, order.height))

Далее скрипт, который наполняет таблицу данными, используя
вышеприведённые функции:

customers = \[

Customer(\"Виталий\", \"Петров\", \"ул. Пушкина, д. 22\",
\"88005553535\"),

Customer(\"Андрей\", \"Штефанов\", \"ул. Привокзальная, д. 12\",
\"89811213123\"),

Customer(\"Родион\", \"Базаров\", \"пр. Меньшевиков, д. 143\",
\"89814744747\"),

Customer(\"Светлана\", \"Владимирова\", \"ул. Крутая, д. 121\",
\"88001239098\"),

Customer(\"Мёске\", \"Кобарёв\", \"ул. Японская, д. 211\",
\"88005758495\"),

Customer(\"Аристарх\", \"Попов\", \"пр. Энергетиков, д. 32\",
\"88005767384\"),

\]

materials = \[

Material(\"Крокодил\", \"Зелёная крокодилья кожа\", 120, 24.6),

Material(\"Кожа\", \"Обычная коричневая кожа\", 60, 36.1),

Material(\"Картон\", \"Печатный картон средней плотности\", 23, 67),

Material(\"Пластик\", \"Эксперементальный прочный пластик\", 100, 3.4),

\]

book\_orders = \[

BookOrder(3, 3500, 12, \"Большой\", 1, \"2024-01-06 12:40:21\"),

BookOrder(1, 1400, 4, \"Маленький\", 2, \"2024-01-08 16:12:55\"),

BookOrder(4, 8000, 120, \"Большой\", 2, \"2024-01-09 13:00:43\"),

BookOrder(6, 6700, 18, \"Средний\", 4, \"2024-01-09 13:43:26\"),

\]

painting\_orders = \[

PaintingOrder(4, 1500, 240, 127, \"2024-01-09 13:00:43\"),

PaintingOrder(2, 1800, 220, 140, \"2024-01-10 13:12:31\"),

PaintingOrder(5, 1000, 160, 100, \"2024-01-10 14:40:61\"),

\]

for customer in customers:

db.add\_customer(customer)

for material in materials:

db.add\_material(material)

for order in book\_orders:

db.add\_book\_order(order)

for order in painting\_orders:

db.add\_painting\_order(order)

#strong[Изменения в таблицах:]

Пример функции для обновления количества материала на складе:

def update\_material\_stock(name: str, new\_stock: float) -\> None:

with get\_connection() as conn:

cur = conn.cursor()

sql = \"UPDATE Materials SET stock = ? WHERE name = ?\"

cur.execute(sql, \[new\_stock, name\])

Пример функции для удаления информации о клиенте:

def remove\_customer\_by\_id(id: int) -\> None:

with get\_connection() as conn:

cur = conn.cursor()

sql = \"DELETE FROM Customers WHERE id = ?\"

cur.execute(sql, \[id\])

#strong[Результаты заполнения:]

#box(image("./assets/10000000000001E300000113EDD3EBD5.png", height: 2.2209in, width: 3.9008in))

#box(image("./assets/1000000000000246000000DC5492732B.png", height: 1.8256in, width: 4.8307in))

#box(image("./assets/10000000000001D1000000E257472EAC.png", height: 1.7429in, width: 3.5866in))#box(image("./assets/10000000000001CA000000D9FB4E148D.png", height: 1.7429in, width: 3.6791in))

Оценочный лист результатов ЛР №1

Ф.И.О. студента: Шефнер Альберт

Группа: ИВБ-211

#figure(
  align(center)[#table(
    columns: 6,
    align: (auto,auto,auto,auto,auto,auto,),
    [№

    п/п

    ], [Материалы необходимые для оценки знаний, умений

    и навыков

    ], [Показатель

    оценивания

    ], [Критерии

    Оценивания

    ], [Шкала оценивания], [],
    table.cell(rowspan: 11)[1], table.cell(rowspan: 11)[Лабораторная
    работа №], table.cell(rowspan: 2)[Наличие
    заготовки], [Присутствует], [1], [],
    [Отсутствует], [0], [],
    table.cell(rowspan: 3)[Правильность ответов на вопрос], [Получены
    правильные ответы на вопросы], [4], [],
    [Получены частично правильные ответы], [2,5], [],
    [Получены неправильные ответы], [0], [],
    table.cell(rowspan: 2)[Соответствие методике
    выполнения], [Соответствует], [2,5], [],
    [Не соответствует], [1,5], [],
    table.cell(rowspan: 3)[Срок выполнения работы], [Работа выполнена в
    срок], [2,5], [],
    [Работа выполнена с опозданием на 1 неделю], [1,5], [],
    [Работа выполнена с опозданием на 2 недели и более], [1,0], [],
    table.cell(colspan: 2)[Итого максимальное количество баллов за
    лабораторную работу №], [10], [],
  )]
  , kind: table
  )

Хомоненко А. Д.

«\_\_\_»\_\_\_\_\_\_\_\_\_\_2024 г.
