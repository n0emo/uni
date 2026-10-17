-- Менеджер по заказам: клиенты и заказы, но без персональных данных военнослужащих
execute as user = N'lebedeva_is';
select user_name() as current_user_name;
go

begin transaction;

insert into customers (last_name, first_name, phone)
values (N'Тестов', N'Тест', N'+7 900 000-00-00');

update orders
set status = N'в работе'
where order_id = 8;

insert into order_items (order_id, product_id, quantity, unit_price)
select 8, product_id, 1, price
from products
where product_id = 8;

rollback;
go

select soldier_id, last_name, first_name, military_rank
from soldiers
where unit_id = 1;
go

select *
from soldiers;
go

select soldier_id, personal_number
from soldiers;
go

select designation, garrison
from military_units;
go

select payment_id, amount
from payments;
go

delete from customers
where customer_id = 1;
go

update photos
set review_status = N'одобрена'
where photo_id = 7;
go

revert;
go
