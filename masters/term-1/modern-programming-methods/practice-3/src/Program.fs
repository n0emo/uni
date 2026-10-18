open System
open System.Diagnostics
open System.IO
open System.Text.Encodings.Web
open System.Text.Json
open System.Threading.Tasks
open Spectre.Console

type Result =
    {
        Language: LanguageTool.Report
        Analysis: Pollinations.Analysis
        LanguageToolMs: int64
        ModelMs: int64
        ModelAttempts: int
    }

type Sample =
    {
        Id: int
        Title: string
        Expected: string
        Text: string
    }

type SampleResult = { Sample: Sample; Result: Result }

let jsonOptions =
    JsonSerializerOptions(
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        Encoder = JavaScriptEncoder.UnsafeRelaxedJsonEscaping,
        WriteIndented = true
    )

let timed (call: unit -> Task<'T>) =
    task {
        let watch = Stopwatch.StartNew()
        let! value, attempts = Http.retry 4 call
        return value, watch.ElapsedMilliseconds, attempts
    }

/// Both services are independent, so they are queried in parallel.
let analyze (text: string) =
    task {
        let languageTool = timed (fun () -> LanguageTool.check text)
        let model = timed (fun () -> Pollinations.analyze text)
        let! language, languageMs, _ = languageTool
        let! analysis, modelMs, modelAttempts = model

        return
            {
                Language = language
                Analysis = analysis
                LanguageToolMs = languageMs
                ModelMs = modelMs
                ModelAttempts = modelAttempts
            }
    }

let sentimentNames =
    Map
        [
            "positive", "[green]положительная[/]"
            "negative", "[red]отрицательная[/]"
            "neutral", "[grey]нейтральная[/]"
            "mixed", "[yellow]смешанная[/]"
        ]

let esc (s: string) = Markup.Escape s
let signed (x: float) = x.ToString "+0.00;-0.00;0.00"

let show (r: Result) =
    let a = r.Analysis
    let l = r.Language

    let summary =
        Grid()
            .AddColumn()
            .AddColumn()
            .AddRow("[bold]Язык[/]", $"{esc l.Language} ({l.Confidence:P0})")
            .AddRow("[bold]Тональность[/]", $"{sentimentNames[a.Sentiment]}, {signed a.Score}")
            .AddRow("[bold]Ключевые слова[/]", esc (String.Join(", ", a.Keywords)))
            .AddRow("[bold]Кратко[/]", esc a.Summary)
            .AddRow("[bold]Время ответа[/]", $"LanguageTool {r.LanguageToolMs} мс, {esc a.Model} {r.ModelMs} мс")

    AnsiConsole.Write(Panel(summary).Header("Результат анализа"))

    if a.Entities.Length > 0 then
        let table = Table().AddColumns("Сущность", "Тип")

        for e in a.Entities do
            table.AddRow(esc e.Name, e.Type) |> ignore

        AnsiConsole.Write table

    if l.Issues.Length > 0 then
        let table = Table().AddColumns("Фрагмент", "Тип", "Замечание", "Варианты")

        for i in l.Issues do
            table.AddRow(esc i.Fragment, i.Kind, esc i.Message, esc (String.Join(", ", i.Suggestions)))
            |> ignore

        AnsiConsole.Write table

let runSamples () =
    let samples =
        JsonSerializer.Deserialize<Sample[]>(File.ReadAllText "data/samples.json", jsonOptions)

    let results =
        [|
            for s in samples do
                let r =
                    AnsiConsole
                        .Status()
                        .Start($"Анализ {s.Id}/{samples.Length}: {esc s.Title}", fun _ -> (analyze s.Text).Result)

                { Sample = s; Result = r }
        |]

    let table =
        Table().AddColumns("№", "Текст", "Язык", "Ожидается", "Получено", "Оценка", "Замечаний", "Время, с")

    for { Sample = s; Result = r } in results do
        let a = r.Analysis
        let mark = if a.Sentiment = s.Expected then "" else " [red]✗[/]"

        table.AddRow(
            string s.Id,
            esc s.Title,
            r.Language.LanguageCode,
            sentimentNames[s.Expected],
            sentimentNames[a.Sentiment] + mark,
            $"{signed a.Score}",
            string r.Language.Issues.Length,
            $"{float r.ModelMs / 1000.0:F1}"
        )
        |> ignore

    AnsiConsole.Write table

    let hits = results |> Array.filter (fun x -> x.Result.Analysis.Sentiment = x.Sample.Expected)
    let mean f = results |> Array.averageBy (fun x -> float (f x.Result))
    AnsiConsole.MarkupLine $"Тональность определена верно: {hits.Length} из {results.Length}"
    AnsiConsole.MarkupLine $"Среднее время ответа: LanguageTool {mean _.LanguageToolMs:F0} мс, модель {mean _.ModelMs:F0} мс"
    AnsiConsole.MarkupLine $"Повторных запросов к модели: {results |> Array.sumBy (fun x -> x.Result.ModelAttempts - 1)}"

    File.WriteAllText("results.json", JsonSerializer.Serialize(results, jsonOptions))
    AnsiConsole.MarkupLine "Подробные результаты сохранены в [blue]results.json[/]"

[<EntryPoint>]
let main argv =
    Console.OutputEncoding <- Text.Encoding.UTF8

    match argv with
    | [||] -> runSamples ()
    | [| "-" |] -> show (analyze(Console.In.ReadToEnd()).Result)
    | [| "-f"; path |] -> show (analyze(File.ReadAllText path).Result)
    | words -> show (analyze(String.Join(" ", words)).Result)

    0
