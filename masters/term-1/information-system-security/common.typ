#import "@local/pgups:0.1.0": *

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  content,
) = laboratory-work(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информатика и информационная безопасность",
    discipline: "Обеспечение безопасности информационных систем",
    year: 2026,
  ),
  student: config-student(
    name: [А.~Шефнер, Н.Е.~Антипов, Д.А.~Цуканова],
    group: "ИСМ-619",
  ),
  teacher: config-teacher(
    name: "М.Л. Глухарев",
    post: [доц. "ИиИБ"],
  ),
  lab: config-lab(
    number: number,
    title: title,
  ),
  content,
)

// sqlcmd опускает ведущий ноль у decimal: .00, -.50
#let sql-cell(c) = if c == "NULL" { emph[NULL] } else {
  raw(c.replace(regex("^(-?)\\.(\\d+)$"), m => m.captures.at(0) + "0." + m.captures.at(1)))
}

// Вывод `bk sql <сценарий> <файл>`: наборы строк — таблицами, ошибки — выделенными блоками
#let sql-output(text-output) = {
  let lines = text-output.replace("\r", "").split("\n")
  let separator = regex("^-+(\|-+)*$")
  let terminated = (
    "Выполнение данной инструкции было прервано.",
    "The statement has been terminated.",
  )
  let blocks = ()
  let i = 0
  while i < lines.len() {
    let line = lines.at(i)
    if i + 1 < lines.len() and lines.at(i + 1).match(separator) != none {
      let header = line.split("|")
      let rows = ()
      i += 2
      while i < lines.len() and lines.at(i) != "" {
        let cells = lines.at(i).split("|")
        if cells.len() > header.len() {
          cells = cells.slice(0, header.len() - 1) + (cells.slice(header.len() - 1).join("|"),)
        }
        rows.push(cells + ("",) * (header.len() - cells.len()))
        i += 1
      }
      blocks.push((kind: "table", header: header, rows: rows))
    } else if line.starts-with("Msg ") {
      let n = if lines.at(i + 2, default: none) in terminated { 3 } else { 2 }
      blocks.push((kind: "error", lines: lines.slice(i, calc.min(i + n, lines.len()))))
      i += n
    } else {
      if line != "" {
        blocks.push((kind: "message", line: line))
      }
      i += 1
    }
  }

  set par(first-line-indent: 0mm)
  set text(size: 0.8em)
  show: block.with(width: 100%, above: 1em, below: 1.5em)
  for b in blocks {
    if b.kind == "table" {
      block(breakable: true, table(
        columns: b.header.len(),
        align: left,
        inset: (x: 4pt, y: 3pt),
        table.header(..b.header.map(h => strong(raw(h)))),
        ..b.rows.flatten().map(sql-cell),
      ))
    } else if b.kind == "error" {
      block(
        width: 100%,
        inset: 6pt,
        stroke: (left: 2pt + red.darken(20%)),
        fill: red.lighten(92%),
        raw(b.lines.join("\n")),
      )
    } else {
      block(above: 0.6em, below: 0.6em, raw(b.line))
    }
  }
}
