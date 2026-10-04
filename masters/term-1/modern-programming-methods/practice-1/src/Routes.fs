module Routes

open Falco
open Microsoft.AspNetCore.Http
open System.Threading.Tasks

open Model
open Pages
open Requests
open Responses
open Settings
open Store

module ApiRoutes =
    let getHealth: HttpHandler = Response.ofJson { ServerInfo.Version = "0.1.0" }

    let getLinks (ctx: HttpContext) =
        let conn = ctx.Plug<IDbConnectionFactory>().Create()
        let links = Links.list conn
        Response.ofJson links ctx

    let postLinks (ctx: HttpContext) : Task =
        task {
            if not (ctx.Request.HasJsonContentType()) then
                return! ErrorResponse.unsupportedMediaType ctx
            else
                let! body = Request.getJson<CreateLink> ctx
                let conn = ctx.Plug<IDbConnectionFactory>().Create()
                let link = Links.create conn body.Target
                return! Response.ofJson link ctx
        }

module HtmlRoutes =
    let index: HttpHandler = Response.ofHtml Page.index

    let postIndex (ctx: HttpContext) : Task =
        task {
            let conn = ctx.Plug<IDbConnectionFactory>().Create()
            let settings = ctx.Plug<AppSettings>()
            let! f = Request.getForm ctx
            let body = { Target = f.GetString "target" }
            let link = Links.create conn body.Target
            return! Response.ofHtml (Parts.urlRespone settings.ApplicationUrl link.Value.Code) ctx
        }

    let urlRedirect (ctx: HttpContext) =
        let conn = ctx.Plug<IDbConnectionFactory>().Create()
        let code = Request.getRoute(ctx)?code.AsString()

        match Links.getByCode conn code with
        | Some link -> Response.redirectTemporarily link.Target ctx
        | None -> ErrorResponse.notFound ctx
