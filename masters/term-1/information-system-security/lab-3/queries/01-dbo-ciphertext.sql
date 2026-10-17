-- Ключи, их владельцы и алгоритм
select k.name as key_name, p.name as owner, k.algorithm_desc
from sys.symmetric_keys as k
join sys.database_principals as p
    on p.principal_id = k.principal_id
where k.name like N'key[_]%';
go

-- Столбца с открытым текстом в таблице больше нет
select name, type_name(user_type_id) as type_name, max_length
from sys.columns
where object_id = object_id(N'photo_sessions')
order by column_id;
go

-- Владелец БД видит в таблице только шифртекст
select
    session_id,
    photographer_id,
    left(convert(nvarchar(max), location_encrypted, 1), 10) + N'…'
        + right(convert(nvarchar(max), location_encrypted, 1), 8) as location_encrypted,
    datalength(location_encrypted) as bytes
from photo_sessions;
go

-- Представление отбирает строки по имени пользователя, а dbo не фотограф
select user_name() as current_user_name, count(*) as visible_rows
from v_my_photo_sessions;
go
