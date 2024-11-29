create table students(
    id serial primary key not null,
    name text not null,
    surname text not null,
    fathersname text,
    year_of_birth integer not null
);

create table faculties(
    id serial primary key not null,
    name text not null,
    unique (name)
);

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

create table groups(
    id serial primary key not null,
    name text not null,
    year_formed integer not null,
    program_id integer not null,
    unique (name),
    foreign key (program_id) references programs(id)
);

create table student_cards(
    id serial primary key not null,
    group_id integer not null,
    foreign key (group_id) references groups(id)
);

create table disciplines(
    id serial primary key not null,
    name text not null,
    faculty_id integer not null,
    unique(name),
    foreign key (faculty_id) references faculties(id)
);

create table mark_kinds(
    id integer primary key not null,
    name text not null,
    unique(name)
);

insert into mark_kinds(id, name) values
    (1, 'credit'),
    (2, 'exam'),
    (3, 'practice');

create table marks(
    id serial primary key not null,
    kind_id integer not null,
    study_year integer not null,
    foreign key (kind_id) references mark_kinds(id)
);

create table credit_marks(
    id serial primary key not null,
    mark_id integer not null,
    discipline_id integer not null,
    foreign key (mark_id) references marks(id),
    foreign key (discipline_id) references disciplines(id)
);

create table exam_marks(
    id serial primary key not null,
    mark_id integer not null,
    discipline_id integer not null,
    value integer not null,
    foreign key (mark_id) references marks(id),
    foreign key (discipline_id) references disciplines(id)
);

create table practice_marks(
    id serial primary key not null,
    mark_id integer not null,
    description text not null,
    foreign key (mark_id) references marks(id)
);
