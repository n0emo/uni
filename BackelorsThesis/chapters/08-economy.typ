// TODO: проставить ссылки на формулы
// TODO: правильно расписать определение символов формул
// TODO: внимательно првоерить экономическую часть

#import "@preview/cetz:0.5.2"
#import "@preview/cetz-plot:0.1.4": plot

#let dev-hourly-rate = 300
#let dev-hours-per-day = 8
#let dev-days-per-month = 21
#let dev-months = 12
#let dev-count = 1

#let hw-setup-hours = 20
#let hw-setup-rate = 300

#let hw-pc-cost = 80000

#let insurance-rate = 0.30
#let overhead-rate = 0.25

#let pc-cost = 80000
#let pc-lifetime-years = 3
#let sw-cost = 0
#let sw-lifetime-years = 2

#let pc-power-kw = 0.3
#let electricity-price = 6.97

#let consumables-rate = 0.10
#let repair-parts-rate = 0.10
#let engineer-monthly = 80000
#let pcs-per-engineer = 50
#let extra-expenses-rate = 0.10

#let profit-rate = 0.20
#let vat-rate = 0.20
#let income-tax-rate = 0.20

#let deposit-rate = 0.08
#let risk-premium = 0.10
#let inflation-rate = 0.04

#let project-start-year = 2025
#let calc-years = 8

#let revenues = (0, 80, 200, 600, 1200, 2500, 4000, 5500)

#let op-costs = (0, 40, 80, 200, 350, 600, 900, 1100)


// Суммарное время разработки (часов)
#let calc-dev-hours(months, days-per-month, hours-per-day, count) = {
  months * days-per-month * hours-per-day * count
}

// Основная заработная плата
#let calc-ozp(hours, rate) = { hours * rate }

// Страховые взносы
#let calc-insurance(ozp, rate) = { ozp * rate }

// Накладные расходы
#let calc-overhead(ozp, rate) = { ozp * rate }

// Расходы на электроэнергию
#let calc-electricity(power-kw, price, hours) = { power-kw * price * hours }

// Расходы на расходные материалы за период
#let calc-consumables(pc-cost, rate, lifetime-years, months) = {
  pc-cost * rate / (lifetime-years * 12) * months
}

// Расходы на ремонт за период
#let calc-repair(pc-cost, rate, lifetime-years, months) = {
  pc-cost * rate / (lifetime-years * 12) * months
}

// Зарплата инженера-системотехника за период (на 1 ПК)
#let calc-engineer-salary(monthly, pcs, months) = { monthly / pcs * months }

// Амортизация ПК за период
#let calc-apc(pc-cost, lifetime-years, months) = {
  pc-cost / (lifetime-years * 12) * months
}

// Амортизация ПО за период
#let calc-apo(sw-cost, lifetime-years, months) = {
  if lifetime-years == 0 or sw-cost == 0 { 0 } else {
    sw-cost / (lifetime-years * 12) * months
  }
}

// Дополнительные расходы (аренда, уборка и т.д.)
#let calc-extra(engineer-monthly, extra-rate, pcs, months) = {
  engineer-monthly / pcs * months * extra-rate
}

// Себестоимость разработки
#let calc-cost(ozp, insurance, overhead, pc-expenses) = {
  ozp + insurance + overhead + pc-expenses
}

// Прибыль
#let calc-profit(cost, rate) = { cost * rate }

// Стоимость программы без НДС
#let calc-price(cost, profit) = { cost + profit }

// НДС
#let calc-vat(price, rate) = { price * rate }

// Стоимость с НДС
#let calc-price-with-vat(price, vat) = { price + vat }

// Норма дисконта
#let calc-discount-rate(a, b, c) = { a + b + c }

// Коэффициент дисконтирования для периода t
#let discount-coeff(E, t) = { 1 / calc.pow(1 + E, t) }

// ЧДД за год t (с учётом инвестиций)
#let npv-year(revenue, costs, invest, E, t) = {
  (revenue - costs - invest) * discount-coeff(E, t)
}

// ЧДД после налога на прибыль за год t
#let npv-year-after-tax(revenue, costs, invest, E, t, tax-rate) = {
  let profit-before-tax = revenue - costs - invest
  let tax = if profit-before-tax > 0 { profit-before-tax * tax-rate } else { 0 }
  (profit-before-tax - tax) * discount-coeff(E, t)
}

// Индекс доходности
#let calc-id(disc-revenues, disc-costs) = { disc-revenues / disc-costs }

// Среднегодовая рентабельность
#let calc-sr(id, n) = { (id - 1) / n * 100 }

// Форматирование в рублях (округление до целых)
#let rub(v) = { str(calc.round(v)) + " руб." }

