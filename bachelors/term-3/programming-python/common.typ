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
    discipline: "Программирование на языках высокого уровня (Python)",
    year: 2023,
  ),
  student: config-student(
    name: "А. Шефнер",
    group: "ИВБ-211",
  ),
  teacher: config-teacher(
    name: "Д.И. Баталов",
    post: [доц. "ИВС"],
  ),
  lab: config-lab(
    number: number,
    title: title,
    variant: variant,
  ),
  content,
)
