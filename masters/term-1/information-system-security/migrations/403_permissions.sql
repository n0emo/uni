use pamyatny_kadr;
go

-- Вердикт теперь выносится только процедурой review_photo: прямое право на столбцы отзывается
revoke update on photos (review_status, reviewer_id, reviewed_at, review_comment)
    from role_security_officer;

deny update on photos (review_signature, review_key_thumbprint)
    to role_director, role_manager, role_photographer, role_designer,
        role_security_officer, role_accountant;

grant execute on review_photo to role_security_officer;
grant select on v_photo_reviews to role_director, role_manager, role_security_officer;
go
