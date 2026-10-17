-- Параметры, от которых зависят связки
select
    (select convert(int, value_in_use) from sys.configurations where name = N'nested triggers')
        as nested_triggers,
    is_recursive_triggers_on
from sys.databases
where name = db_name();
go

-- Триггеры связок: таблица, тип и события
select
    object_name(t.parent_id) as table_name,
    t.name as trigger_name,
    iif(t.is_instead_of_trigger = 1, N'instead of', N'after') as kind,
    (
        select string_agg(lower(e.type_desc), N', ')
        from sys.trigger_events as e
        where e.object_id = t.object_id
    ) as events
from sys.triggers as t
where t.parent_class = 1 and t.name like N'tr[_]%'
order by table_name, trigger_name;
go
