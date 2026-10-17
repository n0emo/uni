-- Бухгалтер: платежи и суммы заказов
execute as user = N'belova_tn';
select user_name() as current_user_name;
go

select o.order_id, o.status, o.total_amount, coalesce(sum(p.amount), 0) as paid
from orders as o
    left join payments as p on p.order_id = o.order_id
group by o.order_id, o.status, o.total_amount
order by o.order_id;
go

begin transaction;

insert into payments (order_id, amount, method)
values (8, 3000.00, N'карта');

select payment_id, order_id, amount, method
from payments
where order_id = 8;

rollback;
go

update payments
set amount = amount + 1000
where payment_id = 1;
go

delete from payments
where payment_id = 1;
go

update orders
set total_amount = 0
where order_id = 8;
go

select order_id, soldier_id, manager_id
from orders;
go

select photo_id, file_name
from photos;
go

select last_name
from soldiers;
go

revert;
go
