module Routes

open Falco
open Microsoft.AspNetCore.Http
open System.Text.Json
open System.Threading.Tasks

open Model
open Pages
open Requests
open Responses
open Settings
open Store

let private header (ctx: HttpContext) (name: string) =
    let value = ctx.Request.Headers[name].ToString()
    if value = "" then None else Some value

module ApiRoutes =
    let getHealth: HttpHandler = Response.ofJson { ServerInfo.Version = "0.1.0" }

    let getLinks (ctx: HttpContext) =
        use conn = ctx.Plug<IDbConnectionFactory>().Create()
        let links = Links.list conn
        Response.ofJson links ctx

    let postLinks (ctx: HttpContext) : Task =
        task {
            if not (ctx.Request.HasJsonContentType()) then
                return! ErrorResponse.unsupportedMediaType ctx
            else
                let! body =
                    task {
                        try
                            let! body = Request.getJson<CreateLink> ctx
                            // A literal `null` body deserializes to a null record.
                            return if isNull (box body) then None else Some body
                        with :? JsonException ->
                            return None
                    }

                match body with
                | None -> return! ErrorResponse.badRequest "Request body must be a JSON object" ctx
                | Some body ->
                    match Target.normalize body.Target with
                    | Error message -> return! ErrorResponse.badRequest message ctx
                    | Ok target ->
                        use conn = ctx.Plug<IDbConnectionFactory>().Create()
                        let link = Links.create conn target
                        return! Response.ofJson link ctx
        }

    let getClicks (ctx: HttpContext) =
        use conn = ctx.Plug<IDbConnectionFactory>().Create()
        let code = Request.getRoute(ctx)?code.AsString()

        match Links.getByCode conn code with
        | Some _ -> Response.ofJson (Clicks.listByCode conn code) ctx
        | None -> ErrorResponse.notFound ctx

module HtmlRoutes =
    let index: HttpHandler = Response.ofHtml Page.index

    let postIndex (ctx: HttpContext) : Task =
        task {
            let settings = ctx.Plug<AppSettings>()
            let! f = Request.getForm ctx
            let raw = f.GetString "target"

            match Target.normalize raw with
            | Error message -> return! Response.ofHtml (Parts.createForm raw (Some message)) ctx
            | Ok target ->
                use conn = ctx.Plug<IDbConnectionFactory>().Create()
                let link = Links.create conn target
                return! Response.ofHtml (Parts.urlResponse settings.ApplicationUrl link.Code) ctx
        }

    let urlRedirect (ctx: HttpContext) =
        use conn = ctx.Plug<IDbConnectionFactory>().Create()
        let code = Request.getRoute(ctx)?code.AsString()

        match Links.getByCode conn code with
        | Some link ->
            Clicks.record conn link (header ctx "User-Agent") (header ctx "Referer")
            Response.redirectTemporarily link.Target ctx
        | None -> ErrorResponse.notFound ctx
