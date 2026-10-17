execute as user = N'sokolov_av';
select photo_id, file_name, review_status, reviewer, reviewed_at, signature_status
from v_photo_reviews
where photo_id between 1 and 8;
go
revert;
go

execute as user = N'lebedeva_is';
select signature_status, count(*) as photos
from v_photo_reviews
group by signature_status;
go
-- Столбцы, закрытые менеджеру, остаются закрытыми
select review_comment
from photos;
go
select review_signature
from photos;
go
revert;
go

execute as user = N'novikova_ad';
select * from v_photo_reviews;
go
revert;
go

execute as user = N'kuznetsov_pa';
select * from v_photo_reviews;
go
revert;
go
