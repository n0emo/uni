-- Военнослужащие в/ч 12345 в алфавитном порядке
select
    s.personal_number,
    s.last_name + N' ' + s.first_name as soldier,
    s.military_rank,
    s.call_up_date,
    s.discharge_date
from soldiers as s
    join military_units as u on u.unit_id = s.unit_id
where u.designation = N'в/ч 12345'
order by s.last_name, s.first_name;
