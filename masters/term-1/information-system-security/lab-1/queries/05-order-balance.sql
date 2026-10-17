-- Заказы с внесённой оплатой и остатком к доплате
select
    o.order_id,
    c.last_name as customer,
    o.status,
    o.total_amount,
    coalesce(paid.amount, 0) as paid,
    o.total_amount - coalesce(paid.amount, 0) as debt
from orders as o
    join customers as c on c.customer_id = o.customer_id
    left join (
        select order_id, sum(amount) as amount
        from payments
        group by order_id
    ) as paid on paid.order_id = o.order_id
order by o.order_id;
