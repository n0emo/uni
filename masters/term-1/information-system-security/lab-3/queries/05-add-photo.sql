execute as user = N'kuznetsov_pa';
go

begin transaction;

exec add_photo @session_id = 9, @file_name = N'ses09_0001.jpg', @taken_at = '2026-10-19 11:15:00';
exec add_photo @session_id = 10, @file_name = N'ses10_0001.jpg', @taken_at = '2026-10-22 12:00:00';

select photo_id, session_id, file_name, review_status
from photos
where file_name in (N'ses09_0001.jpg', N'ses10_0001.jpg');

rollback;
go

-- Съёмка 2 принадлежит Васильевой
exec add_photo @session_id = 2, @file_name = N'ses02_0009.jpg', @taken_at = '2026-10-02 12:00:00';
go

revert;
go
