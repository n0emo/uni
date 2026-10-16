#import "@local/pgups:0.1.0": course-work
#import "config.typ": config

#show: course-work.with(
  ..config,
  abstract: include "chapters/abstract.typ",
)

#include "chapters/introduction.typ"
#include "chapters/01-architecture.typ"
#include "chapters/02-http.typ"
#include "chapters/03-plugins.typ"
#include "chapters/04-running.typ"
#include "chapters/conclusion.typ"
#bibliography("bibliography.yaml")
#include "appendix/appendix.typ"
