#import "@local/pgups:0.1.0": *

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  variant: none,
  content,
) = practical-work(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информационные и вычислительные системы",
    discipline: "Надёжность информационных систем",
    year: 2025,
  ),
  student: config-student(
    name: "А. Шефнер",
    group: "ИВБ-211",
  ),
  teacher: config-teacher(
    name: "Е.Н. Шаповалов",
    post: [к.т.н., доцент кафедры "ИВС"],
  ),
  lab: config-lab(
    number: number,
    title: title,
    variant: variant,
  ),
  content,
)
