module Data

open System
open System.Globalization
open System.IO

[<Measure>]
type degC

/// Monthly mean temperatures from an Open-Meteo daily CSV export, starting in January.
let monthly path =
    File.ReadLines path
    |> Seq.skip 4
    |> Seq.map (fun line ->
        let fields = line.Split ','
        DateOnly.ParseExact(fields[0], "yyyy-MM-dd"), Double.Parse(fields[1], CultureInfo.InvariantCulture))
    |> Seq.groupBy (fun (date, _) -> DateOnly(date.Year, date.Month, 1))
    |> Seq.map (fun (month, days) -> month, Seq.averageBy snd days * 1.0<degC>)
    |> Seq.toArray
