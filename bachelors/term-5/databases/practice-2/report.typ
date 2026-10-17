#import "../common.typ": *

#show: report.with(number: "2", title: "Разработка приложений с Web-интерфейсом")

== Цель работы

Создание веб-приложения, осуществляющего взаимодействие с базой данных PostgreSQL.

== Инструментарий

В данной работе для разработки веб-приложения использовались следующие инструменты и технологии:

- Clojure -- язык программирования высокого уровня, имеющий синтаксис LISP и выполняющийся на
  виртуальной машине Java (JVM)
- Leiningen -- система сборки для проектов на Clojure
- PostgreSQL -- реляционная СУБД с открытым исходным кодом
- Ring -- абстракция HTTP-протокола для Clojure
- HugSQL -- библиотека для выполнения SQL-запросов из Clojure

== Миграции

Для развёртывания приложения на сервере требуется база данных PostgreSQL, в которой будут
сформированы необходимые для приложения таблицы. Для формирования таблиц в данной работе
используется механизм миграций. В файле `src/user.clj` объявлены функции для выполнения миграций:

#code-file(read("./src/user.clj"), name: "src/user.clj")

Далее, добавив псевдонимы в файл `project.clj`, возможно выполнить или отменить миграции с помощью
команд `lein migrate` и `lein rollback`:

```clojure
:aliases {"migrate"  ["run" "-m" "user/migrate"]
          "rollback" ["run" "-m" "user/rollback"]}
```

Обратите внимание, что информация о подключении к базе данных берётся из переменной среды
`DATABASE_URL`. Её нужно определить заранее в формате JDBC. Сами миграции описываются в SQL-файлах в
директории `resources/migrations`. Далее представлено содержание файлов миграций:

#code-file(
  read("./resources/migrations/001-faculties.up.sql"),
  name: "resources/migrations/001-faculties.up.sql",
)
#code-file(
  read("./resources/migrations/001-faculties.down.sql"),
  name: "resources/migrations/001-faculties.down.sql",
)
#code-file(
  read("./resources/migrations/002-disciplines.up.sql"),
  name: "resources/migrations/002-disciplines.up.sql",
)
#code-file(
  read("./resources/migrations/002-disciplines.down.sql"),
  name: "resources/migrations/002-disciplines.down.sql",
)

== SQL-запросы

Для выполнения SQL-запросов из Clojure необходимо создать SQL-файл и воспользоваться макросом
`hugsql.def-db-fns`, который объявит Clojure функции на основании содержания файла с запросами. В
следующем листинге представлен файл `resources/sql/faculties.sql` с запросами к сущности
факультетов:

#code-file(read("./resources/sql/faculties.sql"), name: "resources/sql/faculties.sql")

Далее в файле `src/students/db/faculties.clj` используется HugSQL для объявления функций в Clojure:

#code-file(read("./src/students/db/faculties.clj"), name: "src/students/db/faculties.clj")

В результате в модуле `students.db.faculties` будут объявлены функции `get-all`, `insert`,
`update-faculty` и `delete-by-id`. Параметры запросов и их результаты данные функции принимают и
возвращают в виде словарей вида `{:key value}`. Аналогичным образом определяются запросы и функции
запросов для дисциплин.

== Определение HTTP-точек

Обычно парсинг HTTP-запросов в Clojure осуществляется с помощью Ring. Однако для их обработки его
одного недостаточно -- необходимо определить функции-обработчики запросов. Для управления выбором
функции-обработчика в зависимости от пути запросов можно воспользоваться библиотекой Compojure. На
следующем листинге (`src/students/handler.clj`) представлен роутер приложения -- набор функций,
которые обрабатывают входящие HTTP-запросы.

#code-file(read("./src/students/handler.clj"), name: "src/students/handler.clj")

Далее для примера показано объявление точек страницы факультетов. Точки для страницы дисциплин
определяются аналогичным образом.

#code-file(read("./src/students/routes/faculties.clj"), name: "src/students/routes/faculties.clj")

В приведённом листинге можно заметить определение точек с параметрами, а также использование
сгенерированных HugSQL функций для обращения к базе данных.

== Разработка HTML-страниц

В данном веб-приложении используется рендеринг на стороне сервера (Server Side Rendering -- SSR).
Для отрисовки веб-страниц используется библиотека Hiccup. Здесь видна интересная особенность языков
семейства LISP. Вместо использования шаблонизаторов можно создать удобный в работе и читабельный
язык, специфичный для предметной области (DSL). В следующем листинге приведены страницы факультетов.
Страницы дисциплин определяются аналогичным образом.

#code-file(read("./src/students/pages/faculties.clj"), name: "src/students/pages/faculties.clj")

== Демонстрация работы веб-приложения

#figure(
  caption: [Страница факультетов],
  image("./assets/faculties-page.png", width: 90%),
) <fig-faculties-page>

#figure(
  caption: [Страница дисциплин],
  image("./assets/disciplines-page.png", width: 90%),
) <fig-disciplines-page>

#figure(
  caption: [Страница редактирования дисциплины],
  image("./assets/discipline-edit-page.png", width: 90%),
) <fig-discipline-edit-page>

== Выводы

В ходе данной работы были получены теоретические и практические навыки в области разработки
веб-приложений на языке программирования Clojure, взаимодействующих с базой данных PostgreSQL.
