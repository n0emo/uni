-- Фотограф не вправе выносить вердикты и менять подпись
execute as user = N'kuznetsov_pa';
exec review_photo @photo_id = 14, @verdict = N'одобрена', @key_password = N'Orlov#Sign2026';
go
update photos
set review_status = N'одобрена'
where photo_id = 14;
go
update photos
set review_signature = 0x00
where photo_id = 14;
go
-- Переименование подписанного снимка нарушило бы подпись
update photos
set file_name = N'ses01_0003_new.jpg'
where photo_id = 3;
go
revert;
go

-- Менеджер тоже
execute as user = N'lebedeva_is';
exec review_photo @photo_id = 14, @verdict = N'одобрена', @key_password = N'Orlov#Sign2026';
go
revert;
go

-- Сотрудник с процедурой, но без ключа подписи: директору процедура не выдана,
-- поэтому право выдаётся явно и затем отзывается
grant execute on review_photo to role_director;
execute as user = N'sokolov_av';
exec review_photo @photo_id = 14, @verdict = N'одобрена', @key_password = N'Orlov#Sign2026';
go
revert;
revoke execute on review_photo from role_director;
go

-- Пароль ключа Орлова бесполезен для постороннего: ключ ему не принадлежит
execute as user = N'novikova_ad';
select signbyasymkey(asymkey_id(N'sign_orlov_mu'), 0x01, N'Orlov#Sign2026') as signature;
go
revert;
go
