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

#include "./chapters/0-introduction.typ"
#include "./chapters/1-analysis.typ"
#include "./chapters/2-technologies.typ"
#include "./chapters/3-architecture.typ"
#include "./chapters/4-runtime.typ"
#include "./chapters/5-sdk.typ"
#include "./chapters/6-approbation.typ"
#include "./chapters/7-economy.typ"
#include "./chapters/8-labor-protection.typ"
#include "./chapters/9-conclusion.typ"
#bibliography("bibliography.yaml")
