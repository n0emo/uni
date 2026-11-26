#import "@local/pgups:0.1.0": config-course, config-student, config-teacher

#let title = [Краудсорсинг как новый вид динамики и трансляции научного знания]
#let author = "Шефнер Альберт"
#let course = config-course(
  faculty: "Автоматизация и интеллектуальные технологии",
  department: "История и философия",
  discipline: "Социальные и философские проблемы информационного общества",
  year: 2026,
)
#let student = config-student(name: "А. Шефнер", group: "ИСМ-610")
#let teacher = config-teacher(name: "Л. В. Мурейко", post: [доцент, к. филос. н.])
