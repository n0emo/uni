execute as user = N'kuznetsov_pa';
go

-- Ключ закрыт: зашифровать новое значение нечем
insert into v_my_photo_sessions (kind, unit_id, customer_id, session_date, location)
values (N'присяга', 1, null, '2026-10-25', N'в/ч 12345, плац');
go

update v_my_photo_sessions
set location = N'в/ч 23456, плац'
where session_id = 9;
go

-- Изменение прочих столбцов не требует ключа и не портит зашифрованное место
update v_my_photo_sessions
set session_date = '2026-10-19'
where session_id = 9;
go

select session_id, session_date, location
from v_my_photo_sessions
where session_id = 9;
go

open symmetric key key_kuznetsov_pa decryption by password = N'Kuznetsov#Key2026';
go

select session_id, session_date, location
from v_my_photo_sessions
where session_id = 9;
go

-- Номер съёмки менять нельзя
update v_my_photo_sessions
set session_id = 99
where session_id = 9;
go

close symmetric key key_kuznetsov_pa;
revert;
go
