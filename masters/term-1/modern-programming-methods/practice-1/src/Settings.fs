module Settings

open System
open Microsoft.Extensions.Configuration

type AppSettings = { ApplicationUrl: string }

module AppSettings =
    let ofConfiguration (config: IConfiguration) =
        let applicationUrl = config["ApplicationUrl"]

        if String.IsNullOrWhiteSpace applicationUrl then
            failwith "Configuration value 'ApplicationUrl' is not set"

        { ApplicationUrl = applicationUrl.TrimEnd '/' }
