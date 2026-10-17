-- Директор: читает всё, изменить ничего не может
execute as user = N'sokolov_av';
select user_name() as current_user_name;
go

select top (3) soldier_id, last_name, personal_number, birth_date
from soldiers
order by soldier_id;
go

select top (3) unit_id, designation, garrison
from military_units
order by unit_id;
go

select top (3) payment_id, order_id, amount, method
from payments
order by payment_id;
go

update products
set price = price * 2;
go

delete from payments
where payment_id = 1;
go

insert into customers (last_name, first_name, phone)
values (N'Тестов', N'Тест', N'+7 900 000-00-00');
go

revert;
go
