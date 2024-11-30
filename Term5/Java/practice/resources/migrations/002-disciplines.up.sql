create table disciplines(
    id serial primary key not null,
    name text not null,
    faculty_id integer not null,
    unique(name),
    foreign key (faculty_id) references faculties(id)
);
