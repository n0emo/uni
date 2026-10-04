module Store

open Donald
open System.Security.Cryptography
open System.Data

open Model

type IDbConnectionFactory =
    abstract member Create: unit -> IDbConnection

module Links =
    let private alphabet =
        "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

    let private generateCode () =
        RandomNumberGenerator.GetString(alphabet, 7)

    let list conn =
        conn
        |> Db.newCommand
            "select id, code, target, created_at
             from links"
        |> Db.query Link.ofDataReader

    let getByCode conn code =
        conn
        |> Db.newCommand
            "select id, code, target, created_at
             from links
             where code = @code"
        |> Db.setParams [ "code", SqlType.String code ]
        |> Db.querySingle Link.ofDataReader

    let create conn target =
        let mutable link = None

        while link.IsNone do
            let code = generateCode ()

            link <-
                conn
                |> Db.newCommand
                    "insert into links(code, target)
                     values (@code, @target)
                     on conflict do nothing
                     returning id, code, target, created_at"
                |> Db.setParams [ "code", SqlType.String code; "target", SqlType.String target ]
                |> Db.querySingle Link.ofDataReader

        link
