use pamyatny_kadr;
go

-- Требование 1. Снимок в заказе: из воинской части — только одобренный, гражданский — только
-- в заказ его владельца. Связка: позиции заказа, заказы и съёмки

create or alter trigger tr_order_items_photo
on order_items
after insert, update
as
begin
    set nocount on;
    if not exists (select 1 from inserted)
        return;
    if not (update(photo_id) or update(order_id))
        return;

    declare @list nvarchar(1000), @message nvarchar(2048);

    select @list = string_agg(p.file_name, N', ')
    from inserted as i
    join photos as p
        on p.photo_id = i.photo_id
    join photo_sessions as s
        on s.session_id = p.session_id
    where s.unit_id is not null and p.review_status <> N'одобрена';
    if @list is not null
    begin
        set @message = concat(
            N'Снимок из воинской части заказывать можно только после одобрения: ', @list
        );
        rollback;
        throw 50101, @message, 1;
    end;

    select @list = string_agg(p.file_name, N', ')
    from inserted as i
    join photos as p
        on p.photo_id = i.photo_id
    join photo_sessions as s
        on s.session_id = p.session_id
    join orders as o
        on o.order_id = i.order_id
    where s.customer_id is not null and s.customer_id <> o.customer_id;
    if @list is not null
    begin
        set @message = concat(
            N'Снимок гражданской съёмки можно заказать только для её заказчика: ', @list
        );
        rollback;
        throw 50102, @message, 1;
    end;
end;
go

-- Смена заказчика не должна оставить в заказе чужие гражданские снимки
create or alter trigger tr_orders_photo_owner
on orders
after update
as
begin
    set nocount on;
    if not exists (select 1 from inserted)
        return;

    declare @list nvarchar(1000), @message nvarchar(2048);

    select @list = string_agg(i.order_id, N', ')
    from inserted as i
    join deleted as d
        on d.order_id = i.order_id
    where i.customer_id <> d.customer_id
        and exists (
            select 1
            from order_items as oi
            join photos as p
                on p.photo_id = oi.photo_id
            join photo_sessions as s
                on s.session_id = p.session_id
            where oi.order_id = i.order_id
                and s.customer_id is not null
                and s.customer_id <> i.customer_id
        );
    if @list is not null
    begin
        set @message = concat(
            N'Нельзя сменить заказчика: в заказе есть снимки гражданской съёмки другого клиента, ',
            N'заказ № ', @list
        );
        rollback;
        throw 50103, @message, 1;
    end;
end;
go

-- Изменение съёмки не должно сделать уже заказанные снимки недопустимыми
create or alter trigger tr_photo_sessions_photo_owner
on photo_sessions
after update
as
begin
    set nocount on;
    if not exists (select 1 from inserted)
        return;
    if not (update(customer_id) or update(unit_id))
        return;

    declare @list nvarchar(1000), @message nvarchar(2048);

    select @list = string_agg(session_id, N', ')
    from (
        select distinct i.session_id
        from inserted as i
        join photos as p
            on p.session_id = i.session_id
        join order_items as oi
            on oi.photo_id = p.photo_id
        join orders as o
            on o.order_id = oi.order_id
        where i.customer_id is not null and i.customer_id <> o.customer_id
            or i.unit_id is not null and p.review_status <> N'одобрена'
    ) as broken;
    if @list is not null
    begin
        set @message = concat(N'Изменение съёмки нарушило бы заказы с её снимками, съёмка № ', @list);
        rollback;
        throw 50104, @message, 1;
    end;
end;
go
