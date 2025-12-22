#counter(heading).update(0)
#set page(numbering: none)

#set text(size: 12pt)

#let ru-alph(pattern) = {
  let alphabet = "абвгдежзиклмнопрстуфхцчшщэюя".split("")
  let f(i) = {
    let letter = alphabet.at(i)
    let str = ""
    for char in pattern {
      if char == "а" {
        str += letter
      } else if char == "А" {
        str += upper(letter)
      } else {
        str += char
      }
    }
    str
  }
  f
}

#set heading(numbering: ru-alph("А"), outlined: false)
#show heading.where(level: 2): set heading(numbering: none)

#show heading.where(level: 1): it => {
  set text(size: 12pt)
  pagebreak()
  align(center)[ПРИЛОЖЕНИЕ #counter(heading).display(). #it.body]
}

#show table: it => {
  set text(size: 11pt)
  set par(first-line-indent: 0em)
  set list(indent: 0em)
  set enum(indent: 0em)
  it
}

#show figure: set figure(numbering: num => counter(heading).display() + str(num))

= Блочная диаграмма микропроцессора MOS 6502 <sup-diagram>
#include "01-cpu-diagram.typ"

#{
  set page(flipped: true)
  [
    = Набор инструкций микропроцессора MOS 6502 <sup-instruction-set>
    #include "02-instructions.typ"
  ]
}

= Исходный код файла cpu.c <sup-cpu-c>
#include "03-cpu-c.typ"

= Исходный код файла instruction.c <sup-instructions-c>
#include "04-instructions-c.typ"

= Исходный код файла addressing.c <sup-addressing-c>
#include "05-addressing-c.typ"
