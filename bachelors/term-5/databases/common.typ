#import "@local/pgups:0.1.0": *

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  kind: "practical",
  content,
) = practical-work(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информационные и вычислительные системы",
    discipline: "Базы данных и управление данными",
    year: 2024,
  ),
  student: config-student(
    name: [А.~Шефнер, Х.А.~Ахмедов, Н.Д.~Кот],
    group: "ИВБ-211",
  ),
  teacher: config-teacher(
    name: "А.Д. Хомоненко",
    post: [проф. "ИВС"],
  ),
  lab: config-lab(
    number: number,
    title: title,
    kind: kind,
  ),
  content,
)
