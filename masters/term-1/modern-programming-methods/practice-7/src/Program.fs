open System
open System.Globalization
open System.IO
open Spectre.Console
open Model

CultureInfo.CurrentCulture <- CultureInfo.InvariantCulture

let ask (label: string) (defaultValue: 'T) (valid: 'T -> bool) =
    TextPrompt<'T>(label)
        .DefaultValue(defaultValue)
        .Validate(fun v -> if valid v then ValidationResult.Success() else ValidationResult.Error "Недопустимое значение")
    |> AnsiConsole.Prompt

let inline positive v = v > LanguagePrimitives.GenericZero
let inline nonNegative v = v >= LanguagePrimitives.GenericZero

AnsiConsole.Write(Rule "[bold]СППР: управление запасами[/]")

let p =
    {
        DemandMean = ask "Средний спрос, ед./день" 20.0<item / day> positive
        DemandStd = ask "Стандартное отклонение дневного спроса, ед." 6.0<item> nonNegative
        LeadTime = ask "Срок поставки, дней" 5<day> positive
        OrderCost = ask "Стоимость заказа, руб." 1500.0<rub> positive
        HoldingCost = ask "Хранение единицы, руб./день" 2.0<rub / (item day)> positive
        ShortageCost = ask "Потеря продажи, руб./ед." 60.0<rub / item> positive
        Horizon = ask "Горизонт моделирования, дней" 365<day> (fun v -> v >= 30<day>)
        Replications = ask "Число прогонов" 200 positive
    }

let scenarioSet, evaluations =
    AnsiConsole
        .Status()
        .Start(
            "Моделирование...",
            Func<_, _>(fun _ ->
                let s = scenarios p
                s, search p s)
        )

let ranked = evaluations |> Array.sortBy (snd >> _.Total)
let best, bestCosts = ranked[0]
let baseline = classical p 1.645
let baselineCosts = evaluate p scenarioSet baseline

let alternatives =
    [
        for i, e in Array.indexed ranked[..4] do
            $"#{i + 1}", e
        "EOQ, 95 %", (baseline, baselineCosts)
    ]

let table =
    Table()
        .AddColumns("Политика", "s", "Q", "Заказы", "Хранение", "Дефицит", "Итого", "Обслуживание")

for name, (policy, c) in alternatives do
    table.AddRow(
        name,
        string policy.ReorderPoint,
        string policy.OrderQuantity,
        $"{c.Ordering:F1}",
        $"{c.Holding:F1}",
        $"{c.Shortage:F1}",
        $"{c.Total:F1}",
        $"{c.FillRate:P1}"
    )
    |> ignore

AnsiConsole.Write(table.Caption "Средние издержки, руб./день")

// Cost structure of the recommended and the classical policies.
for name, (_, c) in [ List.head alternatives; List.last alternatives ] do
    let share (v: float<rub / day>) = Math.Round(100.0 * v / c.Total, 1)
    AnsiConsole.MarkupLine $"[bold]{name}[/]"

    BreakdownChart()
        .Width(76)
        .ShowPercentage()
        .AddItem("Заказы", share c.Ordering, Color.Blue)
        .AddItem("Хранение", share c.Holding, Color.Green)
        .AddItem("Дефицит", share c.Shortage, Color.Red)
    |> AnsiConsole.Write

let saving = 100.0 * (1.0 - bestCosts.Total / baselineCosts.Total)

Panel(
    $"Заказывать [bold]{best.OrderQuantity}[/] ед., когда запас с учётом заказанного опускается до "
    + $"[bold]{best.ReorderPoint}[/] ед.\nОжидаемые издержки {bestCosts.Total:F1} руб./день, "
    + $"на {saving:F1} %% меньше классической политики.\nУровень обслуживания {bestCosts.FillRate:P1}."
)
    .Header("Рекомендация")
|> AnsiConsole.Write

Directory.CreateDirectory "out" |> ignore
Charts.costs evaluations best "out/costs.png"
Charts.stock (simulate p best scenarioSet[0] |> snd) best (min 120 (int p.Horizon)) "out/stock.png"
AnsiConsole.MarkupLine "Графики сохранены в [blue]out/costs.png[/] и [blue]out/stock.png[/]"
