#import "@local/pgups:0.1.0": *

#let brigade = (
  "Шефнер А.",
  "Масленников С.Д.",
  "Ахмедов Х.А.",
  "Егупов Н.М.",
  "Кот Н.Д.",
)

// Title page stacks the names, the assessment sheet lists them in one line
#let student = context if here().page() == 1 {
  brigade.join(linebreak())
} else {
  brigade.join(", ")
}

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  content,
) = laboratory-work(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информационные и вычислительные системы",
    discipline: "Микроэлектронные системы управления",
    year: 2026,
  ),
  student: config-student(
    name: student,
    group: "ИСМ-610",
  ),
  teacher: config-teacher(
    name: "Ю.В. Иванов",
    post: [асс.],
  ),
  lab: config-lab(
    number: number,
    title: title,
  ),
  content,
)
