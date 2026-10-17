#import "@local/pgups:0.1.0": *

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  students: "А. Шефнер",
  content,
) = practical-work(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информационные и вычислительные системы",
    discipline: "Корпоративные информационные системы",
    year: 2025,
  ),
  student: config-student(
    name: students,
    group: "ИВБ-211",
  ),
  teacher: config-teacher(
    name: "С.В. Пугачёв",
    post: [доц. "ИВС"],
  ),
  lab: config-lab(
    number: number,
    title: title,
  ),
  content,
)
