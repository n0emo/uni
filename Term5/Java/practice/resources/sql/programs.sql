-- :name get-all :? :*
select
    p.id as id,
    p.name as name,
    p.faculty_id as "faculty-id",
    f.name as faculty,
    p.kind_id as "kind-id",
    k.name as kind
from
    programs p
join
    faculties f
on
    p.faculty_id = f.id
join
    program_kinds k
on
    p.kind_id = k.id;

-- :name get-kinds :? :*
select
    id,
    name
from
    program_kinds;

-- :name get-by-id :? :1
select
    p.id as id,
    p.name as name,
    p.faculty_id as "faculty-id",
    f.name as faculty,
    p.kind_id as "kind-id",
    k.name as kind
from
    programs p
join
    faculties f
on
    p.faculty_id = f.id
join
    program_kinds k
on
    p.kind_id = k.id
where
    p.id = :id;

-- :name insert :!
insert into
    programs(name, faculty_id, kind_id)
values
    (:name, :faculty-id, :kind-id);

-- :name update-program :!
update
    programs
set
    name = :name,
    faculty_id = :faculty-id,
    kind_id = :kind-id
where
    id = :id;

-- :name delete-by-id :!
delete from
    programs
where
    id = :id;
