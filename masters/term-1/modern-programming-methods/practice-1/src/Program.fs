open Falco
open Falco.OpenApi
open Falco.Routing
open Microsoft.AspNetCore.Builder
open Microsoft.Extensions.Configuration
open Microsoft.Extensions.DependencyInjection
open Microsoft.Extensions.Hosting
open Microsoft.Extensions.Logging
open Npgsql

open Model
open Requests
open Store
open Routes
open Settings
open Responses

[<EntryPoint>]
let main args =
    let builder = WebApplication.CreateBuilder args

    let connectionString = builder.Configuration.GetConnectionString "Default"

    let dbConnectionFactory =
        { new IDbConnectionFactory with
            member _.Create() = new NpgsqlConnection(connectionString)
        }

    builder.Services
        .AddSingleton<IDbConnectionFactory>(dbConnectionFactory)
        .AddFalcoOpenApi()
        .AddSwaggerGen(fun options -> options.DocInclusionPredicate(fun _ api -> api.RelativePath.StartsWith "api/"))
    |> ignore


    builder.Services.AddSingleton<AppSettings>(AppSettings.ofConfiguration builder.Configuration)
    |> ignore


    let app = builder.Build()

    Migrations.run (app.Services.GetRequiredService<ILoggerFactory>().CreateLogger "Migrations") connectionString

    if app.Environment.IsDevelopment() then
        app.UseSwagger() |> ignore

        app.UseSwaggerUI(fun options -> options.SwaggerEndpoint("v1/swagger.json", "URL Shortener API V1"))
        |> ignore

    let endpoints =
        [
            get "/api/health" ApiRoutes.getHealth
            |> OpenApi.summary "Check that the service is up"
            |> OpenApi.returnType typeof<ServerInfo>

            get "/api/links" ApiRoutes.getLinks
            |> OpenApi.summary "List all short links"
            |> OpenApi.returnType typeof<Link list>

            post "/api/links" ApiRoutes.postLinks
            |> OpenApi.summary "Create a short link for the target URL"
            |> OpenApi.acceptsType typeof<CreateLink>
            |> OpenApi.returnType typeof<Link>

            get "/" HtmlRoutes.index
            post "/" HtmlRoutes.postIndex
            get "/{code}" HtmlRoutes.urlRedirect
        ]

    app
        .UseFalcoExceptionHandler(ErrorResponse.internalServerError)
        .UseRouting()
        .UseFalco(endpoints)
        .UseFalcoNotFound(ErrorResponse.notFound)
    |> ignore

    app.Run()

    0 // Exit code
