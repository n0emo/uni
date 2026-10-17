use pamyatny_kadr;
go

-- Триггерные связки не сработают, если вложенные триггеры выключены на сервере
if (select convert(int, value_in_use) from sys.configurations where name = N'nested triggers') <> 1
    throw 50100, N'Вложенные триггеры выключены (sp_configure ''nested triggers'')', 1;

-- Прямая рекурсия отключена явно: связки вызывают друг друга через разные таблицы, а не себя
alter database current set recursive_triggers off;
go

-- Прежде чем включать триггеры, убеждаемся, что действующие данные требованиям удовлетворяют
declare @violations nvarchar(max);

with
paid as (
    select order_id, sum(amount) as amount
    from payments
    group by order_id
),
items as (
    select order_id, sum(quantity * unit_price) as amount
    from order_items
    group by order_id
),
violations (requirement, details) as (
    select 1, concat(N'позиция ', oi.order_item_id, N': снимок не одобрен')
    from order_items as oi
    join photos as p
        on p.photo_id = oi.photo_id
    join photo_sessions as s
        on s.session_id = p.session_id
    where s.unit_id is not null and p.review_status <> N'одобрена'

    union all
    select 1, concat(N'позиция ', oi.order_item_id, N': снимок другого клиента')
    from order_items as oi
    join photos as p
        on p.photo_id = oi.photo_id
    join photo_sessions as s
        on s.session_id = p.session_id
    join orders as o
        on o.order_id = oi.order_id
    where s.customer_id is not null and s.customer_id <> o.customer_id

    union all
    select 2, concat(N'заказ ', o.order_id, N': заказчик не родственник')
    from orders as o
    where o.soldier_id is not null
        and not exists (
            select 1
            from relatives as r
            where r.soldier_id = o.soldier_id and r.customer_id = o.customer_id
        )

    union all
    select 3, concat(N'заказ ', o.order_id, N': сумма не равна сумме позиций')
    from orders as o
    left join items as t
        on t.order_id = o.order_id
    where o.total_amount <> coalesce(t.amount, 0)

    union all
    select 4, concat(N'заказ ', o.order_id, N': оплата не соответствует состоянию')
    from orders as o
    left join paid as p
        on p.order_id = o.order_id
    where coalesce(p.amount, 0) > o.total_amount
        or o.status = N'выдан' and coalesce(p.amount, 0) <> o.total_amount

    union all
    select 4, concat(N'платёж ', p.payment_id, N': дата или статус заказа')
    from payments as p
    join orders as o
        on o.order_id = p.order_id
    where p.paid_at < o.created_at or o.status = N'отменён'

    union all
    select 6, concat(N'снимок ', ps.photo_id, N', военнослужащий ', ps.soldier_id)
    from photo_soldiers as ps
    join photos as p
        on p.photo_id = ps.photo_id
    join photo_sessions as s
        on s.session_id = p.session_id
    join soldiers as sd
        on sd.soldier_id = ps.soldier_id
    where s.unit_id is distinct from sd.unit_id
        or s.session_date < sd.call_up_date
        or s.session_date > sd.discharge_date
)
select @violations = string_agg(concat(N'№ ', requirement, N' — ', details), N'; ')
from violations;

if @violations is not null
begin
    set @violations = concat(N'Данные нарушают требования целостности: ', left(@violations, 1800));
    throw 50109, @violations, 1;
end;
go
