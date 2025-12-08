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

#set figure(numbering: num => counter(heading).display() + str(num))

#{
  set page(flipped: true)
  [
    = Структура фрейма WebSocket <sup-websocket>
    #include "01-frame.typ"
  ]
}

= Определения схем сообщений <sup-schemas>

#include "02-message.typ"

= Модуль обработчика WebSocket-подключений <sup-ws-handler>

#include "03-ws-handler.typ"

= Модуль data исходного кода клиента <sup-data-source>

#include "04-data-source.typ"

= Исходный код файла Docker Compose <sup-compose>

#include "05-compose.typ"
