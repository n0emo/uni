#import "@local/pgups:0.1.0": course-work
#import "config.typ": config

#show: course-work.with(
  ..config,
  abstract: include "chapters/abstract.typ",
)

#include "chapters/introduction.typ"
#include "chapters/01-technology.typ"
#include "chapters/02-implementation.typ"
#include "chapters/03-features.typ"
#include "chapters/conclusion.typ"
#bibliography("bibliography.yaml", full: true)
#include "appendix/appendix.typ"
