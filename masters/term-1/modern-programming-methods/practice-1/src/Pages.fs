module Pages

open System.Net
open Falco.Htmx
open Falco.Markup

module Parts =
    /// The create form; after a failed submit it keeps the entered value and shows the error.
    let createForm (value: string) (error: string option) =
        _form
            [ _class_ "card"; Hx.post "/"; Hx.swapOuterHtml ]
            [
                _div
                    [ _class_ "row" ]
                    [
                        _input
                            [
                                _type_ "text"
                                _id_ "target"
                                _name_ "target"
                                _placeholder_ "www.example.com"
                                // Falco.Markup writes attribute values verbatim, so user input is encoded here.
                                _value_ (WebUtility.HtmlEncode value)
                                _required_
                            ]
                        _button [ _type_ "submit" ] [ _text "Shorten" ]
                    ]
                match error with
                | Some message -> _p [ _class_ "error" ] [ _textEnc message ]
                | None -> ()
            ]

    let urlResponse applicationUrl code =
        let url = $"{applicationUrl}/{code}"

        _div
            [ _class_ "card" ]
            [
                _div
                    [ _class_ "row" ]
                    [
                        _a [ _href_ url; _id_ "shortened-link"; _class_ "link" ] [ _textEnc url ]
                        _button
                            [
                                _type_ "button"
                                _onclick_
                                    "navigator.clipboard.writeText(document.getElementById('shortened-link').href); this.textContent = 'Copied'"
                            ]
                            [ _text "Copy" ]
                    ]
                _a [ _href_ "/"; _class_ "muted" ] [ _text "Shorten another" ]
            ]

module Page =
    let private styles =
        """
        :root {
            color-scheme: light dark;
            --bg: light-dark(#f4f5f7, #16181d);
            --card: light-dark(#ffffff, #1f2229);
            --text: light-dark(#1d2129, #e6e8ec);
            --muted: light-dark(#6b7280, #9aa1ad);
            --border: light-dark(#d9dce1, #343843);
            --accent: #3b6fe0;
            --error: light-dark(#c62828, #ff6b6b);
        }
        * { box-sizing: border-box; }
        body {
            margin: 0;
            min-height: 100vh;
            display: grid;
            grid-template-columns: minmax(0, 520px);
            place-content: center;
            padding: 16px;
            background: var(--bg);
            color: var(--text);
            font: 16px/1.5 system-ui, sans-serif;
        }
        h1 { margin: 0 0 16px; font-size: 1.6rem; text-align: center; }
        .card {
            display: grid;
            grid-template-columns: minmax(0, 1fr);
            gap: 12px;
            padding: 20px;
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 10px;
        }
        .row { display: flex; gap: 8px; align-items: center; }
        input {
            flex: 1 1 0;
            min-width: 0;
            padding: 10px 12px;
            font: inherit;
            color: inherit;
            background: transparent;
            border: 1px solid var(--border);
            border-radius: 6px;
        }
        input:focus { outline: 2px solid var(--accent); outline-offset: -1px; }
        button {
            padding: 10px 16px;
            font: inherit;
            color: #fff;
            background: var(--accent);
            border: 0;
            border-radius: 6px;
            cursor: pointer;
        }
        button:hover { filter: brightness(1.1); }
        a { color: var(--accent); }
        .link { flex: 1 1 0; min-width: 0; overflow-wrap: anywhere; font-weight: 600; }
        .muted { color: var(--muted); font-size: 0.9rem; }
        .error { margin: 0; color: var(--error); font-size: 0.9rem; }
        """

    let private template title content =
        _html
            [ _lang_ "en" ]
            [
                _head
                    []
                    [
                        _meta [ _charset_ "utf-8" ]
                        _meta [ _name_ "viewport"; _content_ "width=device-width, initial-scale=1" ]
                        _title [] [ _textEnc title ]
                        _style [] [ _text styles ]
                        _script [ _src_ HtmxScript.cdnSrc ] []
                    ]
                _body [] [ _main [] content ]
            ]

    let index = template "URL Shortener" [ _h1' "URL Shortener"; Parts.createForm "" None ]
