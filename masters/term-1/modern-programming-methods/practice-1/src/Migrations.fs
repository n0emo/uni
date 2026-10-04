module Migrations

open System.Reflection
open DbUp
open Microsoft.Extensions.Logging

/// Applies the SQL scripts embedded from migrations/ that have not been run yet, in name order.
let run (logger: ILogger) (connectionString: string) =
    let result =
        DeployChanges.To
            .PostgresqlDatabase(connectionString)
            .WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly())
            .WithTransactionPerScript()
            .LogTo(logger)
            .Build()
            .PerformUpgrade()

    if not result.Successful then
        raise result.Error
