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
      }
      else if char == "А" {
        str += upper(letter)
      }
      else {
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
  pagebreak()
  set text(size: 12pt)
  align(center)[ПРИЛОЖЕНИЕ #counter(heading).display(). #it.body]
}

= Реализация линейного аллокатора <sup-arena>

#include "01-arena.typ"

= Реализация MewVector <sup-vector>

#include "02-vector.typ"

= Реализация модуля сокетов для POSIX и Win32 <sup-socket>

#include "03-socket.typ"

= Организация HTTP сервера <sup-server>

#include "04-server.typ"
