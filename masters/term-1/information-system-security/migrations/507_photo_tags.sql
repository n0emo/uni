use pamyatny_kadr;
go

-- Требование 6. Военнослужащий на снимке служит в части этой съёмки и в день съёмки уже призван
-- и ещё не уволен. Связка: отметки, военнослужащие, съёмки и снимки

create or alter trigger tr_photo_soldiers_service
on photo_soldiers
after insert, update
as
begin
    set nocount on;
    if not exists (select 1 from inserted)
        return;

    declare @list nvarchar(1000), @message nvarchar(2048);

    select @list = string_agg(concat(p.file_name, N' — ', sd.last_name), N', ')
    from inserted as i
    join photos as p
        on p.photo_id = i.photo_id
    join photo_sessions as s
        on s.session_id = p.session_id
    join soldiers as sd
        on sd.soldier_id = i.soldier_id
    where s.unit_id is distinct from sd.unit_id;
    if @list is not null
    begin
        set @message = concat(N'Военнослужащий служит не в части этой съёмки: ', @list);
        rollback;
        throw 50151, @message, 1;
    end;

    select @list = string_agg(concat(p.file_name, N' — ', sd.last_name), N', ')
    from inserted as i
    join photos as p
        on p.photo_id = i.photo_id
    join photo_sessions as s
        on s.session_id = p.session_id
    join soldiers as sd
        on sd.soldier_id = i.soldier_id
    where s.session_date < sd.call_up_date or s.session_date > sd.discharge_date;
    if @list is not null
    begin
        set @message = concat(N'В день съёмки военнослужащий не проходил службу: ', @list);
        rollback;
        throw 50152, @message, 1;
    end;
end;
go

create or alter trigger tr_soldiers_tags_guard
on soldiers
after update
as
begin
    set nocount on;
    if not exists (select 1 from inserted)
        return;
    if not (update(unit_id) or update(call_up_date) or update(discharge_date))
        return;

    declare @list nvarchar(1000), @message nvarchar(2048);

    select @list = string_agg(distinct_soldiers.name, N', ')
    from (
        select distinct concat(i.last_name, N' ', left(i.first_name, 1), N'.') as name
        from inserted as i
        join photo_soldiers as ps
            on ps.soldier_id = i.soldier_id
        join photos as p
            on p.photo_id = ps.photo_id
        join photo_sessions as s
            on s.session_id = p.session_id
        where s.unit_id is distinct from i.unit_id
            or s.session_date < i.call_up_date
            or s.session_date > i.discharge_date
    ) as distinct_soldiers;
    if @list is not null
    begin
        set @message = concat(
            N'Изменение нарушило бы отметки на снимках, военнослужащий: ', @list
        );
        rollback;
        throw 50153, @message, 1;
    end;
end;
go

create or alter trigger tr_photo_sessions_tags_guard
on photo_sessions
after update
as
begin
    set nocount on;
    if not exists (select 1 from inserted)
        return;
    if not (update(unit_id) or update(session_date))
        return;

    declare @list nvarchar(1000), @message nvarchar(2048);

    select @list = string_agg(broken.session_id, N', ')
    from (
        select distinct i.session_id
        from inserted as i
        join photos as p
            on p.session_id = i.session_id
        join photo_soldiers as ps
            on ps.photo_id = p.photo_id
        join soldiers as sd
            on sd.soldier_id = ps.soldier_id
        where sd.unit_id is distinct from i.unit_id
            or i.session_date < sd.call_up_date
            or i.session_date > sd.discharge_date
    ) as broken;
    if @list is not null
    begin
        set @message = concat(N'Изменение съёмки нарушило бы отметки на снимках, съёмка № ', @list);
        rollback;
        throw 50154, @message, 1;
    end;
end;
go

-- Снимок не переносится между съёмками: от съёмки зависят и отметки, и допустимость заказа
create or alter trigger tr_photos_session_fixed
on photos
after update
as
begin
    set nocount on;
    if not exists (select 1 from inserted)
        return;
    if not update(session_id)
        return;

    declare @list nvarchar(1000), @message nvarchar(2048);

    select @list = string_agg(i.file_name, N', ')
    from inserted as i
    join deleted as d
        on d.photo_id = i.photo_id
    where i.session_id <> d.session_id;
    if @list is not null
    begin
        set @message = concat(N'Снимок нельзя перенести в другую съёмку: ', @list);
        rollback;
        throw 50155, @message, 1;
    end;
end;
go