// Форматирование в рублях (до 2 знаков)
#let rub2(v) = { str(calc.round(v, digits: 2)) + " руб." }

// ============================================================
// ВЫЧИСЛЕНИЯ
// ============================================================

// --- Аппаратная часть ---
#let hw-rot = hw-setup-hours * hw-setup-rate
#let hw-insurance = hw-rot * insurance-rate
#let hw-overhead = hw-rot * overhead-rate
#let hw-cost = hw-pc-cost + hw-rot + hw-insurance + hw-overhead
#let hw-profit = hw-cost * profit-rate
#let hw-price = hw-cost + hw-profit

// --- Программная часть ---
#let dev-hours = calc-dev-hours(
  dev-months,
  dev-days-per-month,
  dev-hours-per-day,
  dev-count,
)
#let dev-years = dev-months / 12 // для расчёта амортизации

#let ozp = calc-ozp(dev-hours, dev-hourly-rate)
#let insurance = calc-insurance(ozp, insurance-rate)
#let overhead = calc-overhead(ozp, overhead-rate)

#let elec = calc-electricity(pc-power-kw, electricity-price, dev-hours)
#let consumables = calc-consumables(
  pc-cost,
  consumables-rate,
  pc-lifetime-years,
  dev-months,
)
#let repair = calc-repair(
  pc-cost,
  repair-parts-rate,
  pc-lifetime-years,
  dev-months,
)
#let eng-salary = calc-engineer-salary(
  engineer-monthly,
  pcs-per-engineer,
  dev-months,
)
#let apc = calc-apc(pc-cost, pc-lifetime-years, dev-months)
#let apo = calc-apo(sw-cost, sw-lifetime-years, dev-months)
#let extra = calc-extra(
  engineer-monthly,
  extra-expenses-rate,
  pcs-per-engineer,
  dev-months,
)
#let pc-expenses = elec + consumables + repair + eng-salary + apc + apo + extra

#let cost = calc-cost(ozp, insurance, overhead, pc-expenses)
#let profit-val = calc-profit(cost, profit-rate)
#let price = calc-price(cost, profit-val)
#let vat = calc-vat(price, vat-rate)
#let price-vat = calc-price-with-vat(price, vat)

// --- Дисконтирование ---
#let E = calc-discount-rate(deposit-rate, risk-premium, inflation-rate)
#let investment = cost // инвестиции = себестоимость разработки

// ЧДД по годам (до налога, для накопленного графика)
#let npv-values = range(calc-years).map(t => {
  let rev = revenues.at(t) * 1000
  let opc = op-costs.at(t) * 1000
  let inv = if t == 0 { investment } else { 0 }
  npv-year(rev, opc, inv, E, t)
})

// ЧДД по годам после налога на прибыль
#let npv-after-tax = range(calc-years).map(t => {
  let rev = revenues.at(t) * 1000
  let opc = op-costs.at(t) * 1000
  let inv = if t == 0 { investment } else { 0 }
  npv-year-after-tax(rev, opc, inv, E, t, income-tax-rate)
})

// Налог на прибыль по годам
#let income-tax-values = range(calc-years).map(t => {
  let rev = revenues.at(t) * 1000
  let opc = op-costs.at(t) * 1000
  let inv = if t == 0 { investment } else { 0 }
  let profit-bt = rev - opc - inv
  if profit-bt > 0 { profit-bt * income-tax-rate } else { 0 }
})

// Накопленный ЧДД (после налога)
#let npv-cumulative = {
  let acc = 0
  let result = ()
  for v in npv-after-tax {
    acc = acc + v
    result = result + (acc,)
  }
  result
}

// Дисконтированные доходы и затраты для ИД
#let disc-rev-total = (
  range(calc-years).map(t => revenues.at(t) * 1000 * discount-coeff(E, t)).sum()
)

#let disc-cost-total = (
  range(calc-years)
    .map(t => {
      let opc = op-costs.at(t) * 1000
      let inv = if t == 0 { investment } else { 0 }
      (opc + inv) * discount-coeff(E, t)
    })
    .sum()
)

#let id-value = calc-id(disc-rev-total, disc-cost-total)
#let sr-value = calc-sr(id-value, calc-years)


= Экономическая часть

В данном разделе представлен анализ экономической обоснованности разработки среды выполнения
WASM-компонентов. Подсчитана оценка стоимости реализации, включающая эксплуатационные и
амортизационные расходы на оборудование и программное обеспечение, а также оплату труда
разработчика. Рассчитана предполагаемая прибыль от внедрения продукта и общий экономический эффект,
возможный при инвестициях в разработку.

== Калькуляция затрат на аппаратную часть разработки

