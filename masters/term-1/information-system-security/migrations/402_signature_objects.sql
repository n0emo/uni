use pamyatny_kadr;
go

-- 1 — подпись действительна, 0 — данные или подпись изменены, null — подписи нет
-- или ключ подписанта не найден. execute as owner нужен для чтения sys.asymmetric_keys:
-- каталог показывает пользователю только ключи, на которые у него есть права
create or alter function fn_verify_photo_review(@photo_id int)
returns bit
with execute as owner
as
begin
    return (
        select
            case
                when p.review_signature is null then null
                when k.asymmetric_key_id is null then null
                else verifysignedbyasymkey(
                    k.asymmetric_key_id,
                    hashbytes('SHA2_256', dbo.fn_photo_review_payload(
                        p.photo_id, p.file_name, p.review_status,
                        p.reviewer_id, p.reviewed_at, p.review_comment
                    )),
                    p.review_signature
                )
            end
        from photos as p
        left join employees as e
            on e.employee_id = p.reviewer_id
        left join sys.asymmetric_keys as k
            on k.thumbprint = p.review_key_thumbprint
            and k.principal_id = database_principal_id(e.login_name)
        where p.photo_id = @photo_id
    );
end;
go

-- Комментарий проверки в представление не входит: он может раскрывать содержание кадра
create or alter view v_photo_reviews
as
select
    p.photo_id,
    p.file_name,
    p.review_status,
    concat(e.last_name, N' ', left(e.first_name, 1), N'.') as reviewer,
    p.reviewed_at,
    case dbo.fn_verify_photo_review(p.photo_id)
        when 1 then N'действительна'
        when 0 then N'недействительна'
        else iif(p.review_signature is null, N'отсутствует', N'не проверена')
    end as signature_status
from photos as p
left join employees as e
    on e.employee_id = p.reviewer_id
where p.review_status in (N'одобрена', N'отклонена')
    or p.review_signature is not null;
go

-- Вердикт и подпись записываются одним оператором от имени и с ключом вызывающего
create or alter procedure review_photo
    @photo_id int,
    @verdict nvarchar(20),
    @comment nvarchar(200) = null,
    @key_password nvarchar(128)
as
begin
    set nocount on;
    set xact_abort on;

    declare @reviewer_id int = (
        select employee_id
        from employees
        where login_name = user_name()
            and position = N'специалист по защите информации'
    );
    if @reviewer_id is null
        throw 50020, N'Выносить вердикт может только специалист по защите информации', 1;

    if @verdict not in (N'одобрена', N'отклонена')
        throw 50021, N'Вердикт должен быть «одобрена» или «отклонена»', 1;
    if @verdict = N'отклонена' and nullif(trim(@comment), N'') is null
        throw 50022, N'Отклонение необходимо обосновать комментарием', 1;

    declare @file_name nvarchar(100), @status nvarchar(20);
    select @file_name = file_name, @status = review_status
    from photos
    where photo_id = @photo_id;
    if @file_name is null
        throw 50023, N'Снимок не найден', 1;
    if @status <> N'на проверке'
        throw 50024, N'Снимок не ожидает проверки', 1;

    declare @key_id int = asymkey_id(N'sign_' + user_name());
    if @key_id is null
        throw 50025, N'У пользователя нет ключа подписи', 1;

    declare @reviewed_at datetime2(0) = sysdatetime();
    declare @signature varbinary(512);
    begin try
        set @signature = signbyasymkey(
            @key_id,
            hashbytes('SHA2_256', dbo.fn_photo_review_payload(
                @photo_id, @file_name, @verdict, @reviewer_id, @reviewed_at, @comment
            )),
            @key_password
        );
    end try
    begin catch
        throw 50026, N'Неверный пароль закрытого ключа', 1;
    end catch;

    -- флаг сбрасывается и при ошибке, чтобы не остаться взведённым до конца сеанса
    begin try
        begin transaction;
        exec sp_set_session_context N'photo_review_signing', 1;

        update photos
        set review_status = @verdict,
            reviewer_id = @reviewer_id,
            reviewed_at = @reviewed_at,
            review_comment = @comment,
            review_signature = @signature,
            review_key_thumbprint = (
                select thumbprint from sys.asymmetric_keys where asymmetric_key_id = @key_id
            )
        where photo_id = @photo_id;

        exec sp_set_session_context N'photo_review_signing', 0;
        commit;
    end try
    begin catch
        exec sp_set_session_context N'photo_review_signing', 0;
        if @@trancount > 0
            rollback;
        throw;
    end catch;
end;
go

-- Менять вердикт можно только процедурой review_photo, и только с действительной подписью
create or alter trigger tr_photos_review_guard
on photos
after update
as
begin
    set nocount on;

    if update(review_status) or update(reviewer_id) or update(reviewed_at)
        or update(review_comment) or update(review_signature) or update(review_key_thumbprint)
    begin
        if coalesce(convert(int, session_context(N'photo_review_signing')), 0) <> 1
        begin
            rollback;
            throw 50030, N'Вердикт можно изменить только процедурой review_photo', 1;
        end;

        if exists (
            select 1
            from inserted
            where review_status in (N'одобрена', N'отклонена')
                and coalesce(dbo.fn_verify_photo_review(photo_id), 0) <> 1
        )
        begin
            rollback;
            throw 50031, N'Подпись вердикта недействительна', 1;
        end;
    end;

    if update(file_name) and exists (
        select 1
        from inserted as i
        join deleted as d
            on d.photo_id = i.photo_id
        where i.file_name <> d.file_name
            and d.review_signature is not null
    )
    begin
        rollback;
        throw 50032, N'Имя файла подписанного снимка изменять нельзя', 1;
    end;
end;
go
