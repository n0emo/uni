use pamyatny_kadr;
go

-- Роли категорий наследуют права role_staff
alter role role_staff add member role_director;
alter role role_staff add member role_manager;
alter role role_staff add member role_photographer;
alter role role_staff add member role_designer;
alter role role_staff add member role_security_officer;
alter role role_staff add member role_accountant;

alter role role_director add member sokolov_av;
alter role role_manager add member lebedeva_is;
alter role role_manager add member morozov_do;
alter role role_photographer add member kuznetsov_pa;
alter role role_photographer add member vasileva_ei;
alter role role_designer add member novikova_ad;
alter role role_security_officer add member orlov_mu;
alter role role_accountant add member belova_tn;
go
