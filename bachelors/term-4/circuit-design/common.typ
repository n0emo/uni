#import "@local/pgups:0.1.0": *

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  content,
) = practice-report(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информационные и вычислительные системы",
    discipline: "Основы микроэлектроники и схемотехники",
    year: 2024,
  ),
  student: config-student(
    name: "А. Шефнер",
    group: "ИВБ-211",
  ),
  teacher: config-teacher(
    name: "Р.Г. Гильванов",
    post: [доц. "ИВС", к.воен.н.],
  ),
  lab: config-lab(
    number: number,
    title: title,
  ),
  style: config-style(
    headings-numbering: none,
    headings-pagebreak: false,
  ),
  content,
)
