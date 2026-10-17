use pamyatny_kadr;
go

-- Пароли учебные; check_policy применяет к ним политику сложности и блокировки Windows
create login sokolov_av
    with password = N'Sokolov#Foto2026',
        default_database = pamyatny_kadr,
        check_policy = on;
create login lebedeva_is
    with password = N'Lebedeva#Foto2026',
        default_database = pamyatny_kadr,
        check_policy = on;
create login morozov_do
    with password = N'Morozov#Foto2026',
        default_database = pamyatny_kadr,
        check_policy = on;
create login kuznetsov_pa
    with password = N'Kuznetsov#Foto2026',
        default_database = pamyatny_kadr,
        check_policy = on;
create login vasileva_ei
    with password = N'Vasileva#Foto2026',
        default_database = pamyatny_kadr,
        check_policy = on;
create login novikova_ad
    with password = N'Novikova#Foto2026',
        default_database = pamyatny_kadr,
        check_policy = on;
create login orlov_mu
    with password = N'Orlov#Foto2026',
        default_database = pamyatny_kadr,
        check_policy = on;
create login belova_tn
    with password = N'Belova#Foto2026',
        default_database = pamyatny_kadr,
        check_policy = on;
go

create user sokolov_av for login sokolov_av;
create user lebedeva_is for login lebedeva_is;
create user morozov_do for login morozov_do;
create user kuznetsov_pa for login kuznetsov_pa;
create user vasileva_ei for login vasileva_ei;
create user novikova_ad for login novikova_ad;
create user orlov_mu for login orlov_mu;
create user belova_tn for login belova_tn;
go
