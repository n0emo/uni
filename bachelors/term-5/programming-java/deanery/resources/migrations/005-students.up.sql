create table student_cards(
    id serial primary key not null,
    group_id integer not null,
    foreign key (group_id) references groups(id)
);

create table students(
    id serial primary key not null,
    name text not null,
    surname text not null,
    fathersname text,
    year_of_birth integer not null,
    card_id integer not null,
    foreign key (card_id) references student_cards(id)
);
