#import "@preview/cetz:0.5.2": canvas, draw, palette
#import "@preview/cetz-plot:0.1.4": chart

#let data-fibonacci = csv("fibonacci.csv")
#let data-postgres = csv("postgres.csv")

#let make-table(data) = {
  let header = data.at(0)
  let data = data.slice(1)

  table(
    columns: header.map(_ => 1fr),
    align: center + horizon,
    table.header(..header.map(h => [*#h*])),
    ..data.map(row => row.map(c => [#c])).flatten()
  )
}

#let make-plots(data) = {
  let header = data.at(0)
  let data = data.slice(1)
  let data-avg = data.map(row => (row.at(0), float(row.at(1))))
  let data-rps = data.map(row => (row.at(0), float(row.at(2))))
  let width = 9
  let height = 6
  let pal = palette.dark-green

  grid(
    columns: (1fr, 1fr),
    align: center,
    canvas({
      chart.barchart(
        size: (width, height),
        bar-style: pal,
        x-label: [Задержка (сек)],
        x-mode: "log",
        x-base: 10,
        x-ticks: (0.1, calc.exp(-1), 1, calc.exp(1), 10),
        x-min: 0.1,
        x-max: 10,
        data-avg,
      )
    }),

    canvas({
      chart.barchart(
        size: (width, height),
        bar-style: pal,
        x-label: [Запросы/сек],
        x-mode: "log",
        x-base: 10,
        x-ticks: (1, 10, 100, 1000),
        x-min: 1,
        x-max: 1000,
        data-rps,
      )
    }),
  )
}
