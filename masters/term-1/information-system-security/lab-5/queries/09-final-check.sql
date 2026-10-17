-- Механизмы предыдущих работ работают вместе со связками.
-- Специалист по защите информации одобряет снимок 7, подписывая вердикт (лаб. 4)
execute as user = N'orlov_mu';
go
exec review_photo @photo_id = 7, @verdict = N'одобрена', @key_password = N'Orlov#Sign2026';
go
revert;
go

-- Снимок 7, ранее отклонённый связкой, теперь можно заказать
execute as user = N'lebedeva_is';
go
insert into order_items (order_id, product_id, photo_id, quantity)
values (8, 5, 7, 1);
go
revert;
go

-- Фотограф добавляет снимок и съёмку по-прежнему через процедуру и представление (лаб. 3)
execute as user = N'vasileva_ei';
go
exec add_photo @session_id = 2, @file_name = N'ses02_0005.jpg', @taken_at = '2026-10-02 12:30:00';
go
open symmetric key key_vasileva_ei decryption by password = N'Vasileva#Key2026';
insert into v_my_photo_sessions (kind, unit_id, session_date, location)
values (N'присяга', 1, '2026-10-15', N'в/ч 12345, плац');
close symmetric key key_vasileva_ei;
go
revert;
go

-- Все подписи вердиктов действительны, а данные удовлетворяют требованиям 1–6
select signature_status, count(*) as photos
from v_photo_reviews
group by signature_status;
go
select
    (select count(*)
     from orders as o
     where o.total_amount <> coalesce(
         (select sum(quantity * unit_price) from order_items where order_id = o.order_id), 0
     )) as wrong_totals,
    (select count(*)
     from orders as o
     where o.status = N'выдан' and o.issued_at is null) as issued_without_date,
    (select count(*)
     from orders as o
     where o.soldier_id is not null and not exists (
         select 1 from relatives as r
         where r.soldier_id = o.soldier_id and r.customer_id = o.customer_id
     )) as orders_without_relative;
go
select o.order_id, o.total_amount, oi.photo_id, oi.unit_price
from orders as o
join order_items as oi
    on oi.order_id = o.order_id
where o.order_id = 8;
go
