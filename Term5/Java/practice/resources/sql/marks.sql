-- :name get-kinds :? :*
select
    name,
    title
from
    mark_kinds;

-- :name get-all :? :*
select
    m.id as id,
    m.kind as kind,
    m.study_term as "study-term",
    coalesce(c.discipline_id, e.discipline_id) as "discipline-id",
    d.name as discipline,
    f.name as faculty,
    e."value" as "value",
    p.description as description
from
    marks m
left join
    credit_marks c
on
    c.mark_id = m.id
left join
    exam_marks e
on
    e.mark_id = m.id
left join
    practice_marks p
on
    p.mark_id = m.id
left join
    disciplines d
on
    d.id = coalesce(c.discipline_id, e.discipline_id)
left join
    faculties f
on
    f.id = d.faculty_id
where
    m.card_id = :card-id;

-- :name insert-mark :<! :1
insert into
    marks(kind, card_id, study_term)
values
    (:kind, :card-id, :study-term)
returning id;

-- :name insert-credit :!
insert into
    credit_marks(mark_id, discipline_id)
values
    (:mark-id, :discipline-id);

-- :name insert-exam :!
insert into
    exam_marks(mark_id, discipline_id, "value")
values
    (:mark-id, :discipline-id, :value);

-- :name insert-practice :!
insert into
    practice_marks(mark_id, description)
values
    (:mark-id, :description);
