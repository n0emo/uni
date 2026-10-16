#let author = "А. Шефнер"
#let group = "ИВБ-211"
#let discipline = "Философия"

#let style(body) = {
  set document(author: author)
  set page(
    paper: "a4",
    margin: (left: 30mm, right: 15mm, top: 20mm, bottom: 20mm),
    numbering: "1",
  )
  set text(lang: "ru", region: "ru", font: "Times New Roman", size: 14pt)
  set par(
    justify: true,
    leading: 0.65em,
    spacing: 0.65em,
    first-line-indent: (amount: 1.25cm, all: true),
  )
  set list(marker: [--])
  set heading(numbering: none)
  show heading: set block(above: 1.4em, below: 1em)
  show heading.where(level: 1): set align(center)
  show heading.where(level: 1): set text(size: 16pt)
  show heading.where(level: 2): set text(size: 14pt)
  show heading.where(level: 3): set text(size: 14pt)
  set table(inset: 6pt)
  show table: set text(size: 12pt)
  show table: set par(justify: false, first-line-indent: 0pt)
  body
}

#let header(kind, title) = {
  set document(title: title)
  align(right, text(size: 12pt)[#author, #group \ #discipline])
  v(1em)
  align(center, text(size: 16pt, weight: "bold")[#kind \ #title])
  v(1em)
}

/// Письменное практическое задание
#let practice(number: none, title: none, body) = {
  show: style
  header([Практическое задание №~#number], title)
  body
}

/// Эссе
#let essay(title: none, body) = {
  show: style
  header([Эссе], title)
  body
}
