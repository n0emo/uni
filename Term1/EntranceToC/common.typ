#import "@local/pgups:0.1.0": *

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  content,
) = lab-report(
  faculty: "Автоматизация и интеллектуальные технологии",
  department: "Информационные и вычислительные системы",
  discipline: "Введение в С",
  author: (name: "А. Шефнер", post: "студент группы ИВБ-211"),
  teacher: (name: "В.И. Носонов", post: [ст. преп. "ИВС"]),
  number: number,
  title: title,
  text-size: 12pt,
  variant: 17,
  year: 2022,
  content,
)
