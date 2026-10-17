#import "@local/pgups:0.1.0": *

#let course = config-course(
  faculty: "Автоматизация и интеллектуальные технологии",
  department: "Информационные и вычислительные системы",
  discipline: "Программирование на языке Java",
  speciality-code: "09.03.01",
  speciality: "Информатика и вычислительная техника",
  profile: "Программное обеспечение средств вычислительной техники и автоматизированных систем",
  year: 2024,
)

#let work = config-course-work(
  title: "Разработка Web-приложения на основе интеграции JVM и Lisp (Clojure)",
  sources: (
    "Литературные источники, посвящённые программированию на Clojure",
    "Документация и материалы Clojure и Ring",
    "Примеры ранее выполненных проектов и исследовательских работ, касающихся разработки аналогичных приложений",
  ),
  topics: (
    "Описание используемой технологии и языка программирования Clojure",
    "Разработка модели базы данных образовательной организации",
    "Определение маршрутизаторов для обработки GET и POST запросов",
    "Реализация пользовательского интерфейса с помощью библиотеки Hiccup",
    "Сборка итогового приложения в JAR-файл и развёртывание",
  ),
  steps: (
    config-course-work-step(
      name: "Сбор материалов. Подбор литературы и иных источников. Формирование замысла КР.",
      begin: datetime(year: 2024, month: 11, day: 10),
      end: datetime(year: 2024, month: 11, day: 20),
    ),
    config-course-work-step(
      name: "Разработка кода программы",
      begin: datetime(year: 2024, month: 11, day: 21),
      end: datetime(year: 2024, month: 12, day: 5),
    ),
    config-course-work-step(
      name: "Написание разделов КР",
      begin: datetime(year: 2024, month: 12, day: 6),
      end: datetime(year: 2024, month: 12, day: 10),
    ),
    config-course-work-step(
      name: "Подготовка введения, заключения КР. Оформление КР.",
      begin: datetime(year: 2024, month: 12, day: 11),
      end: datetime(year: 2024, month: 12, day: 15),
    ),
    config-course-work-step(name: "Защита КР (демонстрация программы)"),
  ),
  assessments: (
    config-course-work-assessment(
      material: "Разработанное приложение на языке Java",
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
  name: "Л.М. Божко",
  post: [проф. каф. "ИВС"],
)

#let config = (
  course: course,
  work: work,
  student: student,
  teacher: teacher,
)
