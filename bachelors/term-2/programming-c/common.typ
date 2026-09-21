#import "@local/pgups:0.1.0": *

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  variant: 19,
  content,
) = lab-report(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информационные и вычислительные системы",
    discipline: "Программирование (C)",
    year: 2023,
  ),
  student: config-student(
    name: "А. Шефнер",
    group: "ИВБ-211",
  ),
  teacher: config-teacher(
    name: "",
    post: "",
  ),
  lab: config-lab(
    number: number,
    title: title,
    variant: variant,
  ),
  style: config-style(
    headings-numbering: none,
  ),
  content,
)
