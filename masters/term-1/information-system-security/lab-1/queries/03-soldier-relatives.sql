-- Родственники военнослужащих, увольняющихся в запас до конца 2026 года
select
    s.last_name + N' ' + s.first_name as soldier,
    s.discharge_date,
    r.kinship,
    c.last_name + N' ' + c.first_name as relative,
    c.phone
from soldiers as s
    join relatives as r on r.soldier_id = s.soldier_id
    join customers as c on c.customer_id = r.customer_id
where s.discharge_date < '2027-01-01'
order by s.discharge_date, s.last_name;
