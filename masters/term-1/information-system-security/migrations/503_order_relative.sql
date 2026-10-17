use pamyatny_kadr;
go

-- Требование 2. Заказ о военнослужащем оформляет только его зарегистрированный родственник,
-- и связь нельзя разорвать, пока по ней есть незавершённые заказы. Связка: заказы и родственники

create or alter trigger tr_orders_relative
on orders
after insert, update
as
begin
    set nocount on;
    if not exists (select 1 from inserted)
        return;

    declare @list nvarchar(1000), @message nvarchar(2048);

    select @list = string_agg(i.order_id, N', ')
    from inserted as i
    left join deleted as d
        on d.order_id = i.order_id
    where i.soldier_id is not null
        and (
            d.order_id is null
            or d.soldier_id is distinct from i.soldier_id
            or d.customer_id <> i.customer_id
        )
        and not exists (
            select 1
            from relatives as r
            where r.soldier_id = i.soldier_id and r.customer_id = i.customer_id
        );
    if @list is not null
    begin
        set @message = concat(
            N'Заказ о военнослужащем может оформить только его зарегистрированный родственник, ',
            N'заказ № ', @list
        );
        rollback;
        throw 50111, @message, 1;
    end;
end;
go

create or alter trigger tr_relatives_protect
on relatives
after update, delete
as
begin
    set nocount on;
    if not exists (select 1 from deleted)
        return;

    declare @list nvarchar(1000), @message nvarchar(2048);

    select @list = string_agg(o.order_id, N', ')
    from deleted as d
    join orders as o
        on o.soldier_id = d.soldier_id and o.customer_id = d.customer_id
    where o.status not in (N'выдан', N'отменён')
        and not exists (
            select 1
            from relatives as r
            where r.soldier_id = d.soldier_id and r.customer_id = d.customer_id
        );
    if @list is not null
    begin
        set @message = concat(
            N'Нельзя разорвать родственную связь: по ней есть незавершённые заказы № ', @list
        );
        rollback;
        throw 50112, @message, 1;
    end;
end;
go
