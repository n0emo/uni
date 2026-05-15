#import "@local/pgups:0.1.0": *

#let theme = "Разработка интерфейса взаимодействия между информационной системой и пользовательскими программами на основе среды выполнения WebAssembly."
#let speciality = "Информатика и вычислительная техника"
#let specialization = "Программное обеспечение средств вычислительной техники и автоматизированных систем"

#show: backelors-thesis.with(
  faculty: "Автоматизация и интеллектуальные технологии",
  department: "Информационные и вычислительные системы",
  theme: theme,
  speciality: speciality,
  specialization: specialization,
)

#include "./chapters/00-introduction.typ"
#include "./chapters/01-analysis.typ"
#include "./chapters/02-technologies.typ"
#include "./chapters/03-architecture.typ"
#include "./chapters/04-runtime.typ"
#include "./chapters/05-sdk.typ"
#include "./chapters/06-approbation.typ"
#include "./chapters/07-economy.typ"
#include "./chapters/08-labor-protection.typ"
#include "./chapters/99-conclusion.typ"
#bibliography("bibliography.yaml")
