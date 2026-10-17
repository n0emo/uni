execute as user = N'kuznetsov_pa';
go

-- Съёмка 1 проходила в в/ч 34567: отметить можно военнослужащего 11 той же части
begin transaction;
insert into photo_soldiers (photo_id, soldier_id)
values (1, 11);
select photo_id, soldier_id from photo_soldiers where photo_id = 1;
rollback;
go

-- Военнослужащий 5 служит в в/ч 23456
insert into photo_soldiers (photo_id, soldier_id)
values (1, 5);
go

-- На снимке гражданской съёмки военнослужащих отмечать нельзя
insert into photo_soldiers (photo_id, soldier_id)
values (16, 1);
go

-- Корректная и некорректная отметки в одном операторе: не добавляется ни одна
insert into photo_soldiers (photo_id, soldier_id)
values (1, 11), (1, 5);
go
select count(*) as tags from photo_soldiers;
go
revert;
go

-- Новобранец части 1 призван 10.10.2026, а съёмка 2 прошла 02.10.2026
begin transaction;
insert into soldiers (
    unit_id, personal_number, last_name, first_name, birth_date, call_up_date, discharge_date
)
values (1, N'ЭЮ-999001', N'Тестов', N'Иван', '2007-01-01', '2026-10-10', '2027-10-10');
insert into photo_soldiers (photo_id, soldier_id)
select 4, soldier_id from soldiers where personal_number = N'ЭЮ-999001';
commit;
go

-- Специалист по защите информации не может перевести военнослужащего 1 в другую часть
execute as user = N'orlov_mu';
go
update soldiers
set unit_id = 2
where soldier_id = 1;
go

-- Увольнение до съёмки с его участием
update soldiers
set discharge_date = '2026-09-01'
where soldier_id = 1;
go

-- Продление службы отметки не затрагивает
begin transaction;
update soldiers
set discharge_date = '2026-12-20'
where soldier_id = 1;
select soldier_id, discharge_date from soldiers where soldier_id = 1;
rollback;
go
revert;
go

-- Фотограф переносит съёмку 2 на дату до призыва её участников
execute as user = N'vasileva_ei';
go
update v_my_photo_sessions
set session_date = '2025-01-01'
where session_id = 2;
go
revert;
go

-- Снимок нельзя перенести в другую съёмку
update photos
set session_id = 2
where photo_id = 16;
go
