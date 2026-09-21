#import "@local/pgups:0.1.0": *

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  content,
) = lab-report(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информационные и вычислительные системы",
    discipline: "Введение в С",
    year: 2022,
  ),
  student: config-student(
    name: "А. Шефнер",
    group: "ИВБ-211",
  ),
  teacher: config-teacher(
    name: "В.И. Носонов",
    post: [ст. преп. "ИВС"],
  ),
  lab: config-lab(
    number: number,
    title: title,
    variant: 17,
  ),
  content,
)
