#strong[ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА]

#strong[Федеральное государственное бюджетное образовательное учреждение
высшего образования]

#strong[«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ
Императора Александра I»]

Кафедра «ИНФОРМАЦИОННЫЕ И ВЫЧИСЛИТЕЛЬНЫЕ СИСТЕМЫ»

Дисциплина «Базы данных и управление данными»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № #strong[4]]

#strong[«]Разработка хранимых процедур на языке PL/pgSQL#strong[»]

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

\1. Основные элементы языка PL/pgSQL

\- анонимные блоки кода

\- объявления переменных и основные типы данных

\- организация циклов, итерационные структуры управления

\- курсоры: объявление и управление выборкой данных

\2. Процедуры и функции

\3. Триггерные процедуры

\- DML-триггеры

\- DDL-триггеры

#strong[]

#strong[]

#strong[Основные элементы языка:]

Анонимный блок кода:

DO \$\$

BEGIN

RAISE NOTICE \'Hello, World!\';

END

\$\$

Вывод:

#box(image("./assets/10000001000001A7000000A5E446EC63.png", height: 1.6209in, width: 4.1535in))

Объявления переменных и основные типы данных:

DO \$\$

DECLARE

num INTEGER := 15;

txt VARCHAR;

rw RECORD;

BEGIN

num := num + 54;

txt = \'Number is\';

RAISE NOTICE \'%: %\', txt, num;

SELECT \* FROM Customers LIMIT 1

INTO rw;

RAISE NOTICE \'First customer: %\', rw;

END

\$\$

Вывод:

#box(image("./assets/10000001000002FF000000CDEE32E0D1.png", height: 1.389in, width: 5.198in))

Организация циклов, итерационные структуры управления

Цикл FOR:

DO \$\$

DECLARE

sum INTEGER := 0;

book RECORD;

min\_number\_of\_turns constant INTEGER := 20;

BEGIN

FOR book IN

SELECT cost, number\_of\_turns FROM book\_orders

LOOP

IF book.number\_of\_turns \>= min\_number\_of\_turns THEN

sum := sum + book.cost;

END IF;

END LOOP;

RAISE NOTICE \'Total cost of books having namber of turns \>= %: %\',

min\_number\_of\_turns, sum;

END

\$\$

Вывод:

#box(image("./assets/1000000100000281000000A3E5F8A6F5.png", height: 1.3791in, width: 5.4264in))

Цикл WHILE:

DO \$\$

DECLARE

argument integer := 10;

current\_mult integer := 1;

factorial integer := 1;

BEGIN

WHILE current\_mult \<= argument LOOP

factorial := factorial \* current\_mult;

current\_mult := current\_mult + 1;

END LOOP;

RAISE NOTICE \'Factorial of % is %\', argument, factorial;

END

\$\$

Вывод:

#box(image("./assets/10000001000001A3000000A3BE75C093.png", height: 1.3209in, width: 3.3945in))

Курсоры: объявление и управление выборкой данных:

DO \$\$

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

RAISE NOTICE \'%\', comb;

END LOOP;

END

\$\$

Вывод:

#box(image("./assets/10000001000001E5000001EF2A84AD49.png", height: 3.9425in, width: 3.8626in))

#box(image("./assets/10000001000001E50000024B5B698FCF.png", height: 4.2646in, width: 3.5236in))

#strong[Процедуры и функции]

CREATE OR REPLACE PROCEDURE print\_customers(IN customer\_ids
INTEGER\[\]) AS \$\$

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

UNNEST(customer\_ids) as cids(id)

ON cids.id = customers.id

LOOP

RAISE NOTICE \'%\', customer;

END LOOP;

END;

\$\$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get\_customers\_having(IN min\_orders
INTEGER)

RETURNS INTEGER\[\] AS \$\$

DECLARE

order\_rec RECORD;

result INTEGER\[\];

tmp RECORD;

BEGIN

CREATE TEMP TABLE tmp\_customers(

id INTEGER PRIMARY KEY,

orders INTEGER

);

for order\_rec IN

(SELECT customer\_id FROM book\_orders

UNION ALL

SELECT customer\_id FROM painting\_orders)

LOOP

INSERT INTO tmp\_customers VALUES

(order\_rec.customer\_id, 1)

ON CONFLICT(id)

DO UPDATE SET orders = tmp\_customers.orders + 1;

END LOOP;

SELECT ARRAY(

SELECT

id FROM tmp\_customers

WHERE

orders \>= min\_orders

) INTO result;

DROP TABLE tmp\_customers;

RETURN result;

END;

\$\$ LANGUAGE plpgsql;

DO \$\$

DECLARE

ids INTEGER\[\];

min\_orders CONSTANT INTEGER := 3;

BEGIN

ids := get\_customers\_having(3);

RAISE NOTICE \'IDs of customers having \>= % orders: %\',

min\_orders, ids;

RAISE NOTICE \'Printed customers:\';

CALL print\_customers(ids);

END;

\$\$;

Вывод:

#box(image("./assets/1000000100000293000001232C3D9C7C.png", height: 2.6571in, width: 6.0181in))

#strong[Триггерные процедуры]

DML-триггер:

CREATE OR REPLACE FUNCTION update\_materials\_stock()

RETURNS TRIGGER AS \$\$

DECLARE

decrease\_amount CONSTANT NUMERIC

:= (NEW.number\_of\_turns \* (NEW.size\_id + 1) \* 0.02);

BEGIN

IF TG\_OP = \'INSERT\' THEN

UPDATE materials

SET stock = stock - decrease\_amount

WHERE id = NEW.material\_id;

END IF;

RETURN NEW;

END;

\$\$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update\_materials\_stock\_trigger

BEFORE INSERT ON book\_orders

FOR EACH ROW

EXECUTE FUNCTION update\_materials\_stock()

Содержимое таблицы материалов до добавления заказа:

#box(image("./assets/10000001000003D90000016329BC0D0E.png", height: 2.1689in, width: 6.0181in))

Выполним запрос:

INSERT

INTO book\_orders (

customer\_id,

datetime,

cost,

number\_of\_turns,

size\_id,

material\_id

)

VALUES (4, NOW(), 5600, 24, 2, 4)

Содержимое таблицы материалов после добавления заказа представлено ниже.
Видим, что пластика с наличии стало меньше.

#box(image("./assets/10000001000003D1000001B12149598C.png", height: 2.6665in, width: 6.0181in))

DDL-триггер:

CREATE OR REPLACE FUNCTION abort\_any\_command()

RETURNS event\_trigger AS \$\$

BEGIN

RAISE EXCEPTION \'command % is disabled\', tg\_tag;

END;

\$\$ LANGUAGE plpgsql;

CREATE EVENT TRIGGER abort\_ddl ON ddl\_command\_start

EXECUTE FUNCTION abort\_any\_command();

Теперь попытка изменить схему базы данных приведёт к следующему:

#box(image("./assets/100000010000029700000137C00A7B9C.png", height: 1.961in, width: 4.1807in))

Оценочный лист результатов ЛР №4

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
