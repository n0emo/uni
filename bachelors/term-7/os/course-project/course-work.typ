#import "@local/pgups:0.1.0": course-project
#import "config.typ": config

#show: course-project.with(
  ..config,
  abstract: include "chapters/abstract.typ",
)

#include "chapters/introduction.typ"
#include "chapters/01-requirements.typ"
#include "chapters/02-project-organization.typ"
#include "chapters/03-core.typ"
#include "chapters/04-os-abstractions.typ"
#include "chapters/05-http.typ"
#include "chapters/06-example.typ"
#include "chapters/conclusion.typ"
#bibliography("bibliography.yaml")
#include "appendix/appendix.typ"
