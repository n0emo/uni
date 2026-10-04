create table links(
    id bigserial primary key,
    code text not null unique,
    target text not null,
    created_at timestamp not null default now()
);

create table clicks(
    id bigserial primary key,
    link_id bigint
        not null
        references links(id)
        on delete cascade,
    clicked_at timestamp not null default now(),
    user_agent text,
    referer text
);
