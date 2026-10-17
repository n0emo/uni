execute as user = N'kuznetsov_pa';
select user_name() as current_user_name;
go

-- Ключ закрыт: строки видны, но место съёмки не расшифровывается
select session_id, kind, session_date, location
from v_my_photo_sessions;
go

open symmetric key key_kuznetsov_pa decryption by password = N'Kuznetsov#Key2026';
go

select session_id, kind, session_date, location
from v_my_photo_sessions;
go

-- Вставка сразу двух съёмок: место шифруется, владелец проставляется автоматически
insert into v_my_photo_sessions (kind, unit_id, customer_id, session_date, location)
values
    (N'присяга', 2, null, '2026-10-20', N'в/ч 23456, плац, позиции зенитного дивизиона'),
    (N'выездная', null, 13, '2026-10-21', N'ул. Садовая, д. 28, квартира заказчика');
go

update v_my_photo_sessions
set location = N'в/ч 23456, плац и склад ГСМ'
where session_id = 9;
go

update v_my_photo_sessions
set session_date = '2026-10-22'
where session_id = 10;
go

select session_id, kind, session_date, location
from v_my_photo_sessions;
go

close symmetric key key_kuznetsov_pa;
revert;
go
