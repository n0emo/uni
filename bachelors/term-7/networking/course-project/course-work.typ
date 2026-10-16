#import "@local/pgups:0.1.0": course-project
#import "config.typ": config

#show: course-project.with(
  ..config,
  abstract: include "chapters/abstract.typ",
)

#include "chapters/introduction.typ"
#include "chapters/1-techstack.typ"
#include "chapters/2-transport-layer.typ"
#include "chapters/3-application-layer.typ"
#include "chapters/4-deploy.typ"
#include "chapters/conclusion.typ"
#bibliography("bibliography.yaml")
#include "appendix/appendix.typ"
