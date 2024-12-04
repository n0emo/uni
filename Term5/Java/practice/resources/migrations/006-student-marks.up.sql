create table mark_kinds(
    name text primary key not null,
    title text not null,
    unique(title)
);

insert into mark_kinds(name, title) values
    ('credit', 'Зачёт'),
    ('exam', 'Экзамен'),
    ('practice', 'Практика');

create table marks(
    id serial primary key not null,
    kind text not null,
    card_id integer not null,
    study_term integer not null,
    foreign key (kind) references mark_kinds(name),
    foreign key (card_id) references student_cards(id)
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
