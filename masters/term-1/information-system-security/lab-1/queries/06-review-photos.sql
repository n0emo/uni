-- Специалист по защите информации проверяет снимки повседневной службы (съёмка 5)
select photo_id, review_status, reviewer_id, reviewed_at
from photos
where session_id = 5;

update photos
set review_status = N'одобрена',
    reviewer_id = 7,
    reviewed_at = '2026-10-12 10:00:00'
where session_id = 5
    and photo_id <> 15;

update photos
set review_status = N'отклонена',
    reviewer_id = 7,
    reviewed_at = '2026-10-12 10:05:00',
    review_comment = N'На заднем плане номера военных автомобилей'
where photo_id = 15;

select photo_id, review_status, reviewer_id, reviewed_at, review_comment
from photos
where session_id = 5;

-- Вердикт без указания проверяющего нарушает ограничение ck_photos_review
update photos
set review_status = N'одобрена'
where photo_id = 21;
