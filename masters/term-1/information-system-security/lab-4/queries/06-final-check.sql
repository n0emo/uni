select signature_status, count(*) as photos
from v_photo_reviews
group by signature_status;
go

-- Триггер включён и после восстановления снова защищает вердикты
select name, is_disabled
from sys.triggers
where name = N'tr_photos_review_guard';
go
