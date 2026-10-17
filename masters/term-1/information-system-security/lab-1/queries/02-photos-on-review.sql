-- Снимки, ожидающие проверки специалистом по защите информации
select
    p.file_name,
    u.designation as unit,
    ps.kind,
    p.taken_at
from photos as p
    join photo_sessions as ps on ps.session_id = p.session_id
    join military_units as u on u.unit_id = ps.unit_id
where p.review_status = N'на проверке'
order by p.taken_at;
