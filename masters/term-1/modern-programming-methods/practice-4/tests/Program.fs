open Expecto

[<EntryPoint>]
let main argv =
    runTestsWithCLIArgs [] argv ModelTests.tests
