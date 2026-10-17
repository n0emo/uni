-- Специалист по защите информации: единственный, кто выносит вердикты по снимкам
execute as user = N'orlov_mu';
select user_name() as current_user_name;
go

select s.session_id, p.photo_id, p.file_name, p.review_status
from photos as p
    join photo_sessions as s on s.session_id = p.session_id
where p.review_status = N'на проверке'
    and s.photographer_id = 4;
go

begin transaction;

update photos
set review_status = N'одобрена',
    reviewer_id = 7,
    reviewed_at = '2026-10-12 10:00:00'
where photo_id = 13;

update photos
set review_status = N'отклонена',
    reviewer_id = 7,
    reviewed_at = '2026-10-12 10:05:00',
    review_comment = N'На заднем плане номера военных автомобилей'
where photo_id = 15;

select photo_id, review_status, reviewer_id, reviewed_at, review_comment
from photos
where photo_id in (13, 15);

rollback;
go

select top (3) u.designation, u.garrison, s.last_name, s.personal_number
from soldiers as s
    join military_units as u on u.unit_id = s.unit_id
order by s.soldier_id;
go

update photos
set file_name = N'ses05_0001_edit.jpg'
where photo_id = 13;
go

update photos
set taken_at = '2026-10-09 12:00:00'
where photo_id = 13;
go

select order_id, total_amount
from orders;
go

insert into payments (order_id, amount, method)
values (8, 1000.00, N'карта');
go

revert;
go
