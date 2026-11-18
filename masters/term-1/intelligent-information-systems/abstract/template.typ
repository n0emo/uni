#import "@local/pgups:0.1.0": config-style, front-page, style-body, style-front, submission-block

#let abstract-style = config-style(
  text-font: "Times New Roman",
  text-size-front: 12pt,
  text-line-spacing: 1.15em,
  headings-supplement: none,
  headings-pagebreak: true,
)

#let abstract(title: [], course: (), student: (), teacher: (), body) = {
  set document(title: title, author: student.name)

  {
    show: style-front.with(style: abstract-style)

    front-page(course: course)[
      #v(3em)
      #align(center)[
        *РЕФЕРАТ* \
        на тему: \
        #strong(quote(title))
      ]
      #v(3em)
      #submission-block(student, teacher)
    ]
  }

  show: style-body.with(style: abstract-style)
  body
}
