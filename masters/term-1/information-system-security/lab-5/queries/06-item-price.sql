execute as user = N'lebedeva_is';
go

-- Клиент передаёт цену 1, но позиция получает цену из прайса; без цены тоже работает
begin transaction;
insert into order_items (order_id, product_id, quantity, unit_price)
values (8, 8, 1, 1.00);
insert into order_items (order_id, product_id, quantity)
values (8, 3, 1);
select i.order_item_id, p.price as price_list, i.unit_price
from order_items as i
join products as p
    on p.product_id = i.product_id
where i.order_id = 8 and i.product_id in (3, 8);
rollback;
go

-- Товар 9 снят с продажи
insert into order_items (order_id, product_id, quantity)
values (8, 9, 1);
go

-- Допустимая и недопустимая строки: не добавляется ни одна
insert into order_items (order_id, product_id, quantity)
values (8, 3, 1), (8, 9, 1);
go
select count(*) as items from order_items where order_id = 8;
go

-- Несуществующий товар доходит до внешнего ключа
insert into order_items (order_id, product_id, quantity)
values (8, 99, 1);
go

-- Цену и товар позиции менять нельзя, количество — можно
update order_items
set unit_price = 1
where order_id = 8 and product_id = 4;
go
update order_items
set product_id = 5
where order_id = 8 and product_id = 4;
go
begin transaction;
update order_items
set quantity = 8
where order_id = 8 and product_id = 4;
select order_id, total_amount from orders where order_id = 8;
rollback;
go
revert;
go

-- Новая цена в прайсе не затрагивает существующие позиции, но действует для новых
begin transaction;
update products
set price = 8000
where product_id = 1;
insert into order_items (order_id, product_id, photo_id, quantity)
values (6, 1, null, 1);
select order_id, product_id, unit_price from order_items where product_id = 1 and order_id in (6, 8);
rollback;
go
