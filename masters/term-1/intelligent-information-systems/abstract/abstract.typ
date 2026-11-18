#import "template.typ": abstract
#import "config.typ": course, student, teacher, title
#import "style.typ": custom-style

#show: abstract.with(title: title, course: course, student: student, teacher: teacher)
#show: custom-style

#outline(title: [Оглавление])
#pagebreak()

#include "chapters/00-introduction.typ"
#include "chapters/01-package.typ"
#include "chapters/02-thesis.typ"
#include "chapters/03-notebooks.typ"
#include "chapters/04-evaluation.typ"
#include "chapters/99-conclusion.typ"

#pagebreak(weak: true)
#bibliography(
  "bibliography.yaml",
  title: [Список использованных источников],
)
