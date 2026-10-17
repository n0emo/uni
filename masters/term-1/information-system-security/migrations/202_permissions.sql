use pamyatny_kadr;
go

-- role_staff: справочники, доступные любому сотруднику
grant select on products to role_staff;
grant select on employees (employee_id, last_name, first_name, patronymic, position)
    to role_staff;

-- role_director: читает всё, не изменяет ничего
grant select on schema::dbo to role_director;

-- role_manager: клиенты, родственные связи и заказы
grant select, insert, update on customers to role_manager;
grant select, insert, update, delete on relatives to role_manager;
grant select, insert, update on orders to role_manager;
grant select, insert, update, delete on order_items to role_manager;
grant select on soldiers (
    soldier_id, unit_id, last_name, first_name, patronymic, military_rank, discharge_date
) to role_manager;
grant select on military_units (unit_id, designation) to role_manager;
grant select on photo_sessions to role_manager;
grant select on photos (photo_id, session_id, file_name, taken_at, review_status)
    to role_manager;
grant select on photo_soldiers to role_manager;

-- role_photographer: съёмки и снимки без права менять результат проверки;
-- снимки добавляются процедурой add_photo (ниже), права insert на photos у роли нет
grant select, insert, update on photo_sessions to role_photographer;
grant select on photos to role_photographer;
grant update on photos (file_name, taken_at) to role_photographer;
grant select, insert, delete on photo_soldiers to role_photographer;
grant select on soldiers (soldier_id, unit_id, last_name, first_name, patronymic, military_rank)
    to role_photographer;
grant select on military_units (unit_id, designation) to role_photographer;
grant select on customers (customer_id, last_name, first_name) to role_photographer;

-- role_designer: ход выполнения заказов без цен и сумм
grant select on orders (
    order_id, customer_id, soldier_id, manager_id, designer_id, created_at, status
) to role_designer;
grant update on orders (designer_id, status) to role_designer;
grant select on order_items (order_item_id, order_id, product_id, photo_id, quantity)
    to role_designer;
grant update on order_items (photo_id) to role_designer;
grant select on photos (photo_id, session_id, file_name, taken_at, review_status)
    to role_designer;
grant select on photo_sessions (session_id, kind, session_date) to role_designer;
grant select on photo_soldiers to role_designer;
grant select on soldiers (soldier_id, last_name, first_name, patronymic, military_rank)
    to role_designer;
grant select on military_units (unit_id, designation) to role_designer;
grant select on customers (customer_id, last_name, first_name) to role_designer;

-- role_security_officer: сведения о частях и военнослужащих и вердикты по снимкам
grant select, insert, update on military_units to role_security_officer;
grant select, insert, update on soldiers to role_security_officer;
grant select on photo_sessions to role_security_officer;
grant select on photos to role_security_officer;
grant update on photos (review_status, reviewer_id, reviewed_at, review_comment)
    to role_security_officer;
grant select on photo_soldiers to role_security_officer;

-- role_accountant: платежи и суммы заказов
grant select, insert on payments to role_accountant;
grant select on orders (order_id, customer_id, created_at, status, total_amount, issued_at)
    to role_accountant;
grant select on order_items (order_item_id, order_id, product_id, quantity, unit_price)
    to role_accountant;
grant select on customers (customer_id, last_name, first_name, phone) to role_accountant;
go

-- insert нельзя ограничить столбцами, поэтому статус проверки нового снимка выставляет процедура
create or alter procedure add_photo
    @session_id int,
    @file_name nvarchar(100),
    @taken_at datetime2(0)
as
begin
    set nocount on;

    insert into photos (session_id, file_name, taken_at, review_status)
    select
        session_id,
        @file_name,
        @taken_at,
        iif(unit_id is null, N'не требуется', N'на проверке')
    from photo_sessions
    where session_id = @session_id;

    if @@rowcount = 0
        throw 50001, N'Съёмка не найдена', 1;
end;
go

grant execute on add_photo to role_photographer;
go

-- Запреты перекрывают любые гранты, в том числе выданные позже или через другие роли
deny select on soldiers (personal_number, birth_date, call_up_date)
    to role_manager, role_photographer, role_designer, role_accountant;
deny select on military_units (garrison, contact_phone)
    to role_manager, role_photographer, role_designer, role_accountant;
deny update on photos (review_status, reviewer_id, reviewed_at, review_comment)
    to role_director, role_manager, role_photographer, role_designer, role_accountant;
go
