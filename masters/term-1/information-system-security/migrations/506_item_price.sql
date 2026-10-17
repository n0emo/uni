use pamyatny_kadr;
go

-- Требование 5. Цена позиции берётся из прайса в момент добавления и больше не меняется;
-- недоступный товар заказать нельзя. Связка: позиции и товары

alter table order_items
    add constraint df_order_items_unit_price default 0 for unit_price;
go

-- instead of: значение, которое клиент передал в unit_price, заменяется прайсом до вставки
create or alter trigger tr_order_items_price
on order_items
instead of insert
as
begin
    set nocount on;
    if not exists (select 1 from inserted)
        return;

    declare @list nvarchar(1000), @message nvarchar(2048);

    select @list = string_agg(p.name, N'; ')
    from inserted as i
    join products as p
        on p.product_id = i.product_id
    where p.is_available = 0;
    if @list is not null
    begin
        set @message = concat(N'Товар снят с продажи: ', @list);
        rollback;
        throw 50141, @message, 1;
    end;

    -- несуществующий товар не отбрасывается соединением, а доходит до внешнего ключа
    insert into order_items (order_id, product_id, photo_id, quantity, unit_price)
    select i.order_id, i.product_id, i.photo_id, i.quantity, coalesce(p.price, i.unit_price)
    from inserted as i
    left join products as p
        on p.product_id = i.product_id;
end;
go

create or alter trigger tr_order_items_price_fixed
on order_items
after update
as
begin
    set nocount on;
    if not exists (select 1 from inserted)
        return;
    if not (update(product_id) or update(unit_price))
        return;

    declare @list nvarchar(1000), @message nvarchar(2048);

    select @list = string_agg(i.order_item_id, N', ')
    from inserted as i
    join deleted as d
        on d.order_item_id = i.order_item_id
    where i.product_id <> d.product_id or i.unit_price <> d.unit_price;
    if @list is not null
    begin
        set @message = concat(
            N'Товар и цену позиции менять нельзя: удалите позицию и добавьте новую, позиция № ',
            @list
        );
        rollback;
        throw 50142, @message, 1;
    end;
end;
go
