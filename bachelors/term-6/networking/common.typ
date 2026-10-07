#import "@local/pgups:0.1.0": *

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  content,
) = lab-report(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информационные и вычислительные системы",
    discipline: "Сети и телекоммуникации",
    year: 2025,
  ),
  student: config-student(
    name: "А. Шефнер",
    group: "ИВБ-211",
  ),
  teacher: config-teacher(
    name: "И.А. Молодкин",
    post: [ст. преп. "ИВС"],
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
