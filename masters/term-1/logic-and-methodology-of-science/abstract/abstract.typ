#import "template.typ": abstract
#import "config.typ": course, student, teacher, title

#show: abstract.with(title: title, course: course, student: student, teacher: teacher)

#outline(title: [Содержание], depth: 2)
#pagebreak(weak: true)
#include "chapters/00-introduction.typ"
#include "chapters/01-truth.typ"
#include "chapters/02-testing.typ"
#include "chapters/03-realism.typ"
#include "chapters/04-limits.typ"
#include "chapters/99-conclusion.typ"

#pagebreak(weak: true)
#bibliography("bibliography.yaml", title: [Список использованных источников])
