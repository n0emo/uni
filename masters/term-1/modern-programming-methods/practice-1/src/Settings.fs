module Settings

open System
open Microsoft.Extensions.Configuration

type AppSettings =
    {
        ApplicationUrl: string
        ConnectionString: string
    }

module AppSettings =
    let private required (name: string) (value: string) =
        if String.IsNullOrWhiteSpace value then
            failwith $"Configuration value '{name}' is not set"

        value

    let ofConfiguration (config: IConfiguration) =
        {
            ApplicationUrl = (required "ApplicationUrl" config["ApplicationUrl"]).TrimEnd '/'
            ConnectionString =
                required "ConnectionStrings:Default" (config.GetConnectionString "Default")
        }
