#import "@local/pgups:0.1.0": *

// Границы листинга задаются строками исходного файла; для `end` учитывается уровень вложенности.
#let julia-fragment(source, first, last, caption: none) = {
  let lines = source.split("\n")
  let first-index = lines.position(line => line.trim() == first)
  assert(first-index != none, message: "Не найдена начальная строка листинга: " + first)
  let indent = lines.at(first-index).match(regex("^ *")).text
  let tail = lines.slice(first-index)
  let stop = tail.position(line => if last == "end" {
    line == indent + "end"
  } else {
    line.trim() == last
  })
  assert(stop != none, message: "Не найдена конечная строка листинга: " + last)
  let snippet = tail
    .slice(0, stop + 1)
    .map(line => line.trim(indent, at: start, repeat: false))
    .join("\n")
  figure(
    raw(snippet, lang: "julia", block: true),
    kind: image,
    caption: caption,
  )
}

#let course = config-course(
  faculty: "Автоматизация и интеллектуальные технологии",
  department: "Информационные и вычислительные системы",
  discipline: "Модели интеграции данных и приложений",
  year: 2026,
)
#let student = config-student(name: "А. Шефнер", group: "ИСМ-610")
#let teacher = config-teacher(
  name: "И.А. Бригаднов",
  post: [д.ф.-м.н., \ профессор кафедры "ИВС"],
)

#let report(title: placeholder("title"), number: placeholder("number"), body) = laboratory-work(
  course: course,
  student: student,
  teacher: teacher,
  lab: config-lab(number: number, title: title),
  {
    show table.cell.where(y: 0): set text(weight: "bold")
    body
  },
)
