#import "@local/pgups:0.1.0": course-work
#import "config.typ": config

#show: course-work.with(
  ..config,
  abstract: include "chapters/abstract.typ",
)

#include "chapters/introduction.typ"
#include "chapters/01-history.typ"
#include "chapters/02-architecture.typ"
#include "chapters/03-emulator.typ"
#include "chapters/04-cc65.typ"
#include "chapters/conclusion.typ"
#bibliography("bibliography.yaml")
#include "appendix/appendix.typ"
