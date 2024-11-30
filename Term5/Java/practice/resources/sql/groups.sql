-- :name get-all :? :*
select
    g.id as id,
    g.name as name,
    g.year_formed as "year-formed",
    g.program_id as "program-id",
    p.name as program
from
    groups g
join
    programs p
on
    g.program_id = p.id;

-- :name get-by-id :? :1
select
    g.id as id,
    g.name as name,
    g.year_formed as "year-formed",
    g.program_id as "program-id",
    p.name as program
from
    groups g
join
    programs p
on
    g.program_id = p.id
where
    g.id = :id;

-- :name insert :!
insert into
    groups(name, year_formed, program_id)
values
    (:name, :year-formed, :program-id);

-- :name update-group :!
update
    groups
set
    name = :name,
    year_formed = :year-formed,
    program_id = :program-id
where
    id = :id;

-- :name delete-by-id :!
delete from
    groups
where
    id = :id;
