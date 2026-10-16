#strong[ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА]

#strong[Федеральное государственное бюджетное образовательное учреждение
высшего образования]

#strong[«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ
Императора Александра I»]

Кафедра «ИНФОРМАЦИОННЫЕ И ВЫЧИСЛИТЕЛЬНЫЕ СИСТЕМЫ»

Дисциплина «Базы данных и управление данными»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № #strong[3]]

#strong[«]Изучение языка запросов SQL (часть 2)#strong[»]

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

Разработать набор запросов к схеме базы данных, созданной в ЛР2. Запросы
должны демонстрировать применение следующих возможностей SQL:

+ Выборка данных из нескольких таблиц

- - декартово произведение

  - соединения таблиц

    - эквисоединение
    - естественное соединение
    - внутреннее соединение
    - внешние соединения (LEFT \[OUTER\] JOIN, RIGHT \[OUTER\] JOIN,
      FULL \[OUTER\] JOIN)
    - соединение более двух таблиц

  - соединение таблицы с той же таблицей

+ объединение результатов выборок

- - - UNION и UNION ALL
  - - INTERSECT и INTERSECT ALL
  - - EXCEPT и EXCEPT ALL

+ Подзапросы

- - - подзапросы в предложении FROM, HAVING
  - - коррелированные подзапросы
  - - запросы в WITH
  - - использование операторов EXISTS, ANY, SOME, ALL

#strong[]

#strong[Разработка базы данных:]

CREATE TABLE IF NOT EXISTS Customers ( \ id INTEGER NOT NULL PRIMARY
KEY, \ name TEXT NOT NULL, \ surname TEXT NOT NULL, \ address TEXT NOT
NULL, \ phone TEXT NOT NULL \ ); \ \ CREATE TABLE IF NOT EXISTS
BookOrders ( \ id INTEGER NOT NULL PRIMARY KEY, \ customerId INTEGER NOT
NULL, \ datetime TEXT NOT NULL, \ cost REAL NOT NULL, \ numberOfTurns
INTEGER NOT NULL, \ sizeId INTEGER NOT NULL, \ materialId INTEGER NOT
NULL, \ FOREIGN KEY(customerId) REFERENCES Customers(id), \ FOREIGN
KEY(materialId) REFERENCES Materials(id), \ FOREIGN KEY(sizeId)
REFERENCES Sizes(id) \ ); \ \ CREATE TABLE IF NOT EXISTS PaintingOrders
( \ id INTEGER NOT NULL PRIMARY KEY, \ customerId INTEGER NOT NULL, \
datetime TEXT NOT NULL, \ cost REAL NOT NULL, \ width INTEGER NOT NULL,
\ height INTEGET NOT NULL, \ FOREIGN KEY(customerId) REFERENCES
Customers(id) \ ); \ \ CREATE TABLE IF NOT EXISTS Materials ( \ id
INTEGER NOT NULL PRIMARY KEY, \ name TEXT NOT NULL, \ description TEXT
NOT NULL, \ price REAL NOT NULL, \ stock REAL NOT NULL \ ); \ \ CREATE
TABLE IF NOT EXISTS Sizes ( \ id INTEGER NOT NULL PRIMARY KEY, \ name
TEXT NOT NULL \ ); \ \ CREATE VIEW MaterialStockView AS \ SELECT id,
name, stock FROM Materials \ ORDER BY stock DESC;

#strong[]

#strong[Разработка SQL-запросов данных:]

#strong[Декартово произведение:] \ SELECT \* FROM Materials, Sizes

#box(image("./assets/10000001000002BB000001718EA3FF3F.png", height: 3.1764in, width: 6.0181in))

#strong[Эквисоединение:] \ SELECT \* FROM Customers INNER JOIN
BookOrders ON Customers.id =
#box(image("./assets/1000000100000427000001B9CDDA5E81.png", height: 2.4965in, width: 6.0181in))BookOrders.customerId

\ #strong[Естественное соединение:] \ SELECT \* FROM Customers NATURAL
JOIN BookOrders

#box(image("./assets/1000000100000427000001B982316B19.png", height: 2.4965in, width: 6.0181in))
\ #strong[Внутреннее соединение:] \ SELECT \* FROM Customers JOIN
BookOrders ON Customers.id = BookOrders.customerId

#box(image("./assets/1000000100000427000001B99D911D71.png", height: 2.4965in, width: 6.0181in))
\ #strong[Внешние соединения:] \ SELECT \* FROM Customers LEFT JOIN
BookOrders ON Customers.id = BookOrders.customerId

