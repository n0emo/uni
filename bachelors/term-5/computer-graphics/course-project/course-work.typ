#import "@local/pgups:0.1.0": course-project
#import "config.typ": config

#show: course-project.with(
  ..config,
  abstract: none,
)

#include "chapters/introduction.typ"
#include "chapters/01-webgpu-history.typ"
#include "chapters/02-window-creation.typ"
#include "chapters/03-application-base.typ"
#include "chapters/04-wgsl-scene.typ"
#include "chapters/05-web-application.typ"
#include "chapters/conclusion.typ"
#bibliography("bibliography.yaml", full: true)
#include "appendix/appendix.typ"
