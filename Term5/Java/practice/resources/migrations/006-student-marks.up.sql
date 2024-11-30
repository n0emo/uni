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
