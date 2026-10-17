ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Программирование на языке JAVA»

#strong[ОТЧЁТ]

#strong[ПО ПРАКТИЧЕСКОЙ РАБОТЕ № 2]

#strong[«Создание Web-приложения с использованием Spring Boot. Работа с
GET-запросами и отображением информации»]

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

Оценочный лист результатов ПР № 2

Ф.И.О. студента: #emph[Шефнер А.]

Группа \_\_\_\_\_\_\_\_\_\_\_\_\_#emph[ИВБ-211]\_\_\_\_\_\_\_\_\_\_\_\_

Профессор кафедры

«Информационные и вычислительные

системы»#strong[ «\_\_» \_\_\_\_\_\_\_\_\_\_2024 г. Божко Л.М. ]

#strong[Цель]

Получить теоретические и практические навыки разработки веб-приложений с
использованием языка Clojure, абстракции Ring и библиотеки Compojure.

#strong[Задание ]

+ Создать проект Leiningen в среде разработки Intellij IDEA Community
  Edition или другой с зависимостями Ring, Compojure, Ragtime, HugSQL,
  Hiccup.
+ Перенести структуру классов из ПЗ №1 в созданный проект.
+ Разработать контроллеры и виды для редактирования сущностей из ПЗ №1.
  Разработка видов должна производиться без функционала отображения
  экземпляров сущностей и возможностей их редактирования (только
  верстка)

#strong[Введение]

Хотя в Clojure возможно использование Sprint Boot, это имеет довольно
мало смысла, так как таким образом приходётся отказаться от мощных
возможностей Lisp и в какой-то степени “писать” на Java с очень
непривычным синтаксисом. Вместо этого для веб-приложения выбран мощный
стэк, нативный для Clojure.

#strong[#strong[Определение точек приложения]]

#strong[ ]Ring предоставляет мощные возможности для парсинга и обработки
HTTP запросов, но одного его зачастую не хватает -- в веб-приложении
может быть огромное количество точек с различными параметрами запроса,
различными middleware и т.д. Поэтому вместе с ним для определения
роутинга запросов используется Compojure.

#strong[#strong[src/students/handler.clj]]

\(ns students.handler

\(:require

\[compojure.core :refer \[defroutes GET routes wrap-routes\]\]

\[compojure.route :as route\]

\[ring.middleware.defaults :refer \[site-defaults wrap-defaults\]\]

\[ring.middleware.session.cookie :refer \[cookie-store\]\]

\[students.pages.index :as index\]

\[students.pages.not-found :as not-found\]

\[students.routes.disciplines :refer \[disciplines-routes\]\]

\[students.routes.faculties :refer \[faculties-routes\]\]

\[students.routes.groups :refer \[groups-routes\]\]

\[students.routes.login :refer \[login-routes wrap-protected\]\]

\[students.routes.marks :refer \[marks-routes\]\]

\[students.routes.programs :refer \[programs-routes\]\]

\[students.routes.students :refer \[students-routes\]\]))

\(defroutes app-routes

login-routes

\(-\> (routes

faculties-routes

disciplines-routes

programs-routes

groups-routes

students-routes

marks-routes

\(GET \"/\" \[\] (index/render)))

\(wrap-routes wrap-protected))

\(route/resources \"/\")

\(route/not-found (not-found/render)))

\(def app

\(wrap-defaults

app-routes

(-\> site-defaults

(assoc-in \[:session :store\] (cookie-store))

(assoc-in \[:session :cookie-attrs\] {:max-age 3600}))))

В приведённом листенге представлено определение точек итогового
приложения. К сожалению, объёма отчёта недостаточно для того, чтобы
показать весь код, поэтому в следующем листинге будут представлены лишь
точки страницы факультетов.

#strong[src/students/routes/faculties.clj] (фрагмент)

\(ns students.routes.faculties

\(:require

\[compojure.coercions :refer \[as-int\]\]

\[compojure.core :refer \[context defroutes GET\]\]

\[students.pages.faculties :as html\]))

\(defn- handle-get \[\]

\(let \[faculties (db-faculties/get-all db)\]

\(html/render faculties)))

\(defn- handle-edit-get \[id\]

\(let \[faculty (db-faculties/get-by-id db {:id id})\]

\(html/render-edit faculty)))

\(defroutes faculties-routes

\(context

\"/faculties\" \[\]

\(GET \"/\" \[\] (handle-get))

\(GET \"/:id/edit\" \[id :\<\< as-int\] (handle-edit-get id))))

Обратите внимание, что функции-обработчики GET запросов обращаются к
базе данных. Подробно это будет показано в ПЗ №3.

#strong[#strong[Вёрстка HTML страниц]]

#strong[#strong[ Для вёрстки страниц в языке Clojure довольно удобно
использовать Hiccup -- это крайне простая библиотека, которая позволяет
представить страницу в виде обыкновенного списка элементов на настоящем
языке программирования, что имеет ряд преимуществ, перед движками по
типу Themealeaf. Далее представлен код базовой страницы и страницы
факультетов.]]

#strong[#strong[]]

#strong[#strong[src/students/pages/base.clj]]

#strong[#strong[\(ns students.pages.base]]

#strong[#strong[ \(:require]]

#strong[#strong[ \[hiccup.page :refer \[include-css\]\]]]

#strong[#strong[ \[hiccup2.core :as h\]]]

#strong[#strong[ \[ring.middleware.anti-forgery :refer
\[\*anti-forgery-token\*\]\]))]]

