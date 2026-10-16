#import "@local/pgups:0.1.0": *

#let course = config-course(
  faculty: "Автоматизация и интеллектуальные технологии",
  department: "Информатика и вычислительная техника",
  discipline: "Технологии программирования",
  speciality-code: "09.03.01",
  speciality: "Информатика и вычислительная техника",
  profile: "Программное обеспечение средств вычислительной техники и автоматизированных систем",
  year: 2025,
)

#let work = config-course-work(
  title: "Архитектура web-сервера на базе плагинов WebAssembly",
  sources: (
    "Спецификация WebAssembly Component Model и интерфейсов WASI",
    "Документация среды выполнения Wasmtime",
    "Документация инструментов wit-bindgen и componentize-py",
  ),
  topics: (
    "Архитектурные решения",
    "Обработка HTTP-запросов",
    "Реализация плагинов",
    "Конфигурация и запуск",
  ),
  steps: (
    config-course-work-step(
      name: "Сбор материалов. Подбор литературы и иных источников. Формирование замысла КР.",
    ),
    config-course-work-step(name: "Разработка кода программы"),
    config-course-work-step(name: "Написание разделов КР"),
    config-course-work-step(name: "Подготовка введения, заключения КР. Оформление КР."),
    config-course-work-step(name: "Защита КР (демонстрация программы)"),
  ),
  assessments: (
    config-course-work-assessment(
      material: "Разработанный HTTP-сервер с архитектурой на базе плагинов WebAssembly",
      indicator: "Рабочий код",
      criteria: (
        config-course-work-criterion(
          description: [
            Разработана полноценная программа, отвечающая базовым требованиям и имеющая
            дополнительный функционал; получены результаты, соответствующие утвержденному заданию.
          ],
          scores: (40, 35),
        ),
        config-course-work-criterion(
          description: [
            Разработана программа, отвечающая базовым требованиям; получены результаты,
            соответствующие утвержденному заданию. При достижении результата работы сделаны
            замечания, частично исправленные обучающимся.
          ],
          scores: (30, 25, 20),
        ),
        config-course-work-criterion(
          description: [
            Представлена программа, имеющая не полный функционал; получены результаты, частично
            соответствующие или не соответствующие утвержденному заданию. По процессу и результату
            исследования сделаны замечания, не исправленные обучающимся.
          ],
          scores: (15, 10, 5, 0),
        ),
      ),
    ),
  ),
)

#let student = config-student(
  name: "А. Шефнер",
  group: "ИВБ-211",
)

#let teacher = config-teacher(
  name: "Д.И. Баталов",
  post: [доц. каф. "ИВС"],
)

#let config = (
  course: course,
  work: work,
  student: student,
  teacher: teacher,
)
