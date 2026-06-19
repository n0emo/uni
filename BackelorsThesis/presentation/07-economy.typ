#import "../chapters/08-economy.typ": *

#let cum-vals = {
  let acc = 0
  let r = ()
  for t in range(calc-years) {
    let rev = revenues.at(t) * 1000
    let opc = op-costs.at(t) * 1000
    let inv = if t == 0 { investment } else { 0 }
    let p = rev - opc - inv
    let ta = if p > 0 { p * income-tax-rate } else { 0 }
    acc = acc + (p - ta) * discount-coeff(E, t)
    r = r + (acc,)
  }
  r
}

== Экономическое обоснование

- Норма дисконта: $E = 22%$ (8% депозит + 10% риск + 4% инфляция)
- ЧДД за 8 лет: $approx 1 768,5$ тыс. руб. (положительный)
- Индекс доходности: $"ИД" approx 2,16 > 1$
- Срок окупаемости: $approx 5,7$ лет (с 2030 г.)
- Среднегодовая рентабельность: $approx 14,5%$


  #grid(
    columns: (3fr, 2fr),
    column-gutter: 2em,
    cetz.canvas({
      let data = cum-vals.enumerate().map(((t, v)) => (t, v / 1000))
      let y-min = calc.min(..data.map(p => p.at(1)))
      let y-max = calc.max(..data.map(p => p.at(1)))
      plot.plot(
        size: (10, 8),
        x-label: [Год от начала внедрения],
        x-min: 0,
        x-max: calc-years - 1,
        x-tick-step: 1,
        y-label: [ЧДД нараст., тыс. руб.],
        y-min: calc.floor(y-min / 500) * 500,
        y-max: calc.ceil(y-max / 500) * 500,
        y-tick-step: 1000,
        {
          plot.add(((0, 0), (calc-years - 1, 0)), style: (
            stroke: (paint: gray, dash: "dashed"),
          ))
          plot.add(data, mark: "o", mark-size: 0.15, style: (
            stroke: (paint: blue, thickness: 1.5pt),
          ))
        },
      )
    }),

    [
      *Вывод:* проект экономически целесообразен.

      ЧДД $> 0$, ИД $> 1$.

      Срок окупаемости не превышает расчётного периода.
    ],
  )
