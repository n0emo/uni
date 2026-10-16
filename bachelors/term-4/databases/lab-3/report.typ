#import "../common.typ": *

#show: report.with(number: "3", title: "Изучение языка запросов SQL (часть 2)")

== Задание

Разработать набор запросов к схеме базы данных, созданной в ЛР2. Запросы должны демонстрировать
применение следующих возможностей SQL:

+ Выборка данных из нескольких таблиц
  - декартово произведение
  - соединения таблиц
    - эквисоединение
    - естественное соединение
    - внутреннее соединение
    - внешние соединения (LEFT \[OUTER\] JOIN, RIGHT \[OUTER\] JOIN, FULL \[OUTER\] JOIN)
    - соединение более двух таблиц
  - соединение таблицы с той же таблицей
+ объединение результатов выборок
  - UNION и UNION ALL
  - INTERSECT и INTERSECT ALL
  - EXCEPT и EXCEPT ALL
+ Подзапросы
  - подзапросы в предложении FROM, HAVING
  - коррелированные подзапросы
  - запросы в WITH
  - использование операторов EXISTS, ANY, SOME, ALL

== Разработка базы данных

#code-file(read("../app/sql/create.sql"), name: "create.sql")

== Разработка SQL-запросов данных

=== Декартово произведение

```sql
SELECT * FROM Materials, Sizes
```

#figure(
  caption: "Результат запроса декартова произведения",
  image("./assets/cartesian-product.png", width: 100%),
)

=== Эквисоединение

```sql
SELECT * FROM Customers INNER JOIN BookOrders ON Customers.id = BookOrders.customerId
```

#figure(
  caption: "Результат запроса эквисоединения",
  image("./assets/equi-join.png", width: 100%),
)

=== Естественное соединение

```sql
SELECT * FROM Customers NATURAL JOIN BookOrders
```

#figure(
  caption: "Результат запроса естественного соединения",
  image("./assets/natural-join.png", width: 100%),
)

=== Внутреннее соединение

```sql
SELECT * FROM Customers JOIN BookOrders ON Customers.id = BookOrders.customerId
```

#figure(
  caption: "Результат запроса внутреннего соединения",
  image("./assets/inner-join.png", width: 100%),
)

=== Внешние соединения

```sql
SELECT * FROM Customers LEFT JOIN BookOrders ON Customers.id = BookOrders.customerId
```

#figure(
  caption: "Результат запроса LEFT JOIN",
  image("./assets/left-join.png", width: 93%),
)

```sql
SELECT * FROM Customers RIGHT JOIN BookOrders ON Customers.id = BookOrders.customerId
```

#figure(
  caption: "Результат запроса RIGHT JOIN",
  image("./assets/right-join.png", width: 100%),
)

```sql
SELECT * FROM Customers FULL JOIN BookOrders ON Customers.id = BookOrders.customerId;
```

#figure(
  caption: "Результат запроса FULL JOIN",
  image("./assets/full-join.png", width: 100%),
)

=== Соединение более двух таблиц

```sql
SELECT
  BookOrders.cost,
  BookOrders.datetime,
  Materials.name,
  Sizes.name
FROM BookOrders
JOIN Materials ON Materials.id = BookOrders.materialId
JOIN Sizes ON Sizes.id = BookOrders.sizeId;
```

#figure(
  caption: "Результат запроса соединения трёх таблиц",
  image("./assets/join-three-tables.png", width: 78%),
)

=== Соединение таблицы с той же таблицей

```sql
SELECT s1.name, s2.name FROM Sizes s1, Sizes s2 WHERE s1.id <> s2.id;
```

#figure(
  caption: "Результат запроса соединения таблицы с самой собой",
  image("./assets/self-join.png", width: 38%),
)

=== UNION

```sql
SELECT customerId, cost, datetime FROM BookOrders
UNION
SELECT customerId, cost, datetime FROM PaintingOrders
```

#figure(
  caption: "Результат запроса UNION",
  image("./assets/union.png", width: 36%),
)

=== INTERSECT

```sql
SELECT customerId FROM BookOrders
INTERSECT
SELECT customerId FROM PaintingOrders
```

#figure(
  caption: "Результат запроса INTERSECT",
  image("./assets/intersect.png", width: 23%),
)

=== EXCEPT

```sql
SELECT customerId FROM BookOrders
EXCEPT
SELECT customerId FROM PaintingOrders
```

=== Подзапросы в предложении FROM, HAVING

```sql
SELECT sizeId, sum(cost) FROM BookOrders
GROUP BY BookOrders.materialId
HAVING COUNT(*) >= 2
```

#figure(
  caption: "Результат запроса с предложением HAVING",
  image("./assets/having.png", width: 32%),
)

=== Коррелированные подзапросы

```sql
SELECT * FROM Customers c
WHERE EXISTS (SELECT 1 FROM BookOrders b WHERE b.customerId = c.id)
```

#figure(
  caption: "Результат коррелированного подзапроса",
  image("./assets/correlated-subquery.png", width: 86%),
)

=== Запросы в WITH

```sql
WITH CustomerOrders AS (
  SELECT * FROM Customers JOIN BookOrders ON Customers.id = BookOrders.customerId
)
SELECT name, surname, cost, datetime FROM CustomerOrders;
```

#figure(
  caption: "Результат запроса с WITH",
  image("./assets/with.png", width: 75%),
)

=== Использование операторов EXISTS, ANY, SOME, ALL

==== EXISTS

```sql
SELECT * FROM Customers c
WHERE EXISTS (SELECT 1 FROM BookOrders b WHERE b.customerId = c.id)
```

#figure(
  caption: "Результат запроса с EXISTS",
  image("./assets/exists.png", width: 86%),
)

==== ANY

```sql
SELECT * FROM Customers
WHERE id IN (SELECT customerId FROM BookOrders);
```

#figure(
  caption: "Результат запроса с ANY",
  image("./assets/exists.png", width: 86%),
)

==== ALL

```sql
SELECT * FROM BookOrders
WHERE cost > (SELECT MAX(cost) FROM PaintingOrders)
```

#figure(
  caption: "Результат запроса с ALL",
  image("./assets/all.png", width: 100%),
)

==== SOME

```sql
SELECT * FROM PaintingOrders
where cost > (SELECT MIN(cost) FROM BookOrders)
```

#figure(
  caption: "Результат запроса с SOME",
  image("./assets/some.png", width: 78%),
)
