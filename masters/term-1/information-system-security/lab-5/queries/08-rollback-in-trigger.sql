create table guard_demo (id int not null primary key);
go

create trigger tr_guard_demo
on guard_demo
after insert
as
begin
    throw 50999, N'Вставка запрещена', 1;
end;
go

-- Вариант 1: триггер только с throw. Транзакция вызывающего заведомо обречена (xact_state = -1)
begin try
    begin transaction;
    insert into guard_demo (id)
    values (1), (2);
end try
begin catch
    select
        error_message() as error,
        @@trancount as open_transactions,
        (select count(*) from guard_demo) as rows_visible;
    rollback;
end catch;
go

create or alter trigger tr_guard_demo
on guard_demo
after insert
as
begin
    rollback;
    throw 50999, N'Вставка запрещена', 1;
end;
go

-- Вариант 2: rollback перед throw. Транзакция завершается уже в триггере
begin try
    begin transaction;
    insert into guard_demo (id)
    values (1), (2);
end try
begin catch
    select
        error_message() as error,
        @@trancount as open_transactions,
        (select count(*) from guard_demo) as rows_visible;
end catch;
go

-- Оператор вне транзакции отменяется в обоих вариантах
insert into guard_demo (id)
values (1), (2);
go
select count(*) as rows_left from guard_demo;
go
drop table guard_demo;
go
