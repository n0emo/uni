#import "@local/pgups:0.1.0": *

#show: course-work.with(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информатика и вычислительная техника",
    discipline: "Теория языков программирования и методы трансляции",
    speciality-code: "09.03.01",
    speciality: "Информатика и вычислительная техника",
    profile: "Программное обеспечение средств вычислительной техники и автоматизированных систем",
    year: 2025,
  ),
  work: config-course-work(
    title: "Разработка программного эмулятора микропроцессора MOS6502",
    sources: (
      "Техническая документация и описание системы команд микропроцессора MOS6502",
      "Документация набора инструментов CC65",
      "Руководство \"Easy 6502\" и примеры программ для микропроцессора MOS6502",
    ),
    topics: (
      "История микропроцессора MOS6502",
      "Архитектура и система команд микропроцессора MOS6502",
      "Проектирование и реализация программного эмулятора",
      "Тестирование и демонстрация работы эмулятора с помощью набора инструментов CC65",
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
        material: "Разработанный программный эмулятор микропроцессора MOS6502",
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
  ),
  abstract: include "chapters/abstract.typ",
  student: config-student(
    name: "А. Шефнер",
    group: "ИВБ-211",
  ),
  teacher: config-teacher(
    name: "В.Е. Петров",
    post: [доц. каф. "ИВС"],
  ),
)

#include "chapters/introduction.typ"
#include "chapters/01-history.typ"
#include "chapters/02-architecture.typ"
#include "chapters/03-emulator.typ"
#include "chapters/04-cc65.typ"
#include "chapters/conclusion.typ"
#bibliography("bibliography.yaml")
#include "appendix/appendix.typ"
