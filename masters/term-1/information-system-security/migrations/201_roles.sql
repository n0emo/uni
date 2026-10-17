use pamyatny_kadr;
go

-- По одной роли на категорию сотрудников и базовая роль со сведениями, нужными всем
create role role_staff authorization dbo;
create role role_director authorization dbo;
create role role_manager authorization dbo;
create role role_photographer authorization dbo;
create role role_designer authorization dbo;
create role role_security_officer authorization dbo;
create role role_accountant authorization dbo;
go
