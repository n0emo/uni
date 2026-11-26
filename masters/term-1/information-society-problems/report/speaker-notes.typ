#import "config.typ": author, title
#import "notes.typ": notes

#set document(title: [Текст выступления. #title], author: author)
#set page(paper: "a4", margin: (x: 22mm, y: 19mm), numbering: "1")
#set text(font: "Times New Roman", size: 18pt, lang: "ru")
#set par(leading: 0.58em)
#set heading(numbering: none)

= Текст выступления
#title \
Ориентировочная продолжительность с паузами — 9 минут.

#for (i, note) in notes.enumerate() {
  if i > 0 { pagebreak() }
  block(breakable: false)[
    #heading(level: 2)[Слайд #(i + 1). #note.title]
    #text(size: 14pt, fill: luma(32%))[#note.time]
    #parbreak()
    #show strong: it => highlight(fill: rgb("#ffea77"), it.body)
    #note.body
  ]
}
