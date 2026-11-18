#let custom-style(body) = {
  show table.header: set text(weight: "bold")
  show raw.where(block: true): set block(breakable: false)
  body
}