#strong[#strong[]]

#strong[#strong[\(defn- nav-link \[title destination\]]]

#strong[#strong[ \[:li \[:a {:href destination} title\]\])]]

#strong[#strong[]]

#strong[#strong[\(defn- nav-sidebar \[\]]]

#strong[#strong[ \[:nav]]

#strong[#strong[ \[:ul]]

#strong[#strong[ \(nav-link \"На главную\" \"/\")]]

#strong[#strong[ \(nav-link \"Факультеты\" \"/faculties\")]]

#strong[#strong[ \(nav-link \"Дисциплины\" \"/disciplines\")]]

#strong[#strong[ \(nav-link \"Программы\" \"/programs\")]]

#strong[#strong[ \(nav-link \"Группы\" \"/groups\")]]

#strong[#strong[ \(nav-link \"О цифровом деканате\" \"/\")\]\])]]

#strong[#strong[]]

#strong[#strong[\(defn base \[& content\]]]

#strong[#strong[ \(h/html]]

#strong[#strong[ \(h/raw \"\<!DOCTYPE html\>\")]]

#strong[#strong[ \[:html]]

#strong[#strong[ \[:head]]

#strong[#strong[ \[:meta {:charset \"UTF-8\"}\]\]]]

#strong[#strong[ \(include-css \"/css/base.css\")]]

#strong[#strong[ \[:body]]

#strong[#strong[ \(nav-sidebar)]]

#strong[#strong[ content\]\]))]]

#strong[#strong[]]

#strong[#strong[\(defn anti-forgery-input \[\]]]

#strong[#strong[ \[:input {:type \"hidden\" :name
\"\_\_anti-forgery-token\" :value \*anti-forgery-token\*}\])]]

#strong[#strong[]]

#strong[#strong[src/students/pages/faculties.clj]]

#strong[#strong[\(ns students.pages.faculties]]

#strong[#strong[ \(:require]]

#strong[#strong[ \[students.pages.base :refer \[anti-forgery-input
base\]\]))]]

#strong[#strong[]]

#strong[#strong[\(defn- create-form \[\]]]

#strong[#strong[ \[:form {:action \"/faculties\" :method \"post\"}]]

#strong[#strong[ \[:input {:type \"text\" :name \"name\"}\]]]

#strong[#strong[ \[:input {:type \"submit\" :value \"+\"}\]]]

#strong[#strong[ (anti-forgery-input)\])]]

#strong[#strong[]]

#strong[#strong[\(defn- faculty-table \[faculties\]]]

#strong[#strong[ \[:table]]

#strong[#strong[ (for \[f faculties\]]]

#strong[#strong[ (let]]

#strong[#strong[ \[id (get f :id)]]

#strong[#strong[ name (get f :name)\]]]

#strong[#strong[ \[:tr]]

#strong[#strong[ \[:td]]

#strong[#strong[ \[:form {:action (str \"/faculties/\" id \"/delete\")
:method \"post\"}]]

#strong[#strong[ \[:input {:type \"submit\" :value \"x\"}\]]]

#strong[#strong[ \(anti-forgery-input)\]\]]]

#strong[#strong[ \[:td \[:a {:href (str \"/faculties/\" id \"/edit\")}
\"✏️\"\]\]]]

#strong[#strong[ \[:td name\]\]))\])]]

#strong[#strong[]]

#strong[#strong[\(defn render \[faculties\]]]

#strong[#strong[ \(str]]

#strong[#strong[ \(base]]

#strong[#strong[ \[:h1 \"Редактировать факультеты\"\]]]

#strong[#strong[ \(faculty-table faculties)]]

#strong[#strong[ \(create-form))))]]

#strong[#strong[]]

#strong[#strong[\(defn- edit-form \[faculty\]]]

#strong[#strong[ \(let \[id (get faculty :id)]]

#strong[#strong[ name (get faculty :name)\]]]

#strong[#strong[ \[:form {:action (str \"/faculties/\" id \"/edit\")
:method \"post\"}]]

#strong[#strong[ \[:input {:type \"text\" :name \"name\" :value
name}\]]]

#strong[#strong[ \[:input {:type \"submit\" :value \"Изменить\"}]]

#strong[#strong[ \(anti-forgery-input)\]\]))]]

#strong[#strong[]]

#strong[#strong[\(defn render-edit \[faculty\]]]

#strong[#strong[ \(str]]

#strong[#strong[ \(base]]

#strong[#strong[ \[:h1 \"Редактировать факультет\"\]]]

#strong[#strong[ \(edit-form faculty))))]]

#strong[#strong[]]

#strong[#strong[Демонстрация веб-страниц]]

#strong[#box(image("./assets/10000001000008DE000005148D64DA32.png", height: 3.5583in, width: 6.2138in))#strong[]]

#strong[#box(image("./assets/10000001000008DE00000514587ADED2.png", height: 3.7193in, width: 6.4957in))#strong[]]

#strong[#strong[]]

#strong[#box(image("./assets/10000001000008DE00000514340DABAE.png", height: 3.7193in, width: 6.4957in))#strong[]]

#strong[#strong[Вывод]]

В ходе работы были приобретены теоретические и практические навыки
разработки видов веб-приложения на языке Clojure с помощью Ring,
Compojure и Hiccup.
