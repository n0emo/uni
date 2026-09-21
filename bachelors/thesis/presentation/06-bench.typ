#import "./plots.typ": *

== Нагрузочное тестирование

#align(horizon)[
  *Методика*

  100 одновременных подключений, 30 минут непрерывной нагрузки, идентичная бизнес-логика во всех
  реализациях.

  *Сценарии нагрузки:*
  - вычислительная --- рекурсивное вычисление 35-го числа Фибоначчи
  - I/O --- выборка 10 000 строк из СУБД Postgres в формате JSON

  *Реализации:*
  - C\# --- ASP.NET, конфигурация Native AOT
  - Go --- `net/http`
  - JavaScript --- NodeJS, `node:http`
  - Rust --- `axum`, `tokio-postgres`
  - WASM --- плагин на Rust под управлением Wassel
]

#pagebreak()

#align(horizon)[
  *35-е число Фибоначчи*
  #make-table(data-fibonacci)
  #make-plots(data-fibonacci)
]

#pagebreak()

#align(horizon)[
  *10000 строк из СУБД Postgres*
  #make-table(data-postgres)
  #make-plots(data-postgres)
]
