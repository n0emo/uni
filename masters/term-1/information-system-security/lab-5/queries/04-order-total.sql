-- Сумма заказа следует за позициями: вставка, изменение и удаление, в том числе в двух заказах
begin transaction;
insert into order_items (order_id, product_id, quantity)
values (8, 8, 1), (6, 2, 2);
update order_items
set quantity = 10
where order_id = 8 and product_id = 4;
delete from order_items
where order_id = 8 and product_id = 1;
select
    o.order_id,
    o.total_amount,
    (select sum(quantity * unit_price) from order_items where order_id = o.order_id) as items_sum
from orders as o
where o.order_id in (6, 8);
rollback;
go

-- Ручная правка суммы
update orders
set total_amount = 1
where order_id = 8;
go

-- Оператор затрагивает два заказа: отклоняется целиком
update orders
set total_amount = total_amount * 2
where order_id in (6, 8);
go

-- Новый заказ не может начинаться с ненулевой суммы
insert into orders (customer_id, manager_id, total_amount)
values (14, 3, 500);
go
select order_id, total_amount from orders where order_id in (6, 8);
go

-- Состав заказа меняется только в статусе «новый»: заказ 2 в работе
insert into order_items (order_id, product_id, quantity)
values (2, 4, 1);
go
update order_items
set quantity = 5
where order_id = 2 and product_id = 5;
go
delete from order_items
where order_id = 2 and product_id = 5;
go

-- Снимок в работе заменить можно, в выданном заказе 3 — нет
begin transaction;
update order_items
set photo_id = 5
where order_id = 2 and photo_id = 4;
select order_id, photo_id from order_items where order_id = 2 and product_id = 5;
rollback;
go
update order_items
set photo_id = 9
where order_id = 3 and photo_id = 8;
go

-- Позицию нельзя перенести в другой заказ
update order_items
set order_id = 6
where order_id = 8 and product_id = 4;
go

-- Сумма не может стать меньше оплаченной: платёж 7000 по заказу 8, затем удаление дорогой позиции
begin transaction;
insert into payments (order_id, amount, method)
values (8, 7000, N'карта');
delete from order_items
where order_id = 8 and product_id = 1;
commit;
go
select
    (select count(*) from payments where order_id = 8) as payments,
    (select total_amount from orders where order_id = 8) as total_amount;
go
