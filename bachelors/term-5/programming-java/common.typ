#import "@local/pgups:0.1.0": *

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  kind: "laboratory",
  content,
) = laboratory-work(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информационные и вычислительные системы",
    discipline: "Программирование на языке Java",
    year: 2024,
  ),
  student: config-student(
    name: "А. Шефнер",
    group: "ИВБ-211",
  ),
  teacher: config-teacher(
    name: "Л.М. Божко",
    post: [проф. "ИВС"],
  ),
  lab: config-lab(
    number: number,
    title: title,
    kind: kind,
  ),
  content,
)
