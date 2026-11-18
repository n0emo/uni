#import "@local/pgups:0.1.0": config-course, config-student, config-teacher

#let title = [Автоматизация оформления учебных работ средствами Typst и пакета pgups]
#let author = "Шефнер Альберт"
#let presentation-date = none

#let course = config-course(
  faculty: "Автоматизация и интеллектуальные технологии",
  department: "Информационные и вычислительные системы",
  discipline: "Интеллектуальные информационные системы и технологии",
  year: 2026,
)

#let student = config-student(name: "А. Шефнер", group: "ИСМ-610")
#let teacher = config-teacher(name: "С.В. Пугачёв", post: [доц. "ИВС"])
