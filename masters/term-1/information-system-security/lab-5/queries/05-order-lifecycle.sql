-- Полный путь заказа 8: статусы по порядку, оплата, выдача; заданная вручную дата игнорируется
begin transaction;
update orders set status = N'в работе' where order_id = 8;
update orders set status = N'готов' where order_id = 8;
insert into payments (order_id, amount, method)
values (8, 7640, N'карта');
update orders
set status = N'выдан', issued_at = '2020-01-01'
where order_id = 8;
select order_id, status, total_amount, iif(convert(date, issued_at) = convert(date, sysdatetime()), N'сегодня', N'другая дата') as issued_at
from orders
where order_id = 8;
rollback;
go

-- Пропуск этапа
update orders
set status = N'готов'
where order_id = 8;
go

-- Выданные и отменённые заказы не меняются
update orders
set status = N'готов'
where order_id = 1;
go
update orders
set designer_id = 6
where order_id = 7;
go

-- Из трёх заказов 6 и 8 переходят корректно, а 4 из «готов» возвращается в работу: откат всех
update orders
set status = N'в работе'
where order_id in (6, 8, 4);
go
select order_id, status from orders where order_id in (4, 6, 8);
go

-- Заказ 2 оплачен на 7000 из 15540: выдать его нельзя
update orders
set status = N'готов'
where order_id = 2;
go
update orders
set status = N'выдан'
where order_id = 2;
go
select order_id, status, issued_at from orders where order_id = 2;
go

-- Платежи принимает бухгалтер
execute as user = N'belova_tn';
go

-- Доплата остатка по заказу 2 принимается
begin transaction;
insert into payments (order_id, amount, method)
values (2, 8540, N'перевод');
select order_id, sum(amount) as paid from payments where order_id = 2 group by order_id;
rollback;
go

-- Переплата
insert into payments (order_id, amount, method)
values (2, 8541, N'перевод');
go

-- Платёж по отменённому заказу 7
insert into payments (order_id, amount, method)
values (7, 100, N'наличные');
go

-- Платёж раньше создания заказа
insert into payments (order_id, amount, paid_at, method)
values (8, 100, '2026-10-01', N'наличные');
go

-- Два платежа: первый допустим, второй превышает сумму заказа 6 (2200): не принимается ни один
insert into payments (order_id, amount, method)
values (2, 1000, N'карта'), (6, 3000, N'карта');
go
select count(*) as payments from payments;
go
revert;
go

-- Оплата выданного заказа должна остаться полной
delete from payments
where payment_id = 2;
go
select count(*) as payments from payments;
go
