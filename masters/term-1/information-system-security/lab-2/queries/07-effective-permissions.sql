-- Соответствие сотрудников логинам и ролям
select e.last_name, e.position, r.name as db_role, u.name as db_user
from employees as e
    join sys.database_principals as u on u.name = e.login_name
    join sys.database_role_members as m on m.member_principal_id = u.principal_id
    join sys.database_principals as r on r.principal_id = m.role_principal_id
where r.name <> N'role_staff'
order by e.employee_id;
go

-- Вложенность ролей
select r.name as parent_role, c.name as member_role
from sys.database_role_members as m
    join sys.database_principals as r on r.principal_id = m.role_principal_id
    join sys.database_principals as c on c.principal_id = m.member_principal_id
where c.type = 'R'
order by c.name;
go

-- Права роли менеджера: на таблицу целиком (NULL в столбце columns) и на отдельные столбцы
select
    object_name(p.major_id) as table_name,
    p.state_desc,
    p.permission_name,
    string_agg(col_name(p.major_id, p.minor_id), N', ')
        within group (order by p.minor_id) as columns
from sys.database_permissions as p
    join sys.database_principals as r on r.principal_id = p.grantee_principal_id
where r.name = N'role_manager'
    and p.class = 1
group by p.major_id, p.state_desc, p.permission_name
order by table_name, p.state_desc, p.permission_name;
go

-- Эффективные права сотрудника: fn_my_permissions учитывает все роли
execute as user = N'novikova_ad';
select permission_name, subentity_name
from fn_my_permissions(N'orders', N'object')
order by permission_name, subentity_name;
revert;
go
