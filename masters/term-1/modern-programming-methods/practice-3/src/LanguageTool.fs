/// Language detection and grammar checking through the public LanguageTool API
/// (no key, up to 20 requests per minute).
module LanguageTool

open System.Net.Http
open System.Text.Json

type Issue =
    {
        /// LanguageTool issue type: misspelling, grammar, typographical, style...
        Kind: string
        Message: string
        Fragment: string
        Suggestions: string[]
    }

type Report =
    {
        Language: string
        LanguageCode: string
        Confidence: float
        Issues: Issue[]
    }

let private endpoint = "https://api.languagetool.org/v2/check"

let check (text: string) =
    task {
        use content = new FormUrlEncodedContent(dict [ "text", text; "language", "auto" ])
        use! response = Http.client.PostAsync(endpoint, content)
        response.EnsureSuccessStatusCode() |> ignore
        let! json = response.Content.ReadAsStringAsync()
        use doc = JsonDocument.Parse json
        let root = doc.RootElement
        let detected = root.GetProperty("language").GetProperty("detectedLanguage")

        let issues =
            [|
                for m in root.GetProperty("matches").EnumerateArray() do
                    let offset = m.GetProperty("offset").GetInt32()
                    let length = m.GetProperty("length").GetInt32()

                    {
                        Kind = m.GetProperty("rule").GetProperty("issueType").GetString()
                        Message = m.GetProperty("message").GetString()
                        Fragment = text.Substring(offset, length)
                        Suggestions =
                            m.GetProperty("replacements").EnumerateArray()
                            |> Seq.truncate 3
                            |> Seq.map _.GetProperty("value").GetString()
                            |> Seq.toArray
                    }
            |]

        return
            {
                Language = detected.GetProperty("name").GetString()
                LanguageCode = detected.GetProperty("code").GetString()
                Confidence = detected.GetProperty("confidence").GetDouble()
                Issues = issues
            }
    }
