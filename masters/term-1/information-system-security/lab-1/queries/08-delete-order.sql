-- Удаление отменённых заказов: позиции удаляются каскадно (on delete cascade)
select o.order_id, o.status, count(i.order_item_id) as items
from orders as o
    left join order_items as i on i.order_id = o.order_id
group by o.order_id, o.status
order by o.order_id;

delete from orders
where status = N'отменён';

select o.order_id, o.status, count(i.order_item_id) as items
from orders as o
    left join order_items as i on i.order_id = o.order_id
group by o.order_id, o.status
order by o.order_id;

-- Оплаченный заказ удалить нельзя: на него ссылается таблица payments
delete from orders
where order_id = 4;
