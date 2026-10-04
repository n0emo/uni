module Pages

open Falco.Htmx
open Falco.Markup

module Page =
    let private template content =
        _html [ _lang_ "en" ] [ _head [] [ _script [ _src_ HtmxScript.cdnSrc ] [] ]; _body [] content ]

    let index =
        template
            [
                _h1' "URL Shortener"
                _form
                    [ Hx.post "/"; Hx.swapOuterHtml ]
                    [
                        _input
                            [
                                _type_ "text"
                                _id_ "target"
                                _name_ "target"
                                _placeholder_ "www.example.com"
                            ]
                        _button [ _type_ "submit" ] [ _text "Create" ]
                    ]
            ]

module Parts =
    let urlRespone applicationUrl code =
        let url = $"{applicationUrl}/{code}"

        _div
            []
            [
                _a [ _href_ url; _id_ "shortened-link" ] [ _text url ]
                _button
                    [
                        _onclick_ "navigator.clipboard.writeText(document.getElementById('shortened-link').href)"
                    ]
                    [ _text "Copy" ]
            ]
