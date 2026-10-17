execute as user = N'lebedeva_is';
select session_id, kind, unit_id, photographer_id, session_date
from photo_sessions;
go
select location_encrypted from photo_sessions;
go
select * from photo_sessions;
go
select * from v_my_photo_sessions;
go
revert;
go

execute as user = N'novikova_ad';
select session_id, kind, session_date
from photo_sessions;
go
select location_encrypted from photo_sessions;
go
revert;
go

execute as user = N'orlov_mu';
select s.session_id, u.designation, u.garrison, s.session_date
from photo_sessions as s
join military_units as u
    on u.unit_id = s.unit_id;
go
select location_encrypted from photo_sessions;
go
open symmetric key key_kuznetsov_pa decryption by password = N'Kuznetsov#Key2026';
go
revert;
go

execute as user = N'sokolov_av';
select
    session_id,
    photographer_id,
    left(convert(nvarchar(max), location_encrypted, 1), 10) + N'…'
        + right(convert(nvarchar(max), location_encrypted, 1), 8) as location_encrypted
from photo_sessions;
go
open symmetric key key_vasileva_ei decryption by password = N'Vasileva#Key2026';
go
revert;
go
