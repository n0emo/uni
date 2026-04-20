#import "@local/pgups:0.1.0": *

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  variant: none,
  content,
) = practice-report(
  faculty: [Автоматизация и интеллектуальные технологии],
  department: [Информационные и вычислительные системы],
  discipline: [Надёжность информационных систем],
  author: (name: "А. Шефнер", post: "студент группы ИВБ-211"),
  teacher: (name: "Е.Н. Шаповалов", post: [к.т.н., доцент кафедры "ИВС"]),
  text-size: 12pt,
  title: title,
  number: number,
  variant: variant,
  content,
)
