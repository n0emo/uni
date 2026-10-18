module Requests

open System

type CreateLink = { Target: string }

module Target =
    let private maxLength = 2048

    /// Turns user input into an absolute http(s) URL, assuming https:// when no scheme is given.
    let normalize (raw: string) : Result<string, string> =
        if String.IsNullOrWhiteSpace raw then
            Error "Target URL is required"
        else
            let trimmed = raw.Trim()

            let withScheme =
                if trimmed.Contains "://" then trimmed else $"https://{trimmed}"

            match Uri.TryCreate(withScheme, UriKind.Absolute) with
            | true, uri when
                (uri.Scheme = Uri.UriSchemeHttp || uri.Scheme = Uri.UriSchemeHttps)
                && uri.Host <> ""
                && uri.AbsoluteUri.Length <= maxLength
                ->
                Ok uri.AbsoluteUri
            | _ -> Error "Target must be a valid http(s) URL"
