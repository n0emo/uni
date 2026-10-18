module Http

open System
open System.Net.Http
open System.Text.Json
open System.Threading.Tasks

let client =
    let http = new HttpClient(Timeout = TimeSpan.FromSeconds 60.0)
    http.DefaultRequestHeaders.UserAgent.ParseAdd "TextAnalyzer/1.0 (university lab)"
    http

/// The server asked to wait before the next request (Retry-After).
exception RateLimited of TimeSpan

/// Public endpoints without keys are rate limited and occasionally time out,
/// and the model may return malformed JSON, so every call gets a few attempts.
/// Returns the value and the number of attempts it took.
let retry (attempts: int) (call: unit -> Task<'T>) =
    let rec loop attempt =
        task {
            try
                let! value = call ()
                return value, attempt
            with
            | RateLimited delay when attempt < attempts ->
                eprintfn $"Attempt {attempt}: rate limited, waiting {delay.TotalSeconds} s"
                do! Task.Delay(delay + TimeSpan.FromSeconds 1.0)
                return! loop (attempt + 1)
            | :? HttpRequestException
            | :? TaskCanceledException
            | :? JsonException
            | :? InvalidOperationException
            | :? Collections.Generic.KeyNotFoundException as e when attempt < attempts ->
                eprintfn $"Attempt {attempt} failed: {e.GetType().Name}: {e.Message}"
                do! Task.Delay(TimeSpan.FromSeconds(5.0 * float attempt))
                return! loop (attempt + 1)
        }

    loop 1
