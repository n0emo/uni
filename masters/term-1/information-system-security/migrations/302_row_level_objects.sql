use pamyatny_kadr;
go

-- Представление показывает фотографу только его съёмки и расшифровывает место съёмки
create or alter view v_my_photo_sessions
as
select
    s.session_id,
    s.kind,
    s.unit_id,
    s.customer_id,
    s.session_date,
    convert(nvarchar(150), decryptbykey(s.location_encrypted)) as location
from photo_sessions as s
join employees as e
    on e.employee_id = s.photographer_id
where e.login_name = user_name();
go

create or alter trigger tr_v_my_photo_sessions_insert
on v_my_photo_sessions
instead of insert
as
begin
    set nocount on;

    declare @photographer_id int = (
        select employee_id from employees where login_name = user_name()
    );
    if @photographer_id is null
        throw 50010, N'Пользователь не является фотографом студии', 1;

    declare @key_guid uniqueidentifier = key_guid(N'key_' + user_name());
    if exists (select 1 from inserted where encryptbykey(@key_guid, location) is null)
        throw 50011, N'Ключ шифрования не открыт', 1;

    insert into photo_sessions (
        kind, unit_id, customer_id, photographer_id, session_date, location_encrypted
    )
    select
        kind, unit_id, customer_id, @photographer_id, session_date,
        encryptbykey(@key_guid, location)
    from inserted;
end;
go

create or alter trigger tr_v_my_photo_sessions_update
on v_my_photo_sessions
instead of update
as
begin
    set nocount on;

    if update(session_id)
        throw 50012, N'Номер съёмки изменять нельзя', 1;

    declare @key_guid uniqueidentifier = key_guid(N'key_' + user_name());

    -- при закрытом ключе location в inserted пуст, поэтому шифруем только явно заданное значение
    if update(location) and exists (
        select 1 from inserted where encryptbykey(@key_guid, location) is null
    )
        throw 50011, N'Ключ шифрования не открыт', 1;

    update s
    set kind = i.kind,
        unit_id = i.unit_id,
        customer_id = i.customer_id,
        session_date = i.session_date,
        location_encrypted = iif(
            update(location), encryptbykey(@key_guid, i.location), s.location_encrypted
        )
    from photo_sessions as s
    join inserted as i
        on i.session_id = s.session_id;
end;
go

-- Фотограф добавляет снимки только в свои съёмки
create or alter procedure add_photo
    @session_id int,
    @file_name nvarchar(100),
    @taken_at datetime2(0)
as
begin
    set nocount on;

    insert into photos (session_id, file_name, taken_at, review_status)
    select
        s.session_id,
        @file_name,
        @taken_at,
        iif(s.unit_id is null, N'не требуется', N'на проверке')
    from photo_sessions as s
    join employees as e
        on e.employee_id = s.photographer_id
    where s.session_id = @session_id
        and e.login_name = user_name();

    if @@rowcount = 0
        throw 50001, N'Съёмка не найдена или принадлежит другому фотографу', 1;
end;
go
