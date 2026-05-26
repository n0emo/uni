#import "@local/pgups:0.1.0": *

#show: backelors-thesis.with(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информационные и вычислительные системы",
    speciality: "Информатика и вычислительная техника",
    speciality-code: "09.03.01",
    profile: "Программное обеспечение средств вычислительной техники и автоматизированных систем",
  ),
  student: config-student(
    name: "Шефнер А.",
    group: "ИВБ-211",
  ),
  superviser: config-superviser(name: "Хетчиков Д.М.", post: "профессор"),
  head-of-department: config-head-of-department(
    name: "Ермаков С.Г.",
    post: "д.т.н., профессор",
  ),
  normative-controller: config-normative-controller(
    name: "Петров В.Е.",
    post: "к.в.н., доцент",
  ),
  consultants: (
    config-consultant(
      name: "Куранова О.Н.",
      post: "к.т.н., доцент",
      section: "Экономическая часть",
    ),
    config-consultant(
      name: "Тихомиров О.И.",
      post: "к.т.н., доцент",
      section: "Охрана труда",
    ),
  ),
  thesis: config-thesis(
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
  ),
)

#show table: set text(size: 11pt)

#include "./chapters/00-definitions.typ"
#include "./chapters/00-introduction.typ"
#include "./chapters/01-analysis.typ"
#include "./chapters/02-technologies.typ"
#include "./chapters/03-architecture.typ"
#include "./chapters/04-runtime.typ"
#include "./chapters/05-sdk.typ"
#include "./chapters/06-approbation.typ"
#include "./chapters/07-economy.typ"
#include "./chapters/08-labor-protection.typ"
#include "./chapters/99-conclusion.typ"
#bibliography("bibliography.yaml")
#appendixes(include "./appendixes.typ")
