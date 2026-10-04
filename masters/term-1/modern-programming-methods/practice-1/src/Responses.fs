module Responses

open Falco

type Error = { Code: string; Message: string }

module ErrorResponse =
    let private err code message = { Code = code; Message = message }

    let private response (code: int, message: string) : HttpHandler =
        Response.withStatusCode code >> Response.ofJson (err (code.ToString()) message)

    let badRequest message : HttpHandler = response (400, message)
    let notFound: HttpHandler = response (404, "Not Found")
    let unsupportedMediaType: HttpHandler = response (415, "Unsupported Media Type")
    let internalServerError: HttpHandler = response (500, "Internal Server Error")
