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
             from links
             order by created_at"
        |> Db.query Link.ofDataReader

    let getByCode conn code =
        conn
        |> Db.newCommand
            "select id, code, target, created_at
             from links
             where code = @code"
        |> Db.setParams [ "code", SqlType.String code ]
        |> Db.querySingle Link.ofDataReader

    /// Inserts a link under a fresh random code, retrying while the code is already taken.
    let create conn target : Link =
        let tryInsert code =
            conn
            |> Db.newCommand
                "insert into links(code, target)
                 values (@code, @target)
                 on conflict (code) do nothing
                 returning id, code, target, created_at"
            |> Db.setParams [ "code", SqlType.String code; "target", SqlType.String target ]
            |> Db.querySingle Link.ofDataReader

        Seq.initInfinite (fun _ -> generateCode ()) |> Seq.pick tryInsert

module Clicks =
    let private optionalString =
        function
        | Some value -> SqlType.String value
        | None -> SqlType.Null

    let record conn (link: Link) (userAgent: string option) (referer: string option) =
        conn
        |> Db.newCommand
            "insert into clicks(link_id, user_agent, referer)
             values (@link_id, @user_agent, @referer)"
        |> Db.setParams
            [
                "link_id", SqlType.Int64 link.Id
                "user_agent", optionalString userAgent
                "referer", optionalString referer
            ]
        |> Db.exec

    let listByCode conn code =
        conn
        |> Db.newCommand
            // Donald reads rows with sequential access, so the columns follow Click.ofDataReader.
            "select c.id,
                    l.id as link_id, l.code as link_code, l.target as link_target,
                    l.created_at as link_created_at,
                    c.clicked_at, c.user_agent, c.referer
             from clicks c
             join links l on l.id = c.link_id
             where l.code = @code
             order by c.clicked_at"
        |> Db.setParams [ "code", SqlType.String code ]
        |> Db.query Click.ofDataReader
