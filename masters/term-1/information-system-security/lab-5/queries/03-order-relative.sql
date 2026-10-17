execute as user = N'lebedeva_is';
go

-- Отец (клиент 2) заказывает для сына (военнослужащий 1)
begin transaction;
insert into orders (customer_id, soldier_id, manager_id)
values (2, 1, 2);
select top (1) order_id, customer_id, soldier_id, status, total_amount
from orders
order by order_id desc;
rollback;
go

-- Клиент 4 — мать военнослужащего 3, а не 1
insert into orders (customer_id, soldier_id, manager_id)
values (4, 1, 2);
go

-- Первая строка корректна, вторая нет: не создаётся ни один заказ
insert into orders (customer_id, soldier_id, manager_id)
values (2, 1, 2), (4, 1, 2);
go
select count(*) as orders from orders;
go

-- Перенос заказа 2 на другого военнослужащего: клиент 1 ему не родственник
update orders
set soldier_id = 3
where order_id = 2;
go

-- Связь клиента 4 с военнослужащим 3 нужна только выданному заказу 3: удалить можно
begin transaction;
delete from relatives
where soldier_id = 3 and customer_id = 4;
select count(*) as relatives from relatives;
rollback;
go

-- Заказ 2 клиента 1 для военнослужащего 1 в работе: связь разорвать нельзя
delete from relatives
where soldier_id = 1 and customer_id = 1;
go

-- Из трёх удаляемых связей (1, 1) защищена заказом 2: не удаляется ни одна
delete from relatives
where soldier_id in (1, 3);
go
select count(*) as relatives from relatives;
go
revert;
go
