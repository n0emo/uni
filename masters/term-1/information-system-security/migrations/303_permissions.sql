use pamyatny_kadr;
go

-- Фотографы работают со съёмками только через представление
revoke select, insert, update on photo_sessions from role_photographer;
grant select, insert, update on v_my_photo_sessions to role_photographer;

-- Остальные роли теряют доступ к месту съёмки: столбцы выдаются явно, без location_encrypted
revoke select on photo_sessions from role_manager, role_security_officer;
grant select on photo_sessions (
    session_id, kind, unit_id, customer_id, photographer_id, session_date
) to role_manager, role_security_officer;

deny select on photo_sessions (location_encrypted)
    to role_manager, role_designer, role_security_officer, role_photographer;
go
