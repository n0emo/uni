module Model

open System

[<Measure>]
type item

[<Measure>]
type day

[<Measure>]
type rub

type Parameters =
    {
        DemandMean: float<item / day>
        /// Standard deviation of a single day's demand.
        DemandStd: float<item>
        LeadTime: int<day>
        OrderCost: float<rub>
        HoldingCost: float<rub / (item day)>
        ShortageCost: float<rub / item>
        Horizon: int<day>
        Replications: int
    }

/// (s, Q) policy: order Q units whenever the inventory position falls to s or below.
type Policy =
    {
        ReorderPoint: int<item>
        OrderQuantity: int<item>
    }

/// Average costs per day and the share of demand served from stock.
type Costs =
    {
        Ordering: float<rub / day>
        Holding: float<rub / day>
        Shortage: float<rub / day>
        FillRate: float
    }

    member c.Total = c.Ordering + c.Holding + c.Shortage

let private items (x: float<item>) = int (round (float x)) * 1<item>
let private toFloat (x: int<item>) = float x * 1.0<item>

let eoq p =
    sqrt (2.0 * p.DemandMean * p.OrderCost / p.HoldingCost)

let leadTimeDemand p = p.DemandMean * float p.LeadTime * 1.0<day>
let leadTimeStd p = p.DemandStd * sqrt (float p.LeadTime)

/// The textbook policy: EOQ with a safety stock covering demand at the service level z.
let classical p z =
    {
        ReorderPoint = items (leadTimeDemand p + z * leadTimeStd p)
        OrderQuantity = items (eoq p)
    }

/// Daily demand drawn from a normal distribution, truncated at zero.
let demands p (seed: int) =
    let rng = Random seed

    Array.init (int p.Horizon) (fun _ ->
        let z = sqrt (-2.0 * log (1.0 - rng.NextDouble ())) * cos (2.0 * Math.PI * rng.NextDouble ())
        max 0<item> (items (p.DemandMean * 1.0<day> + p.DemandStd * z)))

/// Runs the policy over one demand scenario; returns the costs and the end-of-day stock.
let simulate p policy (demand: int<item>[]) =
    let arrivals: int<item>[] = Array.zeroCreate (demand.Length + int p.LeadTime + 1)
    let stock: int<item>[] = Array.zeroCreate demand.Length
    let mutable onHand = policy.ReorderPoint + policy.OrderQuantity
    let mutable onOrder = 0<item>
    let mutable orders = 0
    let mutable lost = 0<item>

    for day in 0 .. demand.Length - 1 do
        onHand <- onHand + arrivals[day]
        onOrder <- onOrder - arrivals[day]
        let sold = min onHand demand[day]
        onHand <- onHand - sold
        lost <- lost + demand[day] - sold

        // An order placed at the end of a day arrives after LeadTime full days.
        let arrival = day + int p.LeadTime + 1

        while onHand + onOrder <= policy.ReorderPoint do
            arrivals[arrival] <- arrivals[arrival] + policy.OrderQuantity
            onOrder <- onOrder + policy.OrderQuantity
            orders <- orders + 1

        stock[day] <- onHand

    let horizon = float demand.Length * 1.0<day>

    {
        Ordering = float orders * p.OrderCost / horizon
        // Each day's stock is held for one day.
        Holding = toFloat (Array.sum stock) * 1.0<day> * p.HoldingCost / horizon
        Shortage = toFloat lost * p.ShortageCost / horizon
        FillRate = 1.0 - toFloat lost / toFloat (max 1<item> (Array.sum demand))
    },
    stock

/// Averages the costs over all scenarios; the same scenarios are used for every policy.
let evaluate p (scenarios: int<item>[][]) policy =
    let runs = scenarios |> Array.map (simulate p policy >> fst)

    {
        Ordering = runs |> Array.averageBy _.Ordering
        Holding = runs |> Array.averageBy _.Holding
        Shortage = runs |> Array.averageBy _.Shortage
        FillRate = runs |> Array.averageBy _.FillRate
    }

let scenarios p = Array.init p.Replications (demands p)

/// Evaluates a grid of policies around the classical one: Q from 0.5 to 2 EOQ,
/// s from two standard deviations of lead-time demand below its mean to four above.
let search p scenarios =
    let quantities =
        [| for k in 0..15 -> max 1<item> (items (eoq p * (0.5 + 0.1 * float k))) |] |> Array.distinct

    let reorderPoints =
        [| for k in -8..16 -> max 0<item> (items (leadTimeDemand p + 0.25 * float k * leadTimeStd p)) |]
        |> Array.distinct

    [|
        for s in reorderPoints do
            for q in quantities -> { ReorderPoint = s; OrderQuantity = q }
    |]
    |> Array.Parallel.map (fun policy -> policy, evaluate p scenarios policy)
