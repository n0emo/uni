-- Сообщения сервера на русском языке; логины, созданные позже, наследуют этот язык
exec sp_configure 'default language', 21;
reconfigure;
go

alter login sa with default_language = russian;
go

create database pamyatny_kadr
    collate Cyrillic_General_100_CI_AS;
go
