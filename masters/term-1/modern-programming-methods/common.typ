#import "@local/pgups:0.1.0": *

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  content,
) = practical-work(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информационные и вычислительные системы",
    discipline: "Современные методы программирования",
    year: 2026,
  ),
  student: config-student(
    name: "А. Шефнер",
    group: "ИСМ-610",
  ),
  teacher: config-teacher(
    name: "В.Е. Петров",
    post: [доц. "ИВС"],
  ),
  lab: config-lab(
    number: number,
    title: title,
  ),
  content,
)
