use pamyatny_kadr;
go

-- Требование 4. Жизненный цикл заказа: допустимые переходы статуса, дата выдачи ставится
-- автоматически, выдать можно только полностью оплаченный заказ, платежи не превышают долг
-- и не принимаются по отменённым заказам. Связка: заказы и платежи

-- instead of здесь оправдан: ограничение ck_orders_issued требует issued_at одновременно со
-- статусом «выдан», а after-триггер срабатывает уже после проверки ограничений
create or alter trigger tr_orders_issue_stamp
on orders
instead of update
as
begin
    set nocount on;
    if not exists (select 1 from inserted)
        return;

    update o
    set customer_id = i.customer_id,
        soldier_id = i.soldier_id,
        manager_id = i.manager_id,
        designer_id = i.designer_id,
        created_at = i.created_at,
        status = i.status,
        total_amount = i.total_amount,
        issued_at = iif(i.status = N'выдан', coalesce(o.issued_at, sysdatetime()), null)
    from orders as o
    join inserted as i
        on i.order_id = o.order_id;
end;
go

create or alter trigger tr_orders_status_guard
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
    where i.status <> N'новый'
        and not exists (select 1 from deleted as d where d.order_id = i.order_id);
    if @list is not null
    begin
        set @message = concat(N'Заказ создаётся в статусе «новый», заказ № ', @list);
        rollback;
        throw 50132, @message, 1;
    end;

    -- завершённые заказы не изменяются
    select @list = string_agg(i.order_id, N', ')
    from inserted as i
    join deleted as d
        on d.order_id = i.order_id
    where d.status in (N'выдан', N'отменён')
        and exists (
            select i.customer_id, i.soldier_id, i.manager_id, i.designer_id,
                i.created_at, i.status, i.total_amount, i.issued_at
            except
            select d.customer_id, d.soldier_id, d.manager_id, d.designer_id,
                d.created_at, d.status, d.total_amount, d.issued_at
        );
    if @list is not null
    begin
        set @message = concat(N'Выданный или отменённый заказ изменять нельзя, заказ № ', @list);
        rollback;
        throw 50138, @message, 1;
    end;

    select @list = string_agg(concat(i.order_id, N' (', d.status, N' → ', i.status, N')'), N', ')
    from inserted as i
    join deleted as d
        on d.order_id = i.order_id
    where i.status <> d.status
        and not exists (
            select 1
            from (
                values
                    (N'новый', N'в работе'),
                    (N'в работе', N'готов'),
                    (N'готов', N'выдан'),
                    (N'новый', N'отменён'),
                    (N'в работе', N'отменён'),
                    (N'готов', N'отменён')
            ) as t (from_status, to_status)
            where t.from_status = d.status and t.to_status = i.status
        );
    if @list is not null
    begin
        set @message = concat(N'Недопустимый переход статуса, заказ № ', @list);
        rollback;
        throw 50131, @message, 1;
    end;

    select @list = string_agg(i.order_id, N', ')
    from inserted as i
    join deleted as d
        on d.order_id = i.order_id
    where i.status = N'выдан'
        and d.status <> N'выдан'
        and i.total_amount <> (
            select coalesce(sum(p.amount), 0)
            from payments as p
            where p.order_id = i.order_id
        );
    if @list is not null
    begin
        set @message = concat(N'Заказ нельзя выдать без полной оплаты, заказ № ', @list);
        rollback;
        throw 50133, @message, 1;
    end;
end;
go

create or alter trigger tr_payments_guard
on payments
after insert, update, delete
as
begin
    set nocount on;
    if not exists (select 1 from inserted) and not exists (select 1 from deleted)
        return;

    declare @list nvarchar(1000), @message nvarchar(2048);

    select @list = string_agg(i.payment_id, N', ')
    from inserted as i
    join orders as o
        on o.order_id = i.order_id
    where o.status = N'отменён'
        and not exists (select 1 from deleted as d where d.payment_id = i.payment_id);
    if @list is not null
    begin
        set @message = concat(N'Платёж по отменённому заказу принять нельзя, платёж № ', @list);
        rollback;
        throw 50135, @message, 1;
    end;

    select @list = string_agg(i.payment_id, N', ')
    from inserted as i
    join orders as o
        on o.order_id = i.order_id
    where i.paid_at < o.created_at;
    if @list is not null
    begin
        set @message = concat(N'Платёж не может быть раньше создания заказа, платёж № ', @list);
        rollback;
        throw 50136, @message, 1;
    end;

    select @list = string_agg(concat(o.order_id, N' (оплачено ', t.paid, N' из ', o.total_amount, N')'), N', ')
    from (
        select order_id from inserted
        union
        select order_id from deleted
    ) as a
    join orders as o
        on o.order_id = a.order_id
    cross apply (
        select coalesce(sum(p.amount), 0) as paid
        from payments as p
        where p.order_id = o.order_id
    ) as t
    where t.paid > o.total_amount;
    if @list is not null
    begin
        set @message = concat(N'Платежи превысили сумму заказа, заказ № ', @list);
        rollback;
        throw 50134, @message, 1;
    end;

    select @list = string_agg(o.order_id, N', ')
    from (
        select order_id from inserted
        union
        select order_id from deleted
    ) as a
    join orders as o
        on o.order_id = a.order_id
    where o.status = N'выдан'
        and o.total_amount <> (
            select coalesce(sum(p.amount), 0)
            from payments as p
            where p.order_id = o.order_id
        );
    if @list is not null
    begin
        set @message = concat(N'Оплата выданного заказа должна остаться полной, заказ № ', @list);
        rollback;
        throw 50137, @message, 1;
    end;
end;
go
