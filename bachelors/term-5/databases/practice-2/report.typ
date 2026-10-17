ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Базы данных и управление данными»#strong[]

#strong[ОТЧЁТ]

#strong[ПО ПРАКТИЧЕСКОЙ РАБОТЕ № 2]

#strong[«Разработка приложений с Web-интерфейсом»]

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    [Выполнили студенты

    Факультет: АИТ

    Группа: ИВБ-211

    ], [Ахмедов Х.А.

    Кот Н.Д.

    Шефнер А.

    ],
    [Проверил:

    Профессор кафедры

    «Информационные и вычислительные

    системы

    ], [Хомоненко А.Д.],
  )]
  , kind: table
  )

#strong[Санкт-Петербург]

#strong[2024]

Оценочный лист результатов ПР № 2

Ф.И.О. студентов :#emph[Ахмедов Х.А., Кот Н.Д., Шефнер А.]

Группа \_\_\_\_\_\_\_\_\_\_\_\_\_#emph[ИВБ-211]\_\_\_\_\_\_\_\_\_\_\_\_

Профессор кафедры

«Информационные и вычислительные

системы»#strong[ Хомоненко А.Д. «\_\_» \_\_\_\_\_\_\_\_\_\_2024 г. ]

#strong[Цель]

Создание веб-приложения, осуществляющего взаимодействие с базой данных
PostgreSQL

#strong[Инструментарий]

#strong[ ]В данной работе для разработки веб-приложения использовались
следующие инструменты и технологии:

- Clojure --- язык программирования высокого уровня имеющий синтаксис
  LISP и выполняющийся на виртуальной машине Java (JVM)
- Leiningen --- система сборки для проектов на Clojure
- PostgreSQL --- реляционная СУБД с открытым исходным кодом
- Ring --- абстракция HTTP протокола для Clojure
- HugSQL --- библиотека для выполнения SQL запросов из Clojure
-

#strong[Миграции]

Для развёртывания приложения на сервере требуется база данных
PostgreSQL, в которой будут сформированы необходимые для приложения
таблицы. Для формирования таблиц в данной работе используется механизм
миграций. В файле src/user.clj объявлены функции для выполнения
миграций:

\(ns user (:require \[ragtime.jdbc :as jdbc\]

\[ragtime.repl :as repl\]))

