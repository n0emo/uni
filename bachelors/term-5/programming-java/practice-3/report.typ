ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Программирование на языке JAVA»

#strong[ОТЧЁТ]

#strong[ПО ПРАКТИЧЕСКОЙ РАБОТЕ № 3]

#strong[«Обработка форм и POST-запросы в Spring Boot. Spring Data JPA»]

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    [Выполнил студент

    Факультет: АИТ

    Группа: ИВБ-211

    ], [Шефнер А.],
    [Проверила:

    Профессор кафедры

    «Информационные и вычислительные

    системы

    ], [Божко Л.М.],
  )]
  , kind: table
  )

#strong[Санкт-Петербург]

#strong[2024]

Оценочный лист результатов ПР № 3

Ф.И.О. студента: #emph[Шефнер А.]

Группа \_\_\_\_\_\_\_\_\_\_\_\_\_#emph[ИВБ-211]\_\_\_\_\_\_\_\_\_\_\_\_

Профессор кафедры

«Информационные и вычислительные

системы»#strong[ «\_\_» \_\_\_\_\_\_\_\_\_\_2024 г. Божко Л.М. ]

#strong[Цель]

Получить теоретические и практические навыки разработки веб-приложений с
использованием языка Clojure, абстракции Ring и библиотеки Compojure.

#strong[Задание ]

+ В проекте к ПЗ №2 добавить зависимости ragtime, hugsql, postgresql
  (или другой драйвер базы данных).
+ Настроить подключение к базе данных на основе конфигурационного файла,
  конфигурационного класса или переменной среды.
+ Реализовать необходимые SQL запросы для добавления, извлечения,
  обновления и удаления сущностей.
+ Реализовать репозитории для этих сущностей.
+ В виды с отображением информации добавить возможность просмотра
  существующих сущностей.
+ В виды с отображением информации добавить формы добавления новых
  сущностей и функционал по редактированию/удалению существующих.
+ В контроллеры отображения добавить соответствующие обработчики
  POST-запросов для добавления, редактирования и удаления сущностей.

#strong[Введение]

Как уже было сказано в предыдущих практических работах, в связке с
Clojure гораздо лучше использовать такие инструменты, как Ragtime и
Hugsql, нежели Spring Data JPA. В данном отчёте будет представлена
организация работы с базой данных на примере сущностей оценок.

#strong[Определение #strong[POST ]точек приложения]

#strong[ ]К обработчикам Compojure добавляются POST точки, которые
принимают в себя различные параметры. По умолчанию они автоматически
парсятся из тела запроса, если его Content-Type это application/json или
application/x-www-form-urlencoded. В данной работе нас интересует
последний, так как именно в таком формате на сервер отправляются данные
из HTML форм.

#strong[src/students/#strong[marks]\.clj]

\(ns students.routes.marks

\(:require

\[clojure.java.jdbc :as java.jdbc\]

\[compojure.coercions :refer \[as-int\]\]

\[compojure.core :refer \[context defroutes GET POST\]\]

\[ring.util.response :refer \[redirect\]\]

\[students.db.core :refer \[db\]\]

\[students.db.disciplines :as db-disciplines\]

\[students.db.marks :as db-marks\]

\[students.db.students :as db-students\]

\[students.pages.marks :as pages\]))

\(defn- handle-new-get \[student-id kind-id\]

\(let \[student (db-students/get-student-by-id db {:id student-id})

mark-kinds (db-marks/get-kinds db)

disciplines (db-disciplines/get-all db)\]

\(pages/render-new student mark-kinds kind-id disciplines)))

\(defn- handle-new-post \[card-id student-id mark-kind study-term
params\]

\(java.jdbc/with-db-transaction \[tx db\]

\(let \[mark (db-marks/insert-mark tx {:kind mark-kind

:card-id card-id

:study-term study-term})

mark-id (get mark :id)\]

\(case mark-kind

\"credit\" (db-marks/insert-credit tx

{:mark-id mark-id

:discipline-id (Integer/parseInt (get params :discipline-id))})

\"exam\" (db-marks/insert-exam tx

{:mark-id mark-id

:discipline-id (Integer/parseInt (get params :discipline-id))

:value (Integer/parseInt (get params :value))})

\"practice\" (db-marks/insert-practice tx

{:mark-id mark-id

:description (get params :description)}))))

\(redirect (str \"/students/\" student-id)))

\(defroutes marks-routes

\(context

\"/marks\" \[\]

\(GET \"/new\" \[student-id :\<\< as-int

:as {params :params}\]

(let \[kind-id (get params :kind \"credit\")\] (handle-new-get
student-id kind-id)))

\(POST \"/new\" \[card-id :\<\< as-int

student-id :\<\< as-int

mark-kind

study-term :\<\< as-int

:as {params :params}\]

\(handle-new-post card-id student-id mark-kind study-term params))))

В приведённом листенге представлено определение точек итогового
приложения. К сожалению, объёма отчёта недостаточно для того, чтобы
показать весь код, поэтому в следующем листинге будут представлены лишь
точки страницы факультетов.

#strong[Разработка #strong[SQL-запросов]]

#strong[ #strong[Представленный выше код использует функции из модуля
students.db.marks и других. Эти функции автоматически генерируются
Hugsql на основании файла SQL-запросов.]]

#strong[src/students/db/core.clj]

\(ns students.db.core)

#strong[#strong[]]

\(def db {:connection-uri (System/getenv \"DATABASE\_URL\")})

#strong[#strong[]]

#strong[src/students/db/marks.clj]

\(ns students.db.marks

\(:require \[hugsql.core :as hugsql\]))

\(hugsql/def-db-fns \"sql/marks.sql\")

#strong[resources/sql/marks.sql]

\-\- :name get-kinds :? :\*

select

name,

title

from

mark\_kinds;

\-\- :name get-all :? :\*

select

m.id as id,

m.kind as kind,

m.study\_term as \"study-term\",

coalesce(c.discipline\_id, e.discipline\_id) as \"discipline-id\",

d.name as discipline,

f.name as faculty,

e.\"value\" as \"value\",

p.description as description

from

marks m

left join

credit\_marks c

on

c.mark\_id = m.id

left join

exam\_marks e

on

e.mark\_id = m.id

left join

practice\_marks p

on

p.mark\_id = m.id

left join

disciplines d

on

d.id = coalesce(c.discipline\_id, e.discipline\_id)

left join

faculties f

on

f.id = d.faculty\_id

where

m.card\_id = :card-id;

\-\- :name insert-mark :\<! :1

insert into

marks(kind, card\_id, study\_term)

values

\(:kind, :card-id, :study-term)

returning id;

\-\- :name insert-credit :!

insert into

credit\_marks(mark\_id, discipline\_id)

values

\(:mark-id, :discipline-id);

\-\- :name insert-exam :!

insert into

exam\_marks(mark\_id, discipline\_id, \"value\")

values

\(:mark-id, :discipline-id, :value);

\-\- :name insert-practice :!

insert into

practice\_marks(mark\_id, description)

values

\(:mark-id, :description);

#strong[Демонстрация страницы оценок]

#strong[#box(image("./assets/10000001000008DE00000514C3587679.png", height: 3.5311in, width: 6.1665in))]

#box(image("./assets/10000001000008DE000004224A5D9011.png", height: 2.9457in, width: 6.3209in))

#strong[#box(image("./assets/1000000100000CD600000616033636C3.png", height: 3.139in, width: 6.6209in))#strong[]]

#strong[Вывод]

В ходе работы были приобретены теоретические и практические навыки
разработки POST точек веб-приложения на языке Clojure и навыки
взаимодействия с базой данных Postgres.
