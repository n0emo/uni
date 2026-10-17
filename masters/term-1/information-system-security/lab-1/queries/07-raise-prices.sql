-- Повышение цен на фотокниги на 10 % с округлением до 100 рублей
select product_id, name, price
from products
where category = N'фотокнига';

update products
set price = round(price * 1.1, -2)
where category = N'фотокнига';

select product_id, name, price
from products
where category = N'фотокнига';

-- Цена в уже оформленных заказах зафиксирована в order_items и не изменилась
select order_id, product_id, quantity, unit_price
from order_items
where product_id in (1, 2, 3)
order by order_id;
