-- Фотограф: съёмки и снимки, но не результат проверки и не заказы
execute as user = N'kuznetsov_pa';
select user_name() as current_user_name;
go

select session_id, kind, session_date, location
from photo_sessions
where photographer_id = 4;
go

begin transaction;

update photo_sessions
set location = N'в/ч 23456, автопарк, столовая и плац'
where session_id = 5;

update photos
set taken_at = '2026-10-09 13:05:00'
where photo_id = 13;

rollback;
go

begin transaction;

exec add_photo @session_id = 5, @file_name = N'ses05_0004.jpg', @taken_at = '2026-10-09 14:40:00';
exec add_photo @session_id = 7, @file_name = N'ses07_0003.jpg', @taken_at = '2026-10-11 13:20:00';

select photo_id, session_id, file_name, review_status
from photos
where file_name in (N'ses05_0004.jpg', N'ses07_0003.jpg');

rollback;
go

insert into photos (session_id, file_name, taken_at, review_status, reviewer_id, reviewed_at)
values (5, N'ses05_0005.jpg', '2026-10-09 14:50:00', N'одобрена', 4, '2026-10-09 15:00:00');
go

update photos
set review_status = N'одобрена',
    reviewer_id = 4,
    reviewed_at = '2026-10-10 09:00:00'
where photo_id = 13;
go

select last_name, personal_number
from soldiers;
go

select designation, garrison
from military_units;
go

select order_id, status
from orders;
go

revert;
go
