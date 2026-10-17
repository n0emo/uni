use pamyatny_kadr;
go

-- Требование 3. Сумма заказа всегда равна сумме позиций и не меньше оплаченного, а состав заказа
-- меняется, только пока он новый. Связка: позиции, заказы и платежи

create or alter trigger tr_order_items_total
on order_items
after insert, update, delete
as
begin
    set nocount on;
    if not exists (select 1 from inserted) and not exists (select 1 from deleted)
        return;

    update o
    set total_amount = t.amount
    from orders as o
    cross apply (
        select coalesce(sum(oi.quantity * oi.unit_price), 0) as amount
        from order_items as oi
        where oi.order_id = o.order_id
    ) as t
    where o.order_id in (select order_id from inserted union select order_id from deleted)
        and o.total_amount <> t.amount;
end;
go

-- Инвариант проверяется на стороне заказов: ручная правка суммы не проходит, а пересчёт
-- из tr_order_items_total проходит, потому что к этому моменту позиции уже изменены
create or alter trigger tr_orders_total_guard
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
    where i.total_amount <> (
        select coalesce(sum(oi.quantity * oi.unit_price), 0)
        from order_items as oi
        where oi.order_id = i.order_id
    );
    if @list is not null
    begin
        set @message = concat(
            N'Сумма заказа вычисляется по позициям и не задаётся вручную, заказ № ', @list
        );
        rollback;
        throw 50121, @message, 1;
    end;

    select @list = string_agg(i.order_id, N', ')
    from inserted as i
    where i.total_amount < (
        select coalesce(sum(p.amount), 0)
        from payments as p
        where p.order_id = i.order_id
    );
    if @list is not null
    begin
        set @message = concat(N'Сумма заказа не может стать меньше уже оплаченной, заказ № ', @list);
        rollback;
        throw 50124, @message, 1;
    end;
end;
go

create or alter trigger tr_order_items_frozen
on order_items
after insert, update, delete
as
begin
    set nocount on;
    if not exists (select 1 from inserted) and not exists (select 1 from deleted)
        return;

    declare @list nvarchar(1000), @message nvarchar(2048);

    select @list = string_agg(i.order_item_id, N', ')
    from inserted as i
    join deleted as d
        on d.order_item_id = i.order_item_id
    where i.order_id <> d.order_id;
    if @list is not null
    begin
        set @message = concat(N'Позицию нельзя перенести в другой заказ, позиция № ', @list);
        rollback;
        throw 50123, @message, 1;
    end;

    -- состав: добавление, удаление, смена товара, количества или цены
    select @list = string_agg(composition.order_id, N', ')
    from (
        select distinct c.order_id
        from (
            select i.order_id
            from inserted as i
            where not exists (select 1 from deleted as d where d.order_item_id = i.order_item_id)
            union all
            select d.order_id
            from deleted as d
            where not exists (select 1 from inserted as i where i.order_item_id = d.order_item_id)
            union all
            select i.order_id
            from inserted as i
            join deleted as d
                on d.order_item_id = i.order_item_id
            where i.product_id <> d.product_id
                or i.quantity <> d.quantity
                or i.unit_price <> d.unit_price
        ) as c
        join orders as o
            on o.order_id = c.order_id
        where o.status <> N'новый'
    ) as composition;
    if @list is not null
    begin
        set @message = concat(
            N'Состав заказа можно менять только в статусе «новый», заказ № ', @list
        );
        rollback;
        throw 50122, @message, 1;
    end;

    -- снимок можно заменить и в работе: так дизайнер подбирает кадры для макета
    select @list = string_agg(photos_changed.order_id, N', ')
    from (
        select distinct i.order_id
        from inserted as i
        join deleted as d
            on d.order_item_id = i.order_item_id
        join orders as o
            on o.order_id = i.order_id
        where i.photo_id is distinct from d.photo_id
            and o.status not in (N'новый', N'в работе')
    ) as photos_changed;
    if @list is not null
    begin
        set @message = concat(
            N'Снимки заказа можно менять только в статусах «новый» и «в работе», заказ № ', @list
        );
        rollback;
        throw 50122, @message, 1;
    end;
end;
go
