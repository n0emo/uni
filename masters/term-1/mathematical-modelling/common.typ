#import "@local/pgups:0.1.0": *

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  content,
) = laboratory-work(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информационные и вычислительные системы",
    discipline: "Математическое моделирование",
    year: 2026,
  ),
  student: config-student(
    name: "А. Шефнер",
    group: "ИСМ-610",
  ),
  teacher: config-teacher(
    name: "И.А. Малков",
    post: none,
  ),
  lab: config-lab(
    number: number,
    title: title,
    variant: 5,
  ),
  content,
)
