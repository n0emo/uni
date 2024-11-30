-- :name get-all :? :*
select
    d.id as id,
    d.name as name,
    f.name as faculty
from
    disciplines d
join
    faculties f
on
    d.faculty_id = f.id;

-- :name get-by-id :? :1
select
    d.id as id,
    d.name as name,
    d.faculty_id as "faculty-id",
    f.name as faculty
from
    disciplines d
join
    faculties f
on
    d.faculty_id = f.id
where
    d.id = :id;

-- :name insert :!
insert into
    disciplines(name, faculty_id)
values
    (:name, :faculty-id);

-- :name update :!
update
    disciplines
set
    name = :name,
    faculty_id = :faculty-id
where
    id = :id;

-- :name delete-by-id :!
delete from
    disciplines
where
    id = :id;
