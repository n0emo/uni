#import "@local/pgups:0.1.0": appendixes, bachelors-thesis
#import "config.typ": config
#import "style.typ": *

#show: bachelors-thesis.with(
  ..config,
  supervisor-review: include "./chapters/00-review.typ",
  abstract: include "chapters/00-abstract.typ",
)

#show: custom-style

#include "./chapters/00-definitions.typ"
#include "./chapters/00-introduction.typ"
#include "./chapters/01-analysis.typ"
#include "./chapters/02-technologies.typ"
#include "./chapters/03-architecture.typ"
#include "./chapters/04-wit.typ"
#include "./chapters/05-runtime.typ"
#include "./chapters/06-sdk.typ"
#include "./chapters/07-admin.typ"
#include "./chapters/08-economy.typ"
#include "./chapters/09-labor-protection.typ"
#include "./chapters/99-conclusion.typ"
#bibliography("bibliography.yaml")
#appendixes(include "./appendixes.typ")
