#import "@local/pgups:0.1.0": *

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  content,
) = lab-report(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информационные и вычислительные системы",
    discipline: "Микроэлектронные системы управления",
    year: 2026,
  ),
  student: config-student(
    name: "А. Шефнер",
    group: "ИСМ-610",
  ),
  teacher: config-teacher(
    name: [Ю.В. Иванов],
    post: [асс.],
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
