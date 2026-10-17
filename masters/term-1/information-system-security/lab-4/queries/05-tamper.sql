-- Копия вердиктов для восстановления данных
select photo_id, review_status, review_comment, review_signature
into #original
from photos
where photo_id in (2, 3, 4);
go

-- Даже dbo не может изменить вердикт мимо процедуры
update photos
set review_status = N'одобрена', review_comment = null
where photo_id = 3;
go

-- Флаг процедуры можно взвести и вручную, но триггер всё равно проверит подпись
exec sp_set_session_context N'photo_review_signing', 1;
update photos
set review_comment = N'Проверено повторно'
where photo_id = 4;
exec sp_set_session_context N'photo_review_signing', 0;
go

select photo_id, review_comment
from photos
where photo_id in (3, 4);
go

-- Подмена данных в обход механизма: триггер отключён
disable trigger tr_photos_review_guard on photos;
go

-- Снимку 3 вместо отклонения выставлено одобрение, снимку 4 изменён комментарий,
-- снимку 2 присвоена подпись снимка 1
update photos
set review_status = N'одобрена', review_comment = null
where photo_id = 3;

update photos
set review_comment = N'Проверено повторно'
where photo_id = 4;

update p
set review_signature = s.review_signature
from photos as p
cross join photos as s
where p.photo_id = 2 and s.photo_id = 1;
go

select p.photo_id, p.review_status, p.review_comment, v.signature_status
from photos as p
join v_photo_reviews as v
    on v.photo_id = p.photo_id
where p.photo_id in (1, 2, 3, 4);
go

-- Восстановление исходных данных и включение триггера
update p
set review_status = o.review_status,
    review_comment = o.review_comment,
    review_signature = o.review_signature
from photos as p
join #original as o
    on o.photo_id = p.photo_id;
go

enable trigger tr_photos_review_guard on photos;
go

select p.photo_id, p.review_status, p.review_comment, v.signature_status
from photos as p
join v_photo_reviews as v
    on v.photo_id = p.photo_id
where p.photo_id in (1, 2, 3, 4);
go
