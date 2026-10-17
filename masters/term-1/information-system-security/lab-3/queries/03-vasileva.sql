execute as user = N'vasileva_ei';
open symmetric key key_vasileva_ei decryption by password = N'Vasileva#Key2026';
go

-- Видны только съёмки Васильевой; вставленные Кузнецовым строки 9 и 10 в выборку не попадают
select session_id, kind, session_date, location
from v_my_photo_sessions;
go

-- Чужие строки представлением не затрагиваются
update v_my_photo_sessions
set location = N'подмена'
where session_id in (1, 9);
go

insert into v_my_photo_sessions (kind, unit_id, customer_id, session_date, location)
values (N'повседневная служба', 1, null, '2026-10-23', N'в/ч 12345, штаб, шифровальный отдел');
go

select session_id, kind, session_date, location
from v_my_photo_sessions
where session_date >= '2026-10-23';
go

close symmetric key key_vasileva_ei;
go

-- Чужой ключ открыть нельзя, даже зная пароль
open symmetric key key_kuznetsov_pa decryption by password = N'Kuznetsov#Key2026';
go

-- Прямой доступ к таблице закрыт
select session_id, location_encrypted from photo_sessions;
go

insert into photo_sessions (kind, unit_id, photographer_id, session_date, location_encrypted)
values (N'присяга', 1, 4, '2026-10-24', 0x00);
go

update photo_sessions set photographer_id = 5 where session_id = 1;
go

revert;
go
