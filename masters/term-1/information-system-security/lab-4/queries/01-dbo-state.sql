-- Ключ подписи, его владелец и параметры
select
    k.name as key_name,
    u.name as owner,
    k.algorithm_desc,
    k.key_length,
    convert(nvarchar(20), k.thumbprint, 1) as thumbprint
from sys.asymmetric_keys as k
join sys.database_principals as u
    on u.principal_id = k.principal_id;
go

-- Подписанная запись: снимок 3 отклонён, подпись и отпечаток ключа хранятся рядом с вердиктом
select
    photo_id,
    review_status,
    reviewer_id,
    left(convert(nvarchar(max), review_signature, 1), 14) + N'…' as signature,
    datalength(review_signature) as sig_bytes,
    convert(nvarchar(20), review_key_thumbprint, 1) as thumbprint
from photos
where photo_id in (3, 7);
go

-- Подписываемая строка снимка 3
select dbo.fn_photo_review_payload(
    photo_id, file_name, review_status, reviewer_id, reviewed_at, review_comment
) as payload
from photos
where photo_id = 3;
go

-- Проверка всех подписей, сделанных при развёртывании
select
    signature_status,
    count(*) as photos
from v_photo_reviews
group by signature_status;
go
