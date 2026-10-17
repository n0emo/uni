#import "../common.typ": *

#show: report.with(
  number: "1",
  title: "Разработка структуры классов на основе модели данных",
  kind: "practical",
)

== Цель работы

Получить теоретические и практические навыки разработки модели для базы данных веб-приложения.

== Задание

+ Разработать иерархию классов на примере какой-либо предметной области. Как минимум один из классов
  должен быть наследован от другого.
+ Подготовить ER-диаграмму данных классов.

== Ход работы

Хотя в Clojure возможно использование классов и JPA, часто это бывает попросту непрактично, если
разрабатывается новое ПО на этом языке и в проекте нет большого количества кода на языке Java.
Поэтому в данной работе используется более естественное для такой среды решение -- SQL. С помощью
ragtime возможно выполнение миграций, а hugsql позволяет выполнять SQL-запросы из Clojure и получать
их результаты в виде словарей или векторов словарей. В данной практической работе будет представлен
код миграций, создающий все таблицы базы данных. Модель представляет собой схему базы данных
некоторой образовательной организации, в которой хранится информация о факультетах, программах
обучения, дисциплинах, группах, студентах и их оценках. Оценки могут быть разных видов, что в
некотором роде можно сопоставить с наследованием. В следующем единственном листинге показано
содержание всех файлов миграций разработанной модели:

#code-file(
  read("../deanery/resources/migrations/001-faculties.up.sql"),
  name: "resources/migrations/001-faculties.up.sql",
)
#code-file(
  read("../deanery/resources/migrations/001-faculties.down.sql"),
  name: "resources/migrations/001-faculties.down.sql",
)
#code-file(
  read("../deanery/resources/migrations/002-disciplines.up.sql"),
  name: "resources/migrations/002-disciplines.up.sql",
)
#code-file(
  read("../deanery/resources/migrations/002-disciplines.down.sql"),
  name: "resources/migrations/002-disciplines.down.sql",
)
#code-file(
  read("../deanery/resources/migrations/003-programs.up.sql"),
  name: "resources/migrations/003-programs.up.sql",
)
#code-file(
  read("../deanery/resources/migrations/003-programs.down.sql"),
  name: "resources/migrations/003-programs.down.sql",
)
#code-file(
  read("../deanery/resources/migrations/004-groups.up.sql"),
  name: "resources/migrations/004-groups.up.sql",
)
#code-file(
  read("../deanery/resources/migrations/004-groups.down.sql"),
  name: "resources/migrations/004-groups.down.sql",
)
#code-file(
  read("../deanery/resources/migrations/005-students.up.sql"),
  name: "resources/migrations/005-students.up.sql",
)
#code-file(
  read("../deanery/resources/migrations/005-students.down.sql"),
  name: "resources/migrations/005-students.down.sql",
)
#code-file(
  read("../deanery/resources/migrations/006-student-marks.up.sql"),
  name: "resources/migrations/006-student-marks.up.sql",
)
#code-file(
  read("../deanery/resources/migrations/006-student-marks.down.sql"),
  name: "resources/migrations/006-student-marks.down.sql",
)

== ER-диаграмма

#figure(
  caption: [ER-диаграмма базы данных],
  image("./assets/er-diagram.png", height: 20cm),
)

== Выводы

В ходе работы были приобретены теоретические и практические навыки разработки модели базы данных.
Была разработана модель некоторой образовательной организации и построена ER-диаграмма схемы базы
данных.
