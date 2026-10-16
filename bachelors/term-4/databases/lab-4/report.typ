#import "../common.typ": *

#show: report.with(number: "4", title: "Разработка хранимых процедур на языке PL/pgSQL")

== Задание

+ Основные элементы языка PL/pgSQL
  - анонимные блоки кода
  - объявления переменных и основные типы данных
  - организация циклов, итерационные структуры управления
  - курсоры: объявление и управление выборкой данных
+ Процедуры и функции
+ Триггерные процедуры
  - DML-триггеры
  - DDL-триггеры

== Основные элементы языка

=== Анонимный блок кода

```sql
DO $$
BEGIN
  RAISE NOTICE 'Hello, World!';
END
$$
```

Вывод:

#figure(
  caption: "Вывод анонимного блока кода",
  image("./assets/hello-world-output.png", width: 60%),
)

=== Объявления переменных и основные типы данных

```sql
DO $$
DECLARE
  num INTEGER := 15;
  txt VARCHAR;
  rw RECORD;
BEGIN
  num := num + 54;
  txt = 'Number is';
  RAISE NOTICE '%: %', txt, num;
  SELECT * FROM Customers LIMIT 1
  INTO rw;
  RAISE NOTICE 'First customer: %', rw;
END
$$
```

Вывод:

#figure(
  caption: "Вывод блока с переменными",
  image("./assets/variables-output.png", width: 80%),
)

=== Организация циклов, итерационные структуры управления

Цикл FOR:

```sql
DO $$
DECLARE
  sum INTEGER := 0;
  book RECORD;
  min_number_of_turns constant INTEGER := 20;
BEGIN
  FOR book IN
    SELECT cost, number_of_turns FROM book_orders
  LOOP
    IF book.number_of_turns >= min_number_of_turns THEN
      sum := sum + book.cost;
    END IF;
  END LOOP;
  RAISE NOTICE 'Total cost of books having namber of turns >= %: %',
    min_number_of_turns, sum;
END
$$
```

Вывод:

#figure(
  caption: "Вывод цикла FOR",
  image("./assets/for-loop-output.png", width: 80%),
)

Цикл WHILE:

```sql
DO $$
DECLARE
  argument integer := 10;
  current_mult integer := 1;
  factorial integer := 1;
BEGIN
  WHILE current_mult <= argument LOOP
    factorial := factorial * current_mult;
    current_mult := current_mult + 1;
  END LOOP;
  RAISE NOTICE 'Factorial of % is %', argument, factorial;
END
$$
```

Вывод:

#figure(
  caption: "Вывод цикла WHILE",
  image("./assets/while-loop-output.png", width: 60%),
)

=== Курсоры: объявление и управление выборкой данных

```sql
DO $$
DECLARE
  curs refcursor;
  comb RECORD;
BEGIN
  OPEN curs FOR select materials.name, sizes.name from sizes, materials;
  LOOP
    FETCH curs INTO comb;
    IF comb IS NULL THEN
      EXIT;
    END IF;
    RAISE NOTICE '%', comb;
  END LOOP;
END
$$
```

Вывод:

#figure(
  caption: "Вывод курсора (начало)",
  image("./assets/cursor-output-1.png", width: 55%),
)

#figure(
  caption: "Вывод курсора (продолжение)",
  image("./assets/cursor-output-2.png", width: 55%),
)

== Процедуры и функции

```sql
CREATE OR REPLACE PROCEDURE print_customers(IN customer_ids INTEGER[]) AS $$
DECLARE
  customer RECORD;
BEGIN
  for customer in
    SELECT
      customers.name,
      customers.surname,
      customers.address,
      customers.phone
    FROM
      customers
    JOIN
      UNNEST(customer_ids) as cids(id)
    ON cids.id = customers.id
  LOOP
    RAISE NOTICE '%', customer;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_customers_having(IN min_orders INTEGER)
RETURNS INTEGER[] AS $$
DECLARE
  order_rec RECORD;
  result INTEGER[];
  tmp RECORD;
BEGIN
  CREATE TEMP TABLE tmp_customers(
    id INTEGER PRIMARY KEY,
    orders INTEGER
  );

  for order_rec IN
    (SELECT customer_id FROM book_orders
    UNION ALL
    SELECT customer_id FROM painting_orders)
  LOOP
    INSERT INTO tmp_customers VALUES
      (order_rec.customer_id, 1)
    ON CONFLICT(id)
    DO UPDATE SET orders = tmp_customers.orders + 1;
  END LOOP;

  SELECT ARRAY(
    SELECT
      id FROM tmp_customers
    WHERE
      orders >= min_orders
  ) INTO result;

  DROP TABLE tmp_customers;

  RETURN result;
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
  ids INTEGER[];
  min_orders CONSTANT INTEGER := 3;
BEGIN
  ids := get_customers_having(3);
  RAISE NOTICE 'IDs of customers having >= % orders: %',
    min_orders, ids;
  RAISE NOTICE 'Printed customers:';
  CALL print_customers(ids);
END;
$$;
```

Вывод:

#figure(
  caption: "Вывод процедуры и функции",
  image("./assets/procedures-output.png", width: 90%),
)

== Триггерные процедуры

=== DML-триггер

```sql
CREATE OR REPLACE FUNCTION update_materials_stock()
RETURNS TRIGGER AS $$
DECLARE
  decrease_amount CONSTANT NUMERIC
    := (NEW.number_of_turns * (NEW.size_id + 1) * 0.02);
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE materials
    SET stock = stock - decrease_amount
    WHERE id = NEW.material_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_materials_stock_trigger
BEFORE INSERT ON book_orders
FOR EACH ROW
EXECUTE FUNCTION update_materials_stock()
```

Содержимое таблицы материалов до добавления заказа:

#figure(
  caption: "Таблица материалов до добавления заказа",
  image("./assets/materials-before.png", width: 90%),
)

Выполним запрос:

```sql
INSERT
INTO book_orders (
  customer_id,
  datetime,
  cost,
  number_of_turns,
  size_id,
  material_id
)
VALUES (4, NOW(), 5600, 24, 2, 4)
```

Содержимое таблицы материалов после добавления заказа представлено ниже. Видим, что пластика в
наличии стало меньше.

#figure(
  caption: "Таблица материалов после добавления заказа",
  image("./assets/materials-after.png", width: 90%),
)

=== DDL-триггер

```sql
CREATE OR REPLACE FUNCTION abort_any_command()
RETURNS event_trigger AS $$
BEGIN
  RAISE EXCEPTION 'command % is disabled', tg_tag;
END;
$$ LANGUAGE plpgsql;

CREATE EVENT TRIGGER abort_ddl ON ddl_command_start
EXECUTE FUNCTION abort_any_command();
```

Теперь попытка изменить схему базы данных приведёт к следующему:

#figure(
  caption: "Результат попытки изменить схему базы данных",
  image("./assets/ddl-trigger-error.png", width: 60%),
)
