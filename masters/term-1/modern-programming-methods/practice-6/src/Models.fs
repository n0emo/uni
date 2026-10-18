module Models

open MathNet.Numerics.LinearAlgebra
open MathNet.Numerics.LinearRegression
open MathNet.Numerics.Optimization
open Data

[<Measure>]
type year

let period = 12

let mae (actual: float<degC>[]) forecast =
    Array.map2 (fun a f -> abs (a - f)) actual forecast |> Array.average

let rmse (actual: float<degC>[]) forecast =
    Array.map2 (fun a f -> (a - f) * (a - f)) actual forecast |> Array.average |> sqrt

/// Repeats the last observed year.
let seasonalNaive (train: float<degC>[]) horizon =
    Array.init horizon (fun h -> train[train.Length - period + h % period])

/// y = a_m + b t: a mean per calendar month plus a linear trend.
type Regression =
    {
        Months: float<degC>[]
        Trend: float<degC / year>
    }

let private years t = float t / float period * 1.0<year>

let fitRegression (train: float<degC>[]) =
    let x =
        Array.init train.Length (fun t ->
            [| yield float (years t); for m in 0 .. period - 1 -> if t % period = m then 1.0 else 0.0 |])

    let c = MultipleRegression.QR(x, Array.map float train)

    {
        Trend = c[0] * 1.0<degC / year>
        Months = c[1..] |> Array.map ((*) 1.0<degC>)
    }

let predictRegression r start horizon =
    Array.init horizon (fun h ->
        let t = start + h
        r.Months[t % period] + r.Trend * years t)

/// Smoothing constants of the additive Holt-Winters model.
type HoltWinters = { Alpha: float; Beta: float; Gamma: float }

/// Runs the recursion over the series; returns the sum of squared one-step errors
/// and the h-step forecast from the last observation.
let private holtWinters p (y: float<degC>[]) =
    let first = y[.. 3 * period - 1]
    let mutable level = Array.average first
    let mutable trend = 0.0<degC>

    let seasonal =
        Array.init period (fun m -> (Array.averageBy (fun k -> first[k * period + m]) [| 0..2 |]) - level)

    let mutable sse = 0.0<degC^2>

    for t in 0 .. y.Length - 1 do
        let m = t % period
        let error = y[t] - (level + trend + seasonal[m])
        sse <- sse + error * error
        let previous = level
        level <- p.Alpha * (y[t] - seasonal[m]) + (1.0 - p.Alpha) * (level + trend)
        trend <- p.Beta * (level - previous) + (1.0 - p.Beta) * trend
        seasonal[m] <- p.Gamma * (y[t] - level) + (1.0 - p.Gamma) * seasonal[m]

    sse, fun h -> level + float h * trend + seasonal[(y.Length + h - 1) % period]

/// Chooses the constants that minimise the one-step error on the training series.
let fitHoltWinters train =
    // The logistic function keeps every constant within (0, 1).
    let ofVector (v: Vector<float>) =
        let logistic x = 1.0 / (1.0 + exp -x)
        { Alpha = logistic v[0]; Beta = logistic v[1]; Gamma = logistic v[2] }

    let objective = ObjectiveFunction.Value(fun v -> float (fst (holtWinters (ofVector v) train)))
    let result = NelderMeadSimplex(1e-10, 10000).FindMinimum(objective, Vector.Build.Dense 3)
    ofVector result.MinimizingPoint

let predictHoltWinters p train horizon =
    let _, forecast = holtWinters p train
    Array.init horizon (fun h -> forecast (h + 1))
