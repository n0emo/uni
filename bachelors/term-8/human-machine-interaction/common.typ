#import "@local/pgups:0.1.0": *

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  content,
) = lab-report(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информационные и вычислительные системы",
    discipline: "Человеко-машинное взаимодействие",
    year: 2026,
  ),
  student: config-student(
    name: "А. Шефнер",
    group: "ИВБ-211",
  ),
  teacher: config-teacher(
    name: "Д.М. Хетчиков",
    post: [проф. каф. "ИВС"],
  ),
  lab: config-lab(
    number: number,
    title: title,
  ),
  style: config-style(
    headings-numbering: none,
  ),
  content,
)
