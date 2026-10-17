#import "@local/pgups:0.1.0": *

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  content,
) = laboratory-work(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информационные и вычислительные системы",
    discipline: "Моделирование систем",
    year: 2024,
  ),
  student: config-student(
    name: "А. Шефнер",
    group: "ИВБ-211",
  ),
  teacher: config-teacher(
    name: "В.А. Гончаренко",
    post: [доц. "ИВС"],
  ),
  lab: config-lab(
    number: number,
    title: title,
    variant: 30,
  ),
  content,
)
