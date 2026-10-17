use pamyatny_kadr;
go

-- Ключ подписи: владелец — подписант, пароль закрытого ключа в БД не хранится
create asymmetric key sign_orlov_mu
    authorization orlov_mu
    with algorithm = RSA_2048
    encryption by password = N'Orlov#Sign2026';
go

alter table photos
    add review_signature varbinary(512) null,
        review_key_thumbprint varbinary(32) null;
go

-- Подписываемая строка: поля вердикта в однозначной записи. Текстовые поля снабжены длиной,
-- поэтому границы полей не зависят от их содержимого
create or alter function fn_photo_review_payload(
    @photo_id int,
    @file_name nvarchar(100),
    @review_status nvarchar(20),
    @reviewer_id int,
    @reviewed_at datetime2(0),
    @review_comment nvarchar(200)
)
returns nvarchar(500)
with schemabinding
as
begin
    return concat_ws(
        N';',
        N'photo-review/v1',
        @photo_id,
        concat(len(@file_name + N'.') - 1, N':', @file_name),
        @review_status,
        coalesce(convert(nvarchar(11), @reviewer_id), N'-'),
        coalesce(convert(nvarchar(19), @reviewed_at, 126), N'-'),
        coalesce(concat(len(@review_comment + N'.') - 1, N':', @review_comment), N'-')
    );
end;
go

-- Действующие вердикты подписываются ключом проверяющего при развёртывании: dbo — db_owner
-- и знает пароль ключа
update p
set review_signature = signbyasymkey(
        asymkey_id(N'sign_' + e.login_name),
        hashbytes('SHA2_256', dbo.fn_photo_review_payload(
            p.photo_id, p.file_name, p.review_status, p.reviewer_id, p.reviewed_at, p.review_comment
        )),
        N'Orlov#Sign2026'
    ),
    review_key_thumbprint = k.thumbprint
from photos as p
join employees as e
    on e.employee_id = p.reviewer_id
join sys.asymmetric_keys as k
    on k.name = N'sign_' + e.login_name
where p.review_status in (N'одобрена', N'отклонена');
go

-- Вердикт без подписи и подпись без вердикта недопустимы
alter table photos
    add constraint ck_photos_signature check (
        review_status in (N'одобрена', N'отклонена')
            and review_signature is not null and review_key_thumbprint is not null
        or review_status in (N'не требуется', N'на проверке')
            and review_signature is null and review_key_thumbprint is null
    );
go
