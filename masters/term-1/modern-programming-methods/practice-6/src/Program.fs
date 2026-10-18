open System
open System.IO
open ScottPlot
open Data
open Models

let series = monthly (Path.Combine(AppContext.BaseDirectory, "data", "spb-daily.csv"))
let horizon = 3 * period
let dates = series |> Array.map fst
let values = series |> Array.map snd
let train, test = values[.. values.Length - horizon - 1], values[values.Length - horizon ..]

printfn $"Ряд: {dates[0]:``yyyy-MM``} – {Array.last dates:``yyyy-MM``}, {values.Length} мес."
printfn $"Обучение: {train.Length} мес., тест: {test.Length} мес. (с {dates[train.Length]:``yyyy-MM``})"

let regression = fitRegression train
let holtWinters = fitHoltWinters train

let residual = rmse train (predictRegression regression 0 train.Length)

printfn $"Регрессия: тренд {float regression.Trend * 10.0:F2} °C/10 лет, СКО остатков {float residual:F2} °C"
printfn $"Хольт-Уинтерс: α = {holtWinters.Alpha:F3}, β = {holtWinters.Beta:F4}, γ = {holtWinters.Gamma:F3}"

let forecasts =
    [
        "Сезонный наивный", seasonalNaive train horizon
        "Регрессия", predictRegression regression train.Length horizon
        "Хольт-Уинтерс", predictHoltWinters holtWinters train horizon
    ]

printfn "\n%-18s %8s %8s" "Модель" "MAE, °C" "RMSE, °C"

for name, forecast in forecasts do
    printfn "%-18s %8.2f %8.2f" name (float (mae test forecast)) (float (rmse test forecast))

let plot () =
    use plt = new Plot()
    let shown = values.Length - 2 * horizon
    let x (d: DateOnly) = d.ToDateTime(TimeOnly.MinValue)

    let actual = plt.Add.Scatter(dates[shown..] |> Array.map x, values[shown..] |> Array.map float)
    actual.LegendText <- "Факт"
    actual.Color <- Colors.Black
    actual.LineWidth <- 2f

    for name, forecast in forecasts do
        let line = plt.Add.Scatter(dates[train.Length ..] |> Array.map x, forecast |> Array.map float)
        line.LegendText <- name
        line.MarkerSize <- 0f
        line.LineWidth <- 1.5f

    let split = plt.Add.VerticalLine((x dates[train.Length]).ToOADate())
    split.LinePattern <- LinePattern.Dashed
    plt.Axes.DateTimeTicksBottom() |> ignore
    plt.YLabel "Средняя температура месяца, °C"
    plt.ShowLegend(Edge.Bottom) |> ignore
    plt.Font.Automatic()
    plt.SavePng("out/forecast.png", 900, 500) |> ignore

Directory.CreateDirectory "out" |> ignore
plot ()
printfn "\nГрафик сохранён в out/forecast.png"