\(def config

{:datastore (jdbc/sql-database {:connection-uri (System/getenv
\"DATABASE\_URL\")})

:migrations (jdbc/load-resources \"migrations\")})

\#\_{:clj-kondo/ignore \[:clojure-lsp/unused-public-var\]}

\(defn migrate \[\]

\(repl/migrate config))

\#\_{:clj-kondo/ignore \[:clojure-lsp/unused-public-var\]}

\(defn rollback \[\]

\(repl/rollback config))

Далее, добавив псевдонимы в файл project.clj, возможно выполнить или
отменить миграции с помощью команд lein migrate и lein rollback:

:aliases {\"migrate\" \[\"run\" \"-m\" \"user/migrate\"\]

\"rollback\" \[\"run\" \"-m\" \"user/rollback\"\]}

Обратите внимание, что для информация о подключении к базе данных
берётся из переменной среды DATABASE\_URL. Её нужно определить заранее в
формате JDBC. Сами миграции описываются в SQL файлах в директории
resources/migrations. Далее представлено содержание файлов миграций:

\-\- resources/migrations/001-faculties.up.sql

create table faculties(

id serial primary key not null,

name text not null,

unique (name)

);

\-\- resources/migrations/001-faculties.down.sql

drop table faculties;

\-\- resources/migrations/002-disciplines.up.sql

create table disciplines(

id serial primary key not null,

name text not null,

faculty\_id integer not null,

unique(name),

foreign key (faculty\_id) references faculties(id)

);

\-\- resources/migrations/002-disciplines.down.sql

drop table disciplines;

#strong[SQL-запросы]

Для выполнения SQL запросов из Clojure необходимо создать SQL файл и
воспользоваться макросом hugsql.def-db-fns, которые объявит Clojure
функции на основании содержания файл с запросами. В следующем листинге
представлен файл resources/sql/faculties.sql с запросами к сущности
факультетов:

\-\- :name get-all :? :\*

select

id,

name

from

faculties;

\-\- :name get-by-id :? :1

select

id,

name

from

faculties

where

id = :id;

\-\- :name insert :!

insert into

faculties(name)

values

\(:name);

\-\- :name update-faculty :!

update

faculties

set

name = :name

where

id = :id;

\-\- :name delete-by-id :!

delete from

faculties

where

id = :id;

Далее в файле src/students/db/faculties.clj используется HugSQL для
объявления функций в Clojure:

\(ns students.db.faculties

\(:require \[hugsql.core :as hugsql\]))

\(hugsql/def-db-fns \"sql/faculties.sql\")

В результате в модуле students.db.faculties будут объявлены функции
get-all, insert, update-faculty и delete-by-id. Параметры запросов и их
результаты данные функции принимают и возвращают в виде словарей вида
{:key value}. Аналогичным образом определяются запросы и функции
запросов для дисциплин.

#strong[]

#strong[Определение HTTP точек]

#strong[ ]Обычно парсинг HTTP запросов в Clojure осуществляется с
помощью Ring. Однако для их обработки его одного недостаточно ---
необходимо определить функции-обработчики запросов. Для управления
выбором функции-обработчика в зависимости от пути запросов можно
воспользоваться библиотекой Compojure. На следующем листинге
(src/students/handler.clj) представлен роутер приложения --- набор
функций, которые обрабатывают входящие HTTP запросы.

\(ns students.handler

\(:require

\[compojure.core :refer \[defroutes GET\]\]

\[compojure.route :as route\]

\[ring.middleware.defaults :refer \[site-defaults wrap-defaults\]\]

\[students.pages.index :as index\]

\[students.pages.not-found :as not-found\]

\[students.routes.disciplines :refer \[disciplines-routes\]\]

\[students.routes.faculties :refer \[faculties-routes\]\]))

\(defroutes app-routes

faculties-routes

disciplines-routes

\(GET \"/\" \[\] (index/render))

\(route/resources \"/\")

\(route/not-found (not-found/render)))

\#\_{:clj-kondo/ignore \[:clojure-lsp/unused-public-var\]}

\(def app

\(wrap-defaults

app-routes

site-defaults))

#strong[ ]

Далее для примера показано объявление точек страницы факультетов. Точки
для страницы дисциплин определяются аналогичным образом.

\(ns students.routes.faculties

\(:require

\[compojure.coercions :refer \[as-int\]\]

\[compojure.core :refer \[context defroutes GET POST\]\]

\[ring.util.response :refer \[redirect\]\]

\[students.db.core :refer \[db\]\]

\[students.db.faculties :as db-faculties\]

\[students.pages.faculties :as html\]))

\(defn- handle-get \[\]

\(let \[faculties (db-faculties/get-all db)\]

\(html/render faculties)))

\(defn- handle-post \[name\]

\(db-faculties/insert db {:name name})

\(redirect \"/faculties\"))

\(defn- handle-delete \[id\]

\(db-faculties/delete-by-id db {:id id})

\(redirect \"/faculties\"))

\(defn- handle-edit-get \[id\]

\(let \[faculty (db-faculties/get-by-id db {:id id})\]

\(html/render-edit faculty)))

\(defn- handle-edit-post \[id name\]

\(db-faculties/update-faculty db {:id id :name name})

\(redirect \"/faculties\"))

\(defroutes faculties-routes

\(context

\"/faculties\" \[\]

\(GET \"/\" \[\] (handle-get))

\(POST \"/\" \[name\] (handle-post name))

\(POST \"/:id/delete\" \[id :\<\< as-int\] (handle-delete id))

\(GET \"/:id/edit\" \[id :\<\< as-int\] (handle-edit-get id))

\(POST \"/:id/edit\" \[id :\<\< as-int name\] (handle-edit-post id
name))))

В приведённом листинге можно заметить определение точек с параметрами, а
так же использование сгенерированных HugSQL функций для обращения к базе
данных.

#strong[Разработка HTML страниц]

В данном веб-приложении используется рендеринг на стороне сервера
(Srtver Side Rendering --- SSR). Для отрисовки веб-страниц используется
библиотека Hiccup. Здесь видна интересная особенность языков семейства
LISP. Вместо использования шаблонизаторов можно создать удобный в работе
и читабельный язык, специфичный для предметной области (DSL). В
следующем листинге приведены страницы факультетов. Страницы дисциплин
определяются аналогичным образом.

\(ns students.pages.faculties

\(:require

\[students.pages.base :refer \[anti-forgery-input base\]\]))

\(defn- create-form \[\]

\[:form {:action \"/faculties\" :method \"post\"}

\[:input {:type \"text\" :name \"name\"}\]

\[:input {:type \"submit\" :value \"+\"}\]

(anti-forgery-input)\])

\(defn- faculty-table \[faculties\]

\[:table

(for \[f faculties\]

(let

\[id (get f :id)

name (get f :name)\]

\[:tr

\[:td

\[:form {:action (str \"/faculties/\" id \"/delete\") :method \"post\"}

\[:input {:type \"submit\" :value \"x\"}\]

\(anti-forgery-input)\]\]

\[:td \[:a {:href (str \"/faculties/\" id \"/edit\")} \"✏️\"\]\]

\[:td name\]\]))\])

\(defn render \[faculties\]

\(str

\(base

\[:h1 \"Редактировать факультеты\"\]

\(faculty-table faculties)

\(create-form))))

\(defn- edit-form \[faculty\]

\(let \[id (get faculty :id)

name (get faculty :name)\]

\[:form {:action (str \"/faculties/\" id \"/edit\") :method \"post\"}

\[:input {:type \"text\" :name \"name\" :value name}\]

\[:input {:type \"submit\" :value \"Изменить\"}

\(anti-forgery-input)\]\]))

\(defn render-edit \[faculty\]

\(str

\(base

\[:h1 \"Редактировать факультет\"\]

\(edit-form faculty))))

#strong[]

#strong[Демонстрация работы веб-приложения]

#box(image("./assets/1000000100000402000002AEEC22C83F.png", height: 4.35in, width: 6.5071in))#strong[Рис.
1 --- ]страница факультетов

#box(image("./assets/100000000000040000000180143CA487.png", height: 2.4307in, width: 6.4839in))#strong[Рис.
2 --- ]страница дисциплин

#box(image("./assets/10000001000004010000022DE7A97165.png", height: 3.5665in, width: 6.5646in))#strong[Рис.
3 --- ]страница редактирования дисциплины

#strong[]

#strong[Вывод]

#strong[ ]В ходе данной работы были получены теоретические и
практические навыки в области разработки веб-приложений на языке
программирования Clojure, взаимодействующих в базой данных PostgreSQL.
