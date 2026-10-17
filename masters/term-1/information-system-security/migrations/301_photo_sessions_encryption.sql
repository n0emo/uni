use pamyatny_kadr;
go

-- Ключ создаёт dbo, но владельцем назначается фотограф: права create symmetric key не нужны,
-- а владелец получает на ключ полный доступ автоматически
create symmetric key key_kuznetsov_pa
    authorization kuznetsov_pa
    with algorithm = AES_256
    encryption by password = N'Kuznetsov#Key2026';
create symmetric key key_vasileva_ei
    authorization vasileva_ei
    with algorithm = AES_256
    encryption by password = N'Vasileva#Key2026';
go

alter table photo_sessions
    add location_encrypted varbinary(512) null;
go

-- Действующие данные шифруются ключом фотографа — владельца съёмки
open symmetric key key_kuznetsov_pa decryption by password = N'Kuznetsov#Key2026';
open symmetric key key_vasileva_ei decryption by password = N'Vasileva#Key2026';

update s
set location_encrypted = encryptbykey(key_guid(N'key_' + e.login_name), s.location)
from photo_sessions as s
join employees as e
    on e.employee_id = s.photographer_id;

close symmetric key key_kuznetsov_pa;
close symmetric key key_vasileva_ei;
go

alter table photo_sessions
    alter column location_encrypted varbinary(512) not null;

alter table photo_sessions
    drop column location;
go
