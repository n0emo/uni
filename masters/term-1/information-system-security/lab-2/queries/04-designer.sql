-- Дизайнер-верстальщик: ход выполнения заказов без цен и сумм
execute as user = N'novikova_ad';
select user_name() as current_user_name;
go

select order_id, soldier_id, designer_id, status
from orders
where designer_id = 6;
go

begin transaction;

update orders
set status = N'готов'
where order_id = 2;

update order_items
set photo_id = 5
where order_item_id = 5;

rollback;
go

select order_id, total_amount
from orders;
go

select *
from order_items;
go

update order_items
set unit_price = 1.00
where order_item_id = 5;
go

update orders
set manager_id = 3
where order_id = 2;
go

select designation, garrison
from military_units;
go

select payment_id, amount
from payments;
go

revert;
go
