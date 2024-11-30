create table program_kinds(
    id integer primary key not null,
    name text not null
);

insert into program_kinds(id, name) values
    (1, 'bachelor'),
    (2, 'specialist'),
    (3, 'master');

create table programs(
    id serial primary key not null,
    name text not null,
    faculty_id integer not null,
    kind_id integer not null,
    unique (name),
    foreign key (faculty_id) references faculties(id),
    foreign key (kind_id) references program_kinds(id)
);
