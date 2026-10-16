#import "@local/pgups:0.1.0": *

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  variant: none,
  content,
) = laboratory-work(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информационные и вычислительные системы",
    discipline: "Структуры и алгоритмы обработки данных",
    year: 2023,
  ),
  student: config-student(
    name: "А. Шефнер",
    group: "ИВБ-211",
  ),
  teacher: config-teacher(
    name: "А.В. Забродин",
    post: [доц. "ИВС", к.и.н.],
  ),
  lab: config-lab(
    number: number,
    title: title,
    variant: variant,
  ),
  content,
)
