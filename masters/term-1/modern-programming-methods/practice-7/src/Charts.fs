module Charts

open ScottPlot
open Model

let private save (plt: Plot) (path: string) =
    plt.Font.Automatic()
    plt.SavePng(path, 900, 500) |> ignore

/// Average daily cost against Q for several reorder points, with the best policy marked.
let costs (evaluations: (Policy * Costs)[]) (best: Policy) path =
    use plt = new Plot()
    let reorderPoints = evaluations |> Array.map (fst >> _.ReorderPoint) |> Array.distinct

    let shown =
        reorderPoints
        |> Array.indexed
        |> Array.filter (fun (i, s) -> i % 4 = 0 || s = best.ReorderPoint)
        |> Array.map snd

    for s in shown do
        let row = evaluations |> Array.filter (fun (p, _) -> p.ReorderPoint = s)
        let line =
            plt.Add.Scatter(
                row |> Array.map (fun (p, _) -> float p.OrderQuantity),
                row |> Array.map (fun (_, c) -> float c.Total)
            )
        line.LegendText <- $"s = {s}"

    let bestCosts = evaluations |> Array.find (fst >> (=) best) |> snd
    let marker = plt.Add.Marker(float best.OrderQuantity, float bestCosts.Total, MarkerShape.FilledCircle, 12f)
    marker.Color <- Colors.Red
    marker.LegendText <- "Рекомендация"

    plt.XLabel "Размер заказа Q, ед."
    plt.YLabel "Средние издержки, руб./день"
    plt.ShowLegend(Alignment.UpperCenter) |> ignore
    save plt path

/// End-of-day stock over the first days of one scenario.
let stock (stock: int<item>[]) (policy: Policy) days path =
    use plt = new Plot()
    let xs = Array.init days float
    let line = plt.Add.Scatter(xs, stock[.. days - 1] |> Array.map float)
    line.ConnectStyle <- ConnectStyle.StepVertical
    line.MarkerSize <- 0f
    line.LegendText <- "Запас на складе"

    let reorder = plt.Add.HorizontalLine(float policy.ReorderPoint)
    reorder.LinePattern <- LinePattern.Dashed
    reorder.LegendText <- $"Точка заказа s = {policy.ReorderPoint}"

    plt.XLabel "День"
    plt.YLabel "Запас, ед."
    plt.ShowLegend(Alignment.UpperRight) |> ignore
    save plt path
