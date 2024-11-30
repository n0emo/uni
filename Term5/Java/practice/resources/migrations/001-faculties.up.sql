create table faculties(
    id serial primary key not null,
    name text not null,
    unique (name)
);
