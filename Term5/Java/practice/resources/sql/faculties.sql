-- :name get-all :? :*
select
    id,
    name
from
    faculties;

-- :name get-by-id :? :1
select
    id,
    name
from
    faculties
where
    id = :id;

-- :name insert :!
insert into
    faculties(name)
values
    (:name);

-- :name update-name :!
update
    faculties
set
    name = :name
where
    id = :id;

-- :name delete-by-id :!
delete from
    faculties
where
    id = :id;
