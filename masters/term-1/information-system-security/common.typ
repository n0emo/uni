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

// Вывод `sqlcmd -W -s "|"`, сохранённый командой `bk sql <сценарий> <файл>`:
// наборы строк становятся таблицами, ошибки Msg — выделенными блоками,
// остальные сообщения (print, "(N rows affected)") выводятся как есть
#let sql-output(text-output) = {
  let lines = text-output.replace("\r", "").split("\n")
  let separator = regex("^-+(\|-+)*$")
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
      blocks.push((kind: "error", lines: lines.slice(i, calc.min(i + 2, lines.len()))))
      i += 2
    } else {
      if line != "" {
        blocks.push((kind: "message", line: line))
      }
      i += 1
    }
  }

  set par(first-line-indent: 0mm)
  set text(size: 0.8em)
  for b in blocks {
    if b.kind == "table" {
      block(breakable: true, table(
        columns: b.header.len(),
        align: left,
        inset: (x: 4pt, y: 3pt),
        table.header(..b.header.map(h => strong(raw(h)))),
        ..b.rows.flatten().map(c => if c == "NULL" { emph[NULL] } else { raw(c) }),
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
