#import "@local/pgups:0.1.0": *

#appendixes[
  = Файл project.clj <app-project>

  #code-file(read("../../deanery/project.clj"), name: "project.clj")

  = Скриншот Podman Desktop с запущенным контейнером Postgres <app-podman>

  #figure(image("../assets/podman-postgres.png", width: 100%))

  = Файлы миграций <app-migrations>

  #code-file(
    read("../../deanery/resources/migrations/001-faculties.up.sql"),
    name: "resources/migrations/001-faculties.up.sql",
  )

  #code-file(
    read("../../deanery/resources/migrations/001-faculties.down.sql"),
    name: "resources/migrations/001-faculties.down.sql",
  )

  #code-file(
    read("../../deanery/resources/migrations/002-disciplines.up.sql"),
    name: "resources/migrations/002-disciplines.up.sql",
  )

  #code-file(
    read("../../deanery/resources/migrations/002-disciplines.down.sql"),
    name: "resources/migrations/002-disciplines.down.sql",
  )

  #code-file(
    read("../../deanery/resources/migrations/003-programs.up.sql"),
    name: "resources/migrations/003-programs.up.sql",
  )

  #code-file(
    read("../../deanery/resources/migrations/003-programs.down.sql"),
    name: "resources/migrations/003-programs.down.sql",
  )

  #code-file(
    read("../../deanery/resources/migrations/004-groups.up.sql"),
    name: "resources/migrations/004-groups.up.sql",
  )

  #code-file(
    read("../../deanery/resources/migrations/004-groups.down.sql"),
    name: "resources/migrations/004-groups.down.sql",
  )

  #code-file(
    read("../../deanery/resources/migrations/005-students.up.sql"),
    name: "resources/migrations/005-students.up.sql",
  )

  #code-file(
    read("../../deanery/resources/migrations/005-students.down.sql"),
    name: "resources/migrations/005-students.down.sql",
  )

  #code-file(
    read("../../deanery/resources/migrations/006-student-marks.up.sql"),
    name: "resources/migrations/006-student-marks.up.sql",
  )

  #code-file(
    read("../../deanery/resources/migrations/006-student-marks.down.sql"),
    name: "resources/migrations/006-student-marks.down.sql",
  )

  = ER диаграмма схемы базы данных <app-er>

  #figure(image("../assets/er-diagram.png", width: 100%))

  = Файл handler.clj <app-handler>

  #code-file(read("../../deanery/src/students/handler.clj"), name: "src/students/handler.clj")

  = Модули HTML видов <app-pages>

  #code-file(read("../../deanery/src/students/pages/base.clj"), name: "src/students/pages/base.clj")

  #code-file(
    read("../../deanery/src/students/pages/index.clj"),
    name: "src/students/pages/index.clj",
  )

  #code-file(
    read("../../deanery/src/students/pages/students.clj"),
    name: "src/students/pages/students.clj",
  )

  = SQL-файлы запросов <app-sql>

  #code-file(
    read("../../deanery/resources/sql/disciplines.sql"),
    name: "resources/sql/disciplines.sql",
  )

  #code-file(read("../../deanery/resources/sql/marks.sql"), name: "resources/sql/marks.sql")

  = Модули Clojure, подключающие SQL-запросы с помощью HugSQL <app-hugsql>

  #code-file(read("../../deanery/src/students/db/core.clj"), name: "src/students/db/core.clj")

  #code-file(
    read("../../deanery/src/students/db/disciplines.clj"),
    name: "src/students/db/disciplines.clj",
  )

  #code-file(
    read("../../deanery/src/students/db/faculties.clj"),
    name: "src/students/db/faculties.clj",
  )

  #code-file(read("../../deanery/src/students/db/groups.clj"), name: "src/students/db/groups.clj")

  #code-file(read("../../deanery/src/students/db/marks.clj"), name: "src/students/db/marks.clj")

  #code-file(
    read("../../deanery/src/students/db/programs.clj"),
    name: "src/students/db/programs.clj",
  )

  #code-file(
    read("../../deanery/src/students/db/students.clj"),
    name: "src/students/db/students.clj",
  )

  = Модули маршрутизаторов видов и обработчиков POST запросов <app-routes>

  #code-file(
    read("../../deanery/src/students/routes/disciplines.clj"),
    name: "src/students/routes/disciplines.clj",
  )

  #code-file(
    read("../../deanery/src/students/routes/marks.clj"),
    name: "src/students/routes/marks.clj",
  )

  = Модуль авторизации <app-login>

  #code-file(
    read("../../deanery/src/students/routes/login.clj"),
    name: "src/students/routes/login.clj",
  )

  = Входная точка приложения <app-core>

  #code-file(read("../../deanery/src/students/core.clj"), name: "src/students/core.clj")

  = Страница авторизации <app-login-page>

  #figure(image("../assets/login-page.png", width: 100%))

  = Главная страница <app-index-page>

  #figure(image("../assets/index-page.png", width: 100%))

  = Страница факультетов <app-faculties-page>

  #figure(image("../assets/faculties-page.png", width: 100%))

  = Страница редактирования дисциплины <app-edit-discipline-page>

  #figure(image("../assets/edit-discipline-page.png", width: 100%))

  = Страница информации о студенте <app-student-page>

  #figure(image("../assets/student-page.png", width: 100%))

  = Страница добавления оценки <app-new-mark-page>

  #figure(image("../assets/new-mark-page.png", width: 100%))
]
