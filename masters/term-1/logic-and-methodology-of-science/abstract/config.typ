#import "@local/pgups:0.1.0": config-course, config-student, config-teacher

#let title = [Отношения теории и реальности. Проблема истинности теории.]
#let author = "Шефнер Альберт"
#let course = config-course(
  faculty: "Автоматизация и интеллектуальные технологии",
  department: "Информационные и вычислительные системы",
  discipline: "Логика и методология науки",
  year: 2026,
)
#let student = config-student(name: "А. Шефнер", group: "ИСМ-610")
#let teacher = config-teacher(name: "Л. М. Божко", post: [профессор, д. э. н., доцент])