Первоначальная оценка стоимости оборудования проводится с помощью калькуляции затрат, которая
включает расходы на основную зарплату, страховые взносы, накладные расходы и расходы на компьютерную
технику. В таблице~@table-hw-calc представлена детализация затрат на основании договорной стоимости
аппаратной части.

#figure(
  caption: [Калькуляция договорной цены аппаратной части],
  table(
    columns: (auto, 1fr, auto),
    stroke: 0.5pt,
    align: (center, left, right),
    table.header([*№*], [*Наименование статей затрат*], [*Затраты, руб.*]),
    [1], [Материалы (оборудование)], [#calc.round(hw-pc-cost)],
    [2], [Расходы на оплату труда], [#calc.round(hw-rot)],
    [3], [Страховые взносы (30~% от п.2)], [#calc.round(hw-insurance)],
    [4], [Накладные расходы (25~% от п.2)], [#calc.round(hw-overhead)],
    table.hline(),
    [], [*Итого себестоимость*], [*#calc.round(hw-cost)*],
    [], [Прибыль (20~% от себестоимости)], [#calc.round(hw-profit)],
    [], [*Договорная цена*], [*#calc.round(hw-price)*],
  ),
) <table-hw-calc>

Для реализации проекта необходим персональный компьютер с установленной операционной системой Fedora
Linux. Детализация расходов по статье «Материалы» приведена в таблице~@table-hw-materials.

#figure(
  caption: [Расходы на материалы (оборудование)],
  table(
    columns: (1fr, auto, auto),
    stroke: 0.5pt,
    align: (left, right, right),
    table.header([*Наименование*], [*Цена, руб.*], [*Сумма, руб.*]),
    [Персональный компьютер (ноутбук) для разработки],
    [#hw-pc-cost],
    [#hw-pc-cost],
    table.hline(),
    [*Итого*], [], [*#hw-pc-cost*],
  ),
) <table-hw-materials>

По статье «Расходы на оплату труда»: на закупку, настройку оборудования и развёртывание рабочего
окружения (установка Fedora Linux, Neovim, компилятора Rust и вспомогательного инструментария) было
затрачено #hw-setup-hours~часов при ставке #hw-setup-rate~руб./ч:

$ "РОТ" = #hw-setup-hours " ч" times #hw-setup-rate " руб./ч" = #rub(hw-rot) $

Страховые взносы (30~% от РОТ):

$ "СВ" = #rub(hw-rot) times 0.30 = #rub(hw-insurance) $

Накладные расходы (25~% от РОТ):

$ "НР" = #rub(hw-rot) times 0.25 = #rub(hw-overhead) $

Итоговая себестоимость аппаратной части:

$
  C = #hw-pc-cost + #calc.round(hw-rot) + #calc.round(hw-insurance) + #calc.round(hw-overhead)
  = #rub(hw-cost)
$

=== Расчёт сметной стоимости разработки программного средства

Калькуляция сметной стоимости разработки программного средства включает расходы на основную
зарплату, страховые взносы, накладные расходы и эксплуатационные расходы на ПК. Результаты
калькуляции приведены в таблице~@table-development-expenses.

#figure(
  caption: [Смета затрат на разработку ПС],
  table(
    columns: (auto, 1fr, auto),
    stroke: 0.5pt,
    align: (center, left, right),
    table.header([*№*], [*Статьи расходов*], [*Затраты, руб.*]),
    [1], [Основная заработная плата], [#calc.round(ozp)],
    [2], [Страховые взносы (30~% от п.1)], [#calc.round(insurance)],
    [3], [Накладные расходы (25~% от п.1)], [#calc.round(overhead)],
    [4],
    [Расходы на ПК (таблица~@table-pc-expenses)],
    [#calc.round(pc-expenses, digits: 2)],
    table.hline(),
    [5], [*Итого себестоимость разработки*], [*#calc.round(cost, digits: 2)*],
    [6], [Прибыль (20~% от п.5)], [#calc.round(profit-val, digits: 2)],
    [7], [Стоимость программы], [#calc.round(price, digits: 2)],
    [8], [НДС (20~% от п.7)], [#calc.round(vat, digits: 2)],
    [9], [*Стоимость с налогами*], [*#calc.round(price-vat, digits: 2)*],
  ),
) <table-development-expenses>

Основная заработная плата определяется исходя из почасовой ставки и суммарного времени разработки:

$
  T_"разр" = #dev-months " мес." times #dev-days-per-month " дн./мес." times
  #dev-hours-per-day " ч/дн." = #dev-hours " ч"
$

$ "ОЗП" = #dev-hours " ч" times #dev-hourly-rate " руб./ч" = #rub(ozp) $

Страховые взносы (30~% от ОЗП):

$ "СВ" = #rub(ozp) times 0.30 = #rub(insurance) $

Накладные расходы (25~% от ОЗП, норматив для лабораторий ПГУПС):

$ "НР" = #rub(ozp) times 0.25 = #rub(overhead) $

Расходы на ПК определяются эксплуатационными расходами за период разработки. В эксплуатационные
расходы входят расходы на электроэнергию, стоимость расходных материалов, расходы на ремонт,
заработная плата ремонтника, амортизационные затраты на ПК и ПО, а также дополнительные расходы.

*Расходы на электроэнергию* ($P = #pc-power-kw$ кВт, тариф #electricity-price~руб./кВт·ч по
одноставочному тарифу Комитета по тарифам Санкт-Петербурга):

$
  C_"эл" = P times "Ст" times T_"разр" =
  #pc-power-kw times #electricity-price times #dev-hours =
  #rub2(elec)
$

*Стоимость расходных материалов* (10~% от стоимости ПК за 3~года, пересчёт на срок разработки):

$
  C_"рм" = frac(#pc-cost times 0.10, 36) times #dev-months =
  #rub2(consumables)
$

*Расходы на ремонт* (10~% от стоимости ПК, пересчёт на срок разработки):

$ C_"комп" = frac(#pc-cost times 0.10, 36) times #dev-months = #rub2(repair) $

*Заработная плата инженера-системотехника* (на обслуживание 50~ПК требуется один специалист с
месячной ставкой #engineer-monthly~руб.):

$
  C_"рем" = frac([#engineer-monthly], 50) times #dev-months = #rub2(eng-salary)
$

*Амортизация ПК* (срок морального устаревания 3~года):

$ "АПК" = frac([#pc-cost], 36) times #dev-months = #rub2(apc) $

*Амортизация ПО:* используемые инструменты (Fedora~Linux, Neovim, компилятор Rust) распространяются
свободно --- $"АПО" = 0$~руб.

*Дополнительные расходы* (10~% от з/п инженера-системотехника в расчёте на 1~ПК):

$
  C_"доп" = frac([#engineer-monthly], 50) times #dev-months times 0.10 = #rub2(extra)
$

Суммарные эксплуатационные расходы на ПК представлены в таблице~@table-pc-expenses.

#figure(
  caption: [Эксплуатационные расходы на ПК в течение срока создания ПС],
  table(
    columns: (auto, 1fr, auto),
    stroke: 0.5pt,
    align: (center, left, right),
    table.header([*№*], [*Статья расхода*], [*Затраты, руб.*]),
    [1], [Расходы на электроэнергию], [#calc.round(elec, digits: 2)],
    [2],
    [Стоимость расходных материалов],
    [#calc.round(consumables, digits: 2)],
    [3], [Расходы на ремонт], [#calc.round(repair, digits: 2)],
    [4],
    [З/п инженера-системотехника (на 1~ПК)],
    [#calc.round(eng-salary, digits: 2)],
    [5], [Амортизация ПК], [#calc.round(apc, digits: 2)],
    [6], [Амортизация ПО], [0,00],
    [7], [Дополнительные расходы], [#calc.round(extra, digits: 2)],
    table.hline(),
    [],
    [*Итого эксплуатационные расходы на ПК*],
    [*#calc.round(pc-expenses, digits: 2)*],
  ),
) <table-pc-expenses>

Таким образом, себестоимость разработки среды выполнения WASM-компонентов составляет *#rub(cost)*, а
договорная цена с учётом НДС --- *#rub(price-vat)*.

== Обоснование экономической эффективности инвестиций в информационные проекты

Эффективность инвестиционного проекта представляет собой показатель, отражающий степень соответствия
проекта целям и ожиданиям его участников. Существует несколько форм проявления этой эффективности,
которые представлены в таблице~@table-efficiency-forms.

#figure(
  caption: [Формы эффективности инвестиционного проекта],
  table(
    columns: (1fr, 2fr),
    stroke: 0.5pt,
    align: (left, left),
    table.header([*Форма эффективности*], [*Описание*]),
    [Коммерческая эффективность],
    [Отражает финансовые результаты реализации проекта для его прямых участников. Определяется
      соотношением понесённых затрат и полученного экономического эффекта, обеспечивающего
      необходимый уровень прибыльности.],

    [Бюджетная эффективность],
    [Показывает, как реализация проекта влияет на финансовое состояние федерального, регионального
      или местного бюджета. Основным показателем является бюджетный эффект --- разница между
      доходами и расходами бюджета на каждом этапе проекта.],

    [Общественная (народнохозяйственная) эффективность],
    [Учитывает все затраты и результаты, возникающие в процессе реализации проекта и выходящие за
      рамки непосредственных финансовых интересов его участников.],
  ),
) <table-efficiency-forms>

В таблице~@table-project-indicators представлены основные показатели, используемые для оценки
эффективности инвестиционного проекта.

Экономический эффект от внедрения среды выполнения формируется по двум направлениям: сокращение
трудозатрат на интеграцию сервисов за счёт встраиваемого runtime-интерфейса, а также
коммерциализация решения через облачные FaaS-платформы и встраивание в инфраструктурные проекты
ПГУПС. В год~0 доходов нет --- ведётся разработка; с года~1 начинается внутреннее использование, с
года~3 --- постепенный выход на открытый рынок.

#{
  let years = range(calc-years).map(t => project-start-year + t)
  let inv-row = range(calc-years).map(t => if t == 0 {
    str(calc.round(investment / 1000, digits: 1))
  } else { "0" })
  let costs-row = range(calc-years).map(t => str(calc.round(
    op-costs.at(t) + (if t == 0 { calc.round(pc-expenses / 1000, digits: 1) } else { 0 }),
  )))
  let rev-row = revenues.map(v => str(v))
  [
    #figure(
      caption: [Основные показатели для определения эффективности инвестиционного проекта на #str(
          project-start-year,
        )--#str(project-start-year + calc-years - 1)~гг., тыс.~руб.],
      table(
        columns: (1.4fr, ..range(calc-years).map(_ => 1fr)),
        stroke: 0.5pt,
        align: (left, ..range(calc-years).map(_ => right)),
        fill: (col, row) => if row == 0 or col == 0 { luma(230) } else {
          white
        },
        [*Показатель*],
        ..years.map(y => strong(str(y))),
        [Инвестиционные вложения], ..inv-row,
        [Операц. затраты], ..op-costs.map(v => str(v)),
        [Доходы], ..rev-row,
        [Депозит, %],
        ..range(calc-years).map(_ => str(calc.round(
          deposit-rate * 100,
          digits: 0,
        ))),
        [Уровень риска, %],
        ..range(calc-years).map(_ => str(calc.round(
          risk-premium * 100,
          digits: 0,
        ))),
        [Инфляция, %],
        ..range(calc-years).map(_ => str(calc.round(
          inflation-rate * 100,
          digits: 0,
        ))),
      ),
    ) <table-project-indicators>
  ]
}

=== Расчёт чистого дисконтированного дохода

Дисконтирование позволяет учитывать стоимость денег во времени, оценивая затраты, результаты и
эффекты на протяжении расчётного периода с использованием нормы дисконта~$E$.

Норма дисконта рассчитывается по формуле:

$ E = a + b + c, $

где $a$ --- доходность альтернативных вложений (банковский депозит); $b$ --- уровень премии за риск;
$c$ --- уровень инфляции.

В качестве альтернативных вложений принят средний банковский депозитный процент 8~% годовых в
рублях. Уровень инфляции принят равным 4~% в соответствии с целевым ориентиром Банка России.

Премия за риск определяется по среднему классу инновации согласно морфологической таблице
@table-innovation-class.

#figure(
  caption: [Классификация нововведений и инновационных процессов по группам риска],
  table(
    columns: (auto, 1fr, 1.5fr, auto),
    stroke: 0.5pt,
    align: (center, left, left, center),
    table.header([*№*], [*Признак*], [*Значение*], [*Класс*]),
    [1], [По содержанию нововведения], [Новая технология (метод)], [6],
    [2], [Тип новатора (сфера создания)], [Образовательные учреждения], [7],
    [3], [Тип новатора (область знаний)], [Организация и управление], [4],
    [4],
    [Тип инноватора (сфера нововведения)],
    [Образовательные учреждения],
    [6],
    [5], [Уровень инноватора], [Подразделение вуза], [7],
    [6],
    [Территориальный масштаб],
    [Российская Федерация, ближнее зарубежье],
    [6],
    [7], [Масштаб распространения], [Единичная реализация], [5],
    [8],
    [Степень радикальности (новизны)],
    [Ординарные (новые разработки)],
    [4],
    [9], [Глубина преобразований инноватора], [Комплексные], [4],
    [10],
    [Причина появления (инициатива)],
    [Потребности образовательного процесса],
    [5],
    [11], [Этап ЖЦ спроса на новый продукт], [Ускорение роста], [3],
    [12], [Характер кривой ЖЦ товара], [Типовая, классическая кривая], [1],
    [13], [Этап ЖЦ товара (по типовой кривой)], [Рост], [4],
    [14], [Уровень изменчивости технологии], [«Плодотворная» технология], [5],
    [15], [Этап ЖЦ технологии], [Зарождение], [8],
    [16], [Этап ЖЦ организации-инноватора], [Становление], [6],
    [17],
    [Длительность инновационного процесса],
    [Долгосрочные (более 3~лет)],
    [8],
    table.hline(),
    [], [*Сумма строк*], [], [*89*],
  ),
) <table-innovation-class>

Средний класс инновации:

$ tilde(K) = frac(89, 17) approx 5.2 approx 5 $

По таблице~@table-risk-premium при $tilde(K) approx 5$ параметр $b = 10%$.

#figure(
  caption: [Соотношение среднего класса инновации и средней премии за риск],
  table(
    columns: (2fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    stroke: 0.5pt,
    align: center,
    table.header([*Средний класс*], [*1*], [*2*], [*3*], [*4*], [*5*], [*6*], [*7*], [*8*]),
    [Премия за риск, %], [0,0], [0,5], [1,0], [2,0], [5,0], [10,0], [20,0], [50,0],
  ),
) <table-risk-premium>

Таким образом, норма дисконта:

$
  E = a + b + c =
  #calc.round(deposit-rate * 100, digits: 0)% +
  #calc.round(risk-premium * 100, digits: 0)% +
  #calc.round(inflation-rate * 100, digits: 0)% =
  #calc.round(E * 100, digits: 0)%
$

Текущие затраты по периодам приведены в таблице~@table-current-costs.

#figure(
  caption: [Текущие затраты по периодам, тыс.~руб.],
  table(
    columns: (1.5fr, ..range(calc-years).map(_ => 1fr)),
    stroke: 0.5pt,
    align: (left, ..range(calc-years).map(_ => right)),
    fill: (col, row) => if row == 0 or col == 0 { luma(230) } else { white },
    [*Показатель*],
    ..range(calc-years).map(t => strong(str(project-start-year + t))),
    [Затраты], ..op-costs.map(v => str(v)),
  ),
) <table-current-costs>

Доходы, относящиеся к проекту, приведены в таблице~@table-revenues.


#figure(
  caption: [Доходы, относящиеся к проекту, тыс.~руб.],
  table(
    columns: (1.5fr, ..range(calc-years).map(_ => 1fr)),
    stroke: 0.5pt,
    align: (left, ..range(calc-years).map(_ => right)),
    fill: (col, row) => if row == 0 or col == 0 { luma(230) } else { white },
    [*Показатель*],
    ..range(calc-years).map(t => strong(str(project-start-year + t))),
    [Доходы], ..revenues.map(v => str(v)),
  ),
) <table-revenues>

На основании таблиц~@table-current-costs и~@table-revenues рассчитываются потоки денежных средств
проекта (таблица~@table-cashflow).

#{
  let outflow = range(calc-years).map(t => {
    let inv = if t == 0 { investment } else { 0 }
    calc.round((op-costs.at(t) * 1000 + inv) / 1000, digits: 1)
  })
  let inflow = revenues
  let total = range(calc-years).map(t => {
    let inv = if t == 0 { investment } else { 0 }
    calc.round(
      (revenues.at(t) * 1000 - op-costs.at(t) * 1000 - inv) / 1000,
      digits: 1,
    )
  })

  [
    #figure(
      caption: [Потоки денежных средств, тыс.~руб.],
      table(
        columns: (1.5fr, ..range(calc-years).map(_ => 1fr)),
        stroke: 0.5pt,
        align: (left, ..range(calc-years).map(_ => right)),
        fill: (col, row) => if row == 0 or col == 0 { luma(230) } else {
          white
        },
        [*Показатель*],
        ..range(calc-years).map(t => strong(str(project-start-year + t))),
        [Приток], ..inflow.map(v => str(v)),
        [Отток], ..outflow.map(v => str(v)),
        [*Итого*], ..total.map(v => strong(str(v))),
      ),
    ) <table-cashflow>
  ]
}

Графическое представление потоков денежных средств приведено на рисунке~@fig-cashflow.

#figure(
  caption: [Потоки денежных средств проекта],
  kind: image,
  cetz.canvas({
    let inflow-data = revenues.enumerate().map(((t, v)) => (t, v))
    let outflow-data = range(calc-years).map(t => {
      let inv = if t == 0 { investment / 1000 } else { 0 }
      (t, op-costs.at(t) + inv)
    })
    let net-data = range(calc-years).map(t => {
      let inv = if t == 0 { investment / 1000 } else { 0 }
      (t, revenues.at(t) - op-costs.at(t) - inv)
    })
    let all-y = (
      inflow-data.map(p => p.at(1)) + outflow-data.map(p => p.at(1)) + net-data.map(p => p.at(1))
    )
    let y-min = calc.min(..all-y)
    let y-max = calc.max(..all-y)

    plot.plot(
      size: (12, 6),
      x-label: [Год],
      x-min: 0,
      x-max: calc-years - 1,
      x-tick-step: 1,
      y-label: [тыс. руб.],
      y-min: calc.floor(y-min / 200) * 200,
      y-max: calc.ceil(y-max / 200) * 200,
      y-tick-step: 500,
      {
        plot.add(((0, 0), (calc-years - 1, 0)), style: (
          stroke: (paint: gray, dash: "dashed"),
        ))
        plot.add(
          inflow-data,
          mark: "o",
          mark-size: 0.12,
          style: (stroke: (paint: blue, thickness: 1.5pt)),
          label: [Приток],
        )
        plot.add(
          outflow-data,
          mark: "square",
          mark-size: 0.12,
          style: (stroke: (paint: red, thickness: 1.5pt)),
          label: [Отток],
        )
        plot.add(
          net-data,
          mark: "triangle",
          mark-size: 0.12,
          style: (stroke: (paint: green, thickness: 1.5pt)),
          label: [Итого],
        )
      },
    )
  }),
) <fig-cashflow>

Чистый дисконтированный доход (ЧДД) определяется как разница между накопленным дисконтированным
доходом от реализации проекта и дисконтированными единовременными затратами на внедрение. Для его
расчёта используется формула:

$ "ЧДД" = sum_(t=0)^(T) (R_t - З_t) times frac(1, (1 + E)^t), $

где $R_t$ --- результаты в году~$t$; $З_t$ --- затраты и инвестиции в году~$t$; $E$ --- норма
дисконта; $1 \/ (1+E)^t$ --- коэффициент дисконтирования. Если ЧДД положителен, проект считается
эффективным.

Результаты расчёта ЧДД по годам приведены в таблице~@table-npv.

#{
  // затраты на проект = инвест + операц
  let total-costs = range(calc-years).map(t => {
    let inv = if t == 0 { investment / 1000 } else { 0 }
    op-costs.at(t) + inv
  })
  // прибыль до налога (тыс. руб.)
  let profit-bt = range(calc-years).map(t => {
    revenues.at(t) - total-costs.at(t)
  })
  // налог (тыс. руб.)
  let tax = profit-bt.map(p => if p > 0 {
    calc.round(p * income-tax-rate, digits: 1)
  } else { 0 })
  // коэффициент дисконтирования
  let dc = range(calc-years).map(t => calc.round(
    discount-coeff(E, t),
    digits: 3,
  ))
  // ЧДД года (после налога, тыс. руб.)
  let npv-y = range(calc-years).map(t => {
    let p = profit-bt.at(t)
    let ta = if p > 0 { p * income-tax-rate } else { 0 }
    calc.round((p - ta) * discount-coeff(E, t), digits: 1)
  })
  // накопленный ЧДД
  let cum = {
    let acc = 0
    let r = ()
    for v in npv-y {
      acc = acc + v
      r = r + (calc.round(acc, digits: 1),)
    }
    r
  }
  let inv-row = range(calc-years).map(t => if t == 0 {
    str(calc.round(investment / 1000, digits: 1))
  } else { "0" })
  let ycols = range(calc-years).map(t => strong(str(project-start-year + t)))

  [
    #figure(
      caption: [Расчёт ЧДД при норме дисконта #calc.round(E * 100, digits: 0)~%, тыс.~руб.],
      table(
        columns: (1.6fr, ..range(calc-years).map(_ => 1fr), 1fr),
        stroke: 0.5pt,
        align: (left, ..range(calc-years + 1).map(_ => right)),
        fill: (col, row) => if row == 0 or col == 0 { luma(230) } else {
          white
        },
        [*Показатель*], ..ycols, [*Всего*],
        [Инвестиц. вложения], ..inv-row,
        [#str(calc.round(investment / 1000, digits: 1))],
        [Текущие затраты], ..op-costs.map(v => str(v)),
        [#str(op-costs.sum())],
        [Затраты на проект],
        ..total-costs.map(v => str(calc.round(v, digits: 1))),
        [#str(calc.round(total-costs.sum(), digits: 1))],
        [Доход], ..revenues.map(v => str(v)),
        [#str(revenues.sum())],
        [Прибыль], ..profit-bt.map(v => str(calc.round(v, digits: 1))),
        [#str(calc.round(profit-bt.sum(), digits: 1))],
        [Налог на прибыль (20~%)], ..tax.map(v => str(v)),
        [#str(calc.round(tax.sum(), digits: 1))],
        [Коэф. дисконтирования], ..dc.map(v => str(v)), [---],
        [ЧДД], ..npv-y.map(v => str(v)),
        [#str(calc.round(npv-y.sum(), digits: 1))],
        [ЧДД нараст. итогом], ..cum.map(v => str(v)), [---],
      ),
    ) <table-npv>
  ]
}

#{
  // Найдём срок окупаемости
  let t-minus = 0
  let npv-minus = 0.0
  let npv-plus = 0.0
  // Строим накопленный ЧДД после налога
  let cum-vals = {
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
  for (i, v) in cum-vals.enumerate() {
    if v < 0 {
      t-minus = i
      npv-minus = v
    }
  }
  npv-plus = cum-vals.at(t-minus + 1)
  let tok = t-minus + 1 - npv-minus / (npv-plus - npv-minus)
  let tok-r = calc.round(tok, digits: 1)

  [
    Как видно из таблицы~@table-npv, ЧДД нарастающим итогом принимает положительное значение начиная
    с *#str(project-start-year + t-minus + 1)~г.*, что подтверждает экономическую эффективность
    проекта. Графическое представление динамики накопленного ЧДД и срока окупаемости приведено на
    рисунке~@fig-npv-chart.

    #figure(
      caption: [ЧДД и срок окупаемости при норме дисконта #calc.round(E * 100, digits: 0)~%],
      kind: image,
      cetz.canvas({
        let data = cum-vals.enumerate().map(((t, v)) => (t, v / 1000))
        let y-min = calc.min(..data.map(p => p.at(1)))
        let y-max = calc.max(..data.map(p => p.at(1)))
        plot.plot(
          size: (12, 6),
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
    ) <fig-npv-chart>

    === Срок окупаемости

    Срок окупаемости определяется методом приближённой оценки:

    $ T_"ок" approx t_- - frac("ЧДД"_-, "ЧДД"_+ - "ЧДД"_-) $

    Последний отрицательный накопленный ЧДД:
    $#str(calc.round(npv-minus / 1000, digits: 1))$~тыс.~руб. (#str(
      project-start-year + t-minus,
    )~г.), первый положительный: $#str(calc.round(npv-plus / 1000, digits: 1))$~тыс.~руб. (#str(
      project-start-year + t-minus + 1,
    )~г.).

    $
      T_"ок" approx #str(t-minus) -
      frac(
        #str(calc.round(npv-minus / 1000, digits: 1)),
        #str(calc.round(npv-plus / 1000, digits: 1)) - (#str(calc.round(npv-minus / 1000, digits: 1)))
      ) approx #tok-r " лет"
    $

    Таким образом, проект окупается приблизительно за *#tok-r~лет*, что не превышает срока
    расчётного периода и подтверждает его экономическую эффективность.
  ]
}

=== Индекс доходности и среднегодовая рентабельность

Индекс доходности (ИД) --- отношение суммарного дисконтированного дохода к суммарным
дисконтированным затратам:

$
  "ИД" =
  frac(
    sum_(t=0)^(n) frac(D_t, (1+E)^t),
    sum_(t=0)^(n) frac(R_t, (1+E)^t)
  ) =
  frac(
    #str(calc.round(disc-rev-total / 1000, digits: 1)) " тыс. руб.",
    #str(calc.round(disc-cost-total / 1000, digits: 1)) " тыс. руб."
  ) =
  #str(calc.round(id-value, digits: 2))
$

Поскольку ИД $> 1$, проект является экономически эффективным.

Среднегодовая рентабельность показывает, какой доход приносит вложенная в проект единица инвестиций:

$
  "СР" = frac("ИД" - 1, n) times 100% =
  frac(#str(calc.round(id-value, digits: 2)) - 1, [#calc-years]) times 100% approx
  #str(calc.round(sr-value, digits: 1))%
$

Критерием экономической эффективности является положительная рентабельность проекта.

=== Выводы

В результате технико-экономического обоснования разработки среды выполнения WASM-компонентов
получены следующие основные показатели:

- себестоимость разработки --- *#rub(cost)*;
- договорная цена с учётом НДС --- *#rub(price-vat)*;
- норма дисконта --- *#calc.round(E * 100, digits: 0)~%*;
- итоговый ЧДД --- *#str(calc.round(npv-cumulative.last() / 1000, digits: 1))~тыс.~руб.*
  (положительный);
- индекс доходности --- *#str(calc.round(id-value, digits: 2))* (больше~1);
- среднегодовая рентабельность --- *#str(calc.round(sr-value, digits: 1))~%*.

Все показатели удовлетворяют критериям экономической эффективности. Разработка среды выполнения
WASM-компонентов является целесообразной как с технической, так и с экономической точки зрения.
