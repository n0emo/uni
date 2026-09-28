#import "@local/pgups:0.1.0": *

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  variant: none,
  content,
) = lab-report(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информатика и информационная безопасность",
    discipline: "Защита информации",
    year: 2025,
  ),
  student: config-student(
    name: "А. Шефнер",
    group: "ИВБ-211",
  ),
  teacher: config-teacher(
    name: "М.Л. Глухарев",
    post: "",
  ),
  lab: config-lab(
    number: number,
    title: title,
    variant: variant,
  ),
  content,
)
