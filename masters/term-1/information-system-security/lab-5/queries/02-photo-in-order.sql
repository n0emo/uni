-- Допустимо: одобренный снимок военной съёмки и снимок гражданской съёмки того же клиента
begin transaction;
insert into order_items (order_id, product_id, photo_id, quantity)
values (8, 5, 5, 2), (6, 5, 19, 1);
select order_id, photo_id, quantity, unit_price
from order_items
where photo_id in (5, 19) and order_id in (6, 8);
rollback;
go

-- Снимок 7 ещё на проверке
insert into order_items (order_id, product_id, photo_id, quantity)
values (8, 5, 7, 1);
go

-- Снимок 17 снят для клиента 13, а заказ оформлен клиентом 3
insert into order_items (order_id, product_id, photo_id, quantity)
values (8, 5, 17, 1);
go

-- Из двух строк первая корректна, вторая нет: не добавляется ни одна
insert into order_items (order_id, product_id, photo_id, quantity)
values (8, 5, 5, 2), (8, 5, 7, 1);
go
select order_item_id, product_id, photo_id from order_items where order_id = 8;
go

-- Замена снимка в существующей позиции
update order_items
set photo_id = 7
where order_id = 8 and photo_id = 4;
go

-- Смена заказчика оставила бы в заказе 6 снимок клиента 14
update orders
set customer_id = 15
where order_id = 6;
go

-- Смена заказчика съёмки 7 оставила бы тот же снимок в чужом заказе
update photo_sessions
set customer_id = 15
where session_id = 7;
go

-- То же от имени фотографа через представление съёмок
execute as user = N'kuznetsov_pa';
go
update v_my_photo_sessions
set customer_id = 15
where session_id = 7;
go
revert;
go
select session_id, customer_id from photo_sessions where session_id = 7;
go
