create table groups(
    id serial primary key not null,
    name text not null,
    year_formed integer not null,
    program_id integer not null,
    unique (name),
    foreign key (program_id) references programs(id)
);
