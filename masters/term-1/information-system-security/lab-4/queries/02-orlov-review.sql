execute as user = N'orlov_mu';
select user_name() as current_user_name;
go

-- Снимки 7, 13, 14, 15, 21 ожидают проверки
select photo_id, file_name, review_status, reviewer_id, review_signature
from photos
where photo_id in (7, 13, 14, 15, 21);
go

exec review_photo @photo_id = 7, @verdict = N'одобрена', @key_password = N'Orlov#Sign2026';
exec review_photo
    @photo_id = 13,
    @verdict = N'отклонена',
    @comment = N'В кадре видны позиции зенитного дивизиона',
    @key_password = N'Orlov#Sign2026';
go

select photo_id, file_name, review_status, reviewer, reviewed_at, signature_status
from v_photo_reviews
where photo_id in (7, 13);
go

-- Неверный пароль закрытого ключа: изменения не вносятся
exec review_photo @photo_id = 14, @verdict = N'одобрена', @key_password = N'Orlov#Wrong2026';
go

-- Отклонение без комментария
exec review_photo @photo_id = 14, @verdict = N'отклонена', @key_password = N'Orlov#Sign2026';
go

-- Недопустимый вердикт
exec review_photo @photo_id = 14, @verdict = N'на проверке', @key_password = N'Orlov#Sign2026';
go

-- Снимок уже проверен
exec review_photo @photo_id = 1, @verdict = N'одобрена', @key_password = N'Orlov#Sign2026';
go

-- Снимок съёмки, не требующей проверки
exec review_photo @photo_id = 16, @verdict = N'одобрена', @key_password = N'Orlov#Sign2026';
go

-- Снимка 99 нет
exec review_photo @photo_id = 99, @verdict = N'одобрена', @key_password = N'Orlov#Sign2026';
go

select photo_id, review_status, reviewer_id, review_signature
from photos
where photo_id = 14;
go

-- Прямое изменение вердикта больше не разрешено даже проверяющему
update photos
set review_status = N'одобрена'
where photo_id = 13;
go

revert;
go
