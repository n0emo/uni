#import "presentation/notes.typ": notes

#set document(title: "Текст выступления: Typst и pgups", author: "А. Шефнер")
#set page(paper: "a4", margin: 20mm, numbering: "1")
#set text(font: "Times New Roman", size: 13pt, lang: "ru")
#set par(leading: 0.65em)
#set heading(numbering: none)
#show heading.where(level: 1): set text(size: 16pt)

#let clock(seconds) = {
  let remainder = calc.rem(seconds, 60)
  str(calc.floor(seconds / 60)) + ":" + if remainder < 10 { "0" } else { "" } + str(remainder)
}
#let elapsed = 0

= Текст выступления

Ориентир: #clock(notes.map(note => note.seconds).sum()) с паузами и переключением слайдов. Текст для
произнесения приведён обычным шрифтом. Строки «Основа» служат справкой и не входят в выступление.

#for (i, note) in notes.enumerate() {
  let end = elapsed + note.seconds
  block(breakable: false)[
    #heading(level: 1)[Слайд #(i + 1). #note.title]
    #text(size: 11pt)[#clock(elapsed)–#clock(end) · #(note.seconds) с]

    #note.body

    #text(size: 10pt, fill: luma(35%))[Основа: #note.source]
  ]
  elapsed = end
  v(0.7em)
}
