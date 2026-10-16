#import "@local/pgups:0.1.0": *

#let course = config-course(
  faculty: "Автоматизация и интеллектуальные технологии",
  department: "Информационные и вычислительные системы",
  speciality: "Информатика и вычислительная техника",
  speciality-code: "09.03.01",
  profile: "Программное обеспечение средств вычислительной техники и автоматизированных систем",
)

#let student = config-student(
  name: "Шефнер А.",
  fullname-genitive: "Шефнера Альберта",
  group: "ИВБ-211",
)

#let supervisor = config-supervisor(
  name: "Хетчиков Д.М.",
  post: "д.т.н., доцент",
  post-full: [профессор кафедры "Информационные и вычислительные системы"],
)

#let head-of-department = config-head-of-department(
  name: "Ермаков С.Г.",
  post: "д.т.н., профессор",
)

#let normative-controller = config-normative-controller(
  name: "Петров В.Е.",
  post: "к.в.н.",
)

#let consultants = (
  config-consultant(
    name: "Куранова О.Н.",
    post: "к.т.н.",
    section: "Экономическая часть",
  ),
  config-consultant(
    name: "Тихомиров О.И.",
    post: "к.т.н., доцент",
    section: "Охрана труда",
  ),
)

#let thesis = config-thesis(
  title: [
    Разработка интерфейса взаимодействия между информационной системой и пользовательскими
    программами на основе среды выполнения WebAssembly
  ],
  steps: (
    config-thesis-step(
      begin: none,
      end: none,
      name: "Анализ литературы и постановка задачи",
    ),
    config-thesis-step(
      begin: none,
      end: none,
      name: "Проектирование архитектуры",
    ),
    config-thesis-step(
      begin: none,
      end: none,
      name: "Разработка функционала",
    ),
    config-thesis-step(
      begin: none,
      end: none,
      name: "Тестирование и отладка",
    ),
    config-thesis-step(
      begin: none,
      end: none,
      name: [Написание раздела "Охрана труда"],
    ),
    config-thesis-step(
      begin: none,
      end: none,
      name: [Написание раздела "Экономическая часть"],
    ),
    config-thesis-step(
      begin: none,
      end: none,
      name: "Оформление пояснительной записки",
    ),
    config-thesis-step(
      begin: none,
      end: none,
      name: "Проверка антиплагиата",
    ),
  ),
)

#let config = (
  course: course,
  student: student,
  supervisor: supervisor,
  head-of-department: head-of-department,
  normative-controller: normative-controller,
  consultants: consultants,
  thesis: thesis,
)
