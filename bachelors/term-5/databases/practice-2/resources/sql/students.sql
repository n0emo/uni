-- :name get-students-short :? :*
select
    id,
    name,
    surname,
    fathersname,
    year_of_birth as "year-of-birth"
from
    students;

-- :name get-student-by-id :? :1
select
    s.id as id,
    s.name as name,
    s.surname as surname,
    s.fathersname as fathersname,
    s.year_of_birth as "year-of-birth",
    s.card_id as "card-id",
    g.year_formed as "year-of-admission",
    g.id as "group-id",
    g.name as group
from
    students s
join
    student_cards c
on
    s.card_id = c.id
join
    groups g
on
    c.group_id = g.id
where
    s.id = :id;

-- :name insert-card :<! :1
insert into student_cards(group_id)
values
    (:group-id)
returning
    id;

-- :name insert-student :!
insert into students(
    name,
    surname,
    fathersname,
    year_of_birth,
    card_id
)
values(
    :name,
    :surname,
    :fathersname,
    :year-of-birth,
    :card-id
);

-- :name update-student :<! :1
update
    students
set
    name = :name,
    surname = :surname,
    fathersname = :fathersname,
    year_of_birth = :year-of-birth
where
    id = :id
returning
    card_id;

-- :name update-card :!
update
    student_cards
set
    group_id = :group-id
where
    id = :id;

-- :name delete-student-by-id :!
delete from
    students
where
    id = :id;

-- :name delete-card-by-id :!
delete from
    student_cards
where
    id = :id;
