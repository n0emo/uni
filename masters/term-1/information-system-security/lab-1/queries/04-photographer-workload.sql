-- Число съёмок и снимков у каждого фотографа и итоги проверки снимков
select
    e.last_name + N' ' + e.first_name as photographer,
    count(distinct ps.session_id) as sessions,
    count(p.photo_id) as photos,
    sum(iif(p.review_status = N'одобрена', 1, 0)) as approved,
    sum(iif(p.review_status = N'отклонена', 1, 0)) as rejected,
    sum(iif(p.review_status = N'на проверке', 1, 0)) as pending
from employees as e
    join photo_sessions as ps on ps.photographer_id = e.employee_id
    join photos as p on p.session_id = ps.session_id
where e.position = N'фотограф'
group by e.last_name, e.first_name
order by e.last_name;
