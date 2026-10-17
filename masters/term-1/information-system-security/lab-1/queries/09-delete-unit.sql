-- Часть, в которой проходят службу военнослужащие, удалить нельзя
delete from military_units
where designation = N'в/ч 12345';

-- Часть без военнослужащих и съёмок удаляется
delete from military_units
where designation = N'в/ч 45678';

select unit_id, designation, garrison
from military_units;

-- Клиент без заказов, съёмок и родственных связей удаляется
delete from customers
output deleted.customer_id, deleted.last_name, deleted.first_name
where customer_id not in (select customer_id from orders)
    and customer_id not in (select customer_id from relatives)
    and customer_id not in (
        select customer_id
        from photo_sessions
        where customer_id is not null
    );
