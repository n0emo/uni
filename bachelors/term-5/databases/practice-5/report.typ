#import "../common.typ": *

#show: report.with(number: "5", title: "Обработка больших данных на R")

== Цель работы

Изучить основные принципы и методологии управления данными и их жизненным циклом. На практике
применить полученные знания для решения конкретной задачи.

== Набор данных

Данные о количестве заявок, проведённых и сданных экзаменов JLPT разных уровней в Японии и за
рубежом:

#figure(
  caption: [Фрагмент набора данных JLPT],
  image("./assets/dataset.png", width: 90%),
) <fig-dataset>

== Код программы

#code-file(
  ```r
  jlpt_csv <- read.csv("JLPT.csv")
  years <- subset(jlpt_csv, jlpt_csv$Level == "N1")$Year
  applications <- as.integer(gsub(",", "", (c(subset(jlpt_csv, jlpt_csv$Level == "N1")$Applicants)))) # nolint
  xx <- 1:23
  line <- lm(applications ~ xx)
  plot(applications, xlab = "Years",
      main = "Applications of JLPT N1 in Japan")
  abline(line, col = "red")
  axis(1, at = seq_along(applications), labels = years, las = 2)
  print(summary(applications))
  ```.text,
  name: "main.R",
)

== Результаты

#figure(
  caption: [Результат вызова функции `summary` для количества заявок],
  image("./assets/summary.png", width: 60%),
) <fig-summary>

#figure(
  caption: [Количество заявок на JLPT N1 в Японии и линия регрессии],
  image("./assets/applications-plot.png", height: 60%),
) <fig-applications>

== Выводы

В ходе работы было произведено исследование статистики заявок на JLPT N1 в Японии с помощью метода
линейной регрессии и языка R. Исследование показывает рост количества заявок с течением времени.
