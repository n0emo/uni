#import "@local/pgups:0.1.0": *

#appendixes[
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
]
