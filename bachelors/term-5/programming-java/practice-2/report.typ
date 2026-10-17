#import "../common.typ": *

#show: report.with(
  number: "2",
  title: "Создание Web-приложения с использованием Spring Boot. Работа с GET-запросами и отображением информации",
  kind: "practical",
)

== Цель работы

Получить теоретические и практические навыки разработки веб-приложений с использованием языка
Clojure, абстракции Ring и библиотеки Compojure.

== Задание

+ Создать проект Leiningen в среде разработки IntelliJ IDEA Community Edition или другой с
  зависимостями Ring, Compojure, Ragtime, HugSQL, Hiccup.
+ Перенести структуру классов из ПЗ №1 в созданный проект.
+ Разработать контроллеры и виды для редактирования сущностей из ПЗ №1. Разработка видов должна
  производиться без функционала отображения экземпляров сущностей и возможностей их редактирования
  (только верстка).

== Введение

Хотя в Clojure возможно использование Spring Boot, это имеет довольно мало смысла, так как таким
образом приходится отказаться от мощных возможностей Lisp и в какой-то степени «писать» на Java с
очень непривычным синтаксисом. Вместо этого для веб-приложения выбран мощный стек, нативный для
Clojure.

== Определение точек приложения

Ring предоставляет мощные возможности для парсинга и обработки HTTP запросов, но одного его зачастую
не хватает -- в веб-приложении может быть огромное количество точек с различными параметрами
запроса, различными middleware и т.д. Поэтому вместе с ним для определения роутинга запросов
используется Compojure.

#code-file(read("../deanery/src/students/handler.clj"), name: "src/students/handler.clj")

В приведённом листинге представлено определение точек итогового приложения. К сожалению, объёма
отчёта недостаточно для того, чтобы показать весь код, поэтому в следующем листинге будут
представлены лишь точки страницы факультетов.

#figure(
  kind: raw,
  caption: [`src/students/routes/faculties.clj` (фрагмент)],
  ```clojure
  (ns students.routes.faculties
    (:require
     [compojure.coercions :refer [as-int]]
     [compojure.core :refer [context defroutes GET POST]]
     [ring.util.response :refer [redirect]]
     [students.db.core :refer [db]]
     [students.db.faculties :as db-faculties]
     [students.pages.faculties :as html]))

  (defn- handle-get []
    (let [faculties (db-faculties/get-all db)]
      (html/render faculties)))

  (defn- handle-edit-get [id]
    (let [faculty (db-faculties/get-by-id db {:id id})]
      (html/render-edit faculty)))

  (defroutes faculties-routes
    (context
      "/faculties" []
      (GET    "/" [] (handle-get))
      (GET    "/:id/edit" [id :<< as-int] (handle-edit-get id))))
  ```,
)

Обратите внимание, что функции-обработчики GET запросов обращаются к базе данных. Подробно это будет
показано в ПЗ №3.

== Вёрстка HTML страниц

Для вёрстки страниц в языке Clojure довольно удобно использовать Hiccup -- это крайне простая
библиотека, которая позволяет представить страницу в виде обыкновенного списка элементов на
настоящем языке программирования, что имеет ряд преимуществ перед движками по типу Thymeleaf. Далее
представлен код базовой страницы и страницы факультетов.

#code-file(read("../deanery/src/students/pages/base.clj"), name: "src/students/pages/base.clj")

#code-file(
  read("../deanery/src/students/pages/faculties.clj"),
  name: "src/students/pages/faculties.clj",
)

== Демонстрация веб-страниц

#figure(
  caption: [Страница редактирования списка факультетов],
  image("./assets/faculties-page.png", width: 100%),
)

#figure(
  caption: [Страница редактирования факультета],
  image("./assets/faculty-edit-page.png", width: 100%),
)

#figure(
  caption: [Главная страница приложения],
  image("./assets/index-page.png", width: 100%),
)

== Выводы

В ходе работы были приобретены теоретические и практические навыки разработки видов веб-приложения
на языке Clojure с помощью Ring, Compojure и Hiccup.

#appendixes[
  = Исходный текст программы
  #code-file(
    read("../deanery/src/students/routes/faculties.clj"),
    name: "src/students/routes/faculties.clj",
  )
]