#box(image("./assets/100000010000042F0000021F2486B715.png", height: 2.852in, width: 5.6252in))
SELECT \* FROM Customers RIGHT JOIN BookOrders ON Customers.id =
BookOrders.customerId

#box(image("./assets/100000010000042F000001AB63EB5155.png", height: 2.3992in, width: 6.0181in))

SELECT \* FROM Customers FULL JOIN BookOrders ON Customers.id =
BookOrders.customerId;

#box(image("./assets/100000010000042F0000021B2A7A714C.png", height: 3.0283in, width: 6.0181in))

#strong[#strong[Соединение более двух таблиц: \ SELECT \
BookOrders.cost, \ BookOrders.datetime, \ Materials.name, \ Sizes.name \
FROM BookOrders \ JOIN Materials ON Materials.id = BookOrders.materialId
\ JOIN Sizes ON Sizes.id = BookOrders.sizeId;]]

#box(image("./assets/10000001000001C5000001AB00B42786.png", height: 4.448in, width: 4.7189in))

#strong[#strong[Соединение таблицы с той же таблицей: \ SELECT s1.name,
s2.name FROM Sizes s1, Sizes s2 WHERE s1.id \<\> s2.id;]]

#box(image("./assets/10000001000000D90000017B96E120C0.png", height: 3.948in, width: 2.2602in))

#strong[#strong[UNION]]

SELECT customerId, cost, datetime FROM BookOrders \ UNION \ SELECT
customerId, cost, datetime FROM PaintingOrders

#box(image("./assets/1000000100000143000002DB11BE94A4.png", height: 4.9252in, width: 2.1764in))

#strong[#strong[INTERSECT: \ SELECT customerId FROM BookOrders \
INTERSECT \ SELECT customerId FROM PaintingOrders]]

#strong[#box(image("./assets/1000000100000083000000C94D6A42C6.png", height: 2.0937in, width: 1.3646in))#strong[]]

#strong[#strong[EXCEPT: \ SELECT customerId FROM BookOrders \ EXCEPT \
SELECT customerId FROM PaintingOrders]]

#strong[#strong[Подзапросы в предложении FROM, HAVING: \ SELECT sizeId,
sum(cost) FROM BookOrders \ GROUP BY BookOrders.materialId \ HAVING
COUNT(\*) \>= 2]]

#box(image("./assets/10000001000000BB00000071F9AF6707.png", height: 1.1772in, width: 1.948in))

#strong[#strong[Коррелированные подзапросы: \ SELECT \* FROM Customers c
WHERE EXISTS (SELECT 1 FROM BookOrders b WHERE b.customerId = c.id)]]

#box(image("./assets/10000001000001F3000001356F8C3A25.png", height: 3.2189in, width: 5.198in))

#strong[#strong[Запросы в WITH: \ WITH CustomerOrders AS ( \ SELECT \*
FROM Customers JOIN BookOrders ON Customers.id = BookOrders.customerId \
) \ SELECT name, surname, cost, datetime FROM CustomerOrders;]]

#box(image("./assets/10000001000001B1000001A7532255AC.png", height: 4.4063in, width: 4.5102in))

#strong[#strong[Использование операторов EXISTS, ANY, SOME, ALL:]]

#strong[#strong[EXISTS:]]

SELECT \* FROM Customers c WHERE EXISTS (SELECT 1 FROM BookOrders b
WHERE b.customerId = c.id)

#box(image("./assets/10000001000001F1000001397DE84DD0.png", height: 3.2602in, width: 5.1772in))

#strong[#strong[ANY:]]

SELECT \* FROM Customers \ WHERE id IN (SELECT customerId FROM
BookOrders);

#box(image("./assets/10000001000001F1000001397DE84DD0.png", height: 3.2602in, width: 5.1772in))

#strong[#strong[ALL:]]

SELECT \* FROM BookOrders \ WHERE cost \> (SELECT MAX(cost) FROM
PaintingOrders)

#box(image("./assets/100000010000026300000171C9263097.png", height: 3.6339in, width: 6.0181in))

#strong[#strong[SOME:]]

SELECT \* FROM PaintingOrders \ where cost \> (SELECT MIN(cost) FROM
BookOrders)

#box(image("./assets/10000001000001C1000000ADBDE206DD.png", height: 1.802in, width: 4.6772in))

Оценочный лист результатов ЛР №3

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
