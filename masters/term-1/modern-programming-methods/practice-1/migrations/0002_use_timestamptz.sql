alter table links alter column created_at type timestamptz;
alter table clicks alter column clicked_at type timestamptz;

create index clicks_link_id_idx on clicks(link_id);
