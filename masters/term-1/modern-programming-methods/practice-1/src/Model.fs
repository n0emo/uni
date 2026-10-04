module Model

open System
open System.Data
open Donald

type ServerInfo = { Version: string }

type Link =
    {
        Id: int64
        Code: string
        Target: string
        CreatedAt: DateTime
    }

module Link =
    let ofDataReader (rd: IDataReader) : Link =
        {
            Id = rd.ReadInt64 "id"
            Code = rd.ReadString "code"
            Target = rd.ReadString "target"
            CreatedAt = rd.ReadDateTime "created_at"
        }

type Click =
    {
        Id: int64
        Link: Link
        ClickedAt: DateTime
        UserAgent: string option
        Referer: string option
    }

module Click =
    let ofDataReader (rd: IDataReader) : Click =
        {
            Id = rd.ReadInt64 "id"
            Link =
                {
                    Id = rd.ReadInt64 "link_id"
                    Code = rd.ReadString "link_code"
                    Target = rd.ReadString "link_target"
                    CreatedAt = rd.ReadDateTime "link_created_at"
                }
            ClickedAt = rd.ReadDateTime "clicked_at"
            UserAgent = rd.ReadStringOption "user_agent"
            Referer = rd.ReadStringOption "referer"
        }
