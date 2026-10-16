#import "@local/pgups:0.1.0": *

#appendixes[
  #include "01-cpu-diagram.typ"
  #{
    set page(flipped: true)
    include "02-instructions.typ"
  }
  #include "03-cpu-c.typ"
  #include "04-instructions-c.typ"
  #include "05-addressing-c.typ"
]
