-- :name insert :!
insert into
    faculties(name)
values
    (:name);

-- :name get-all :? :*
select
    id,
    name
from
    faculties;

-- :name delete-by-id :!
delete from
    faculties
where
    id = :id;
