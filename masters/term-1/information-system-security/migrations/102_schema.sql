use pamyatny_kadr;
go

create table military_units (
    unit_id int identity
        constraint pk_military_units primary key,
    designation nvarchar(20) not null
        constraint uq_military_units_designation unique,
    garrison nvarchar(100) not null,
    contact_phone nvarchar(20) null,
    constraint ck_military_units_designation check (
        designation like N'в/ч [0-9][0-9][0-9][0-9][0-9]'
    )
);

create table soldiers (
    soldier_id int identity
        constraint pk_soldiers primary key,
    unit_id int not null
        constraint fk_soldiers_military_units references military_units (unit_id),
    personal_number nvarchar(10) not null
        constraint uq_soldiers_personal_number unique,
    last_name nvarchar(50) not null,
    first_name nvarchar(50) not null,
    patronymic nvarchar(50) null,
    birth_date date not null,
    military_rank nvarchar(30) not null
        constraint df_soldiers_military_rank default N'рядовой',
    call_up_date date not null,
    discharge_date date null,
    constraint ck_soldiers_personal_number check (
        personal_number like N'[А-Я][А-Я]-[0-9][0-9][0-9][0-9][0-9][0-9]'
    ),
    constraint ck_soldiers_military_rank check (
        military_rank in (
            N'рядовой', N'ефрейтор', N'младший сержант', N'сержант', N'старший сержант'
        )
    ),
    constraint ck_soldiers_dates check (
        call_up_date > birth_date
        and (discharge_date is null or discharge_date > call_up_date)
    )
);

create table customers (
    customer_id int identity
        constraint pk_customers primary key,
    last_name nvarchar(50) not null,
    first_name nvarchar(50) not null,
    patronymic nvarchar(50) null,
    phone nvarchar(20) not null
        constraint uq_customers_phone unique,
    email nvarchar(100) null,
    address nvarchar(200) null,
    registered_at datetime2(0) not null
        constraint df_customers_registered_at default sysdatetime(),
    constraint ck_customers_email check (email like N'%_@_%._%')
);

create table relatives (
    soldier_id int not null
        constraint fk_relatives_soldiers references soldiers (soldier_id),
    customer_id int not null
        constraint fk_relatives_customers references customers (customer_id),
    kinship nvarchar(20) not null,
    constraint pk_relatives primary key (soldier_id, customer_id),
    constraint ck_relatives_kinship check (
        kinship in (
            N'мать', N'отец', N'жена', N'брат', N'сестра', N'бабушка', N'дедушка', N'невеста'
        )
    )
);

create table employees (
    employee_id int identity
        constraint pk_employees primary key,
    last_name nvarchar(50) not null,
    first_name nvarchar(50) not null,
    patronymic nvarchar(50) null,
    position nvarchar(50) not null,
    phone nvarchar(20) not null
        constraint uq_employees_phone unique,
    hired_on date not null,
    login_name sysname null,
    constraint ck_employees_position check (
        position in (
            N'директор',
            N'менеджер по заказам',
            N'фотограф',
            N'дизайнер-верстальщик',
            N'специалист по защите информации',
            N'бухгалтер'
        )
    )
);

-- unique допускает лишь один null, поэтому уникальность логина — фильтруемым индексом
create unique index uq_employees_login_name
    on employees (login_name)
    where login_name is not null;

create table photo_sessions (
    session_id int identity
        constraint pk_photo_sessions primary key,
    kind nvarchar(30) not null,
    unit_id int null
        constraint fk_photo_sessions_military_units references military_units (unit_id),
    customer_id int null
        constraint fk_photo_sessions_customers references customers (customer_id),
    photographer_id int not null
        constraint fk_photo_sessions_employees references employees (employee_id),
    session_date date not null,
    location nvarchar(150) not null,
    constraint ck_photo_sessions_kind check (
        kind in (
            N'присяга', N'повседневная служба', N'дембельский альбом',
            N'студийная', N'выездная'
        )
    ),
    -- военная съёмка проходит в воинской части, гражданская заказывается клиентом
    constraint ck_photo_sessions_owner check (
        kind in (N'присяга', N'повседневная служба', N'дембельский альбом')
            and unit_id is not null and customer_id is null
        or kind in (N'студийная', N'выездная')
            and unit_id is null and customer_id is not null
    )
);

create table photos (
    photo_id int identity
        constraint pk_photos primary key,
    session_id int not null
        constraint fk_photos_photo_sessions references photo_sessions (session_id),
    file_name nvarchar(100) not null
        constraint uq_photos_file_name unique,
    taken_at datetime2(0) not null,
    review_status nvarchar(20) not null
        constraint df_photos_review_status default N'на проверке',
    reviewer_id int null
        constraint fk_photos_employees references employees (employee_id),
    reviewed_at datetime2(0) null,
    review_comment nvarchar(200) null,
    constraint ck_photos_review_status check (
        review_status in (N'не требуется', N'на проверке', N'одобрена', N'отклонена')
    ),
    -- вердикт всегда сопровождается проверяющим и датой проверки
    constraint ck_photos_review check (
        review_status in (N'не требуется', N'на проверке')
            and reviewer_id is null and reviewed_at is null
        or review_status in (N'одобрена', N'отклонена')
            and reviewer_id is not null and reviewed_at >= taken_at
    )
);

create table photo_soldiers (
    photo_id int not null
        constraint fk_photo_soldiers_photos references photos (photo_id) on delete cascade,
    soldier_id int not null
        constraint fk_photo_soldiers_soldiers references soldiers (soldier_id),
    constraint pk_photo_soldiers primary key (photo_id, soldier_id)
);

create table products (
    product_id int identity
        constraint pk_products primary key,
    name nvarchar(100) not null
        constraint uq_products_name unique,
    category nvarchar(30) not null,
    price decimal(10, 2) not null,
    is_available bit not null
        constraint df_products_is_available default 1,
    constraint ck_products_category check (
        category in (N'фотокнига', N'печать', N'рамка', N'фотосъёмка', N'цифровые файлы')
    ),
    constraint ck_products_price check (price > 0)
);

create table orders (
    order_id int identity
        constraint pk_orders primary key,
    customer_id int not null
        constraint fk_orders_customers references customers (customer_id),
    soldier_id int null
        constraint fk_orders_soldiers references soldiers (soldier_id),
    manager_id int not null
        constraint fk_orders_employees_manager references employees (employee_id),
    designer_id int null
        constraint fk_orders_employees_designer references employees (employee_id),
    created_at datetime2(0) not null
        constraint df_orders_created_at default sysdatetime(),
    status nvarchar(20) not null
        constraint df_orders_status default N'новый',
    total_amount decimal(10, 2) not null
        constraint df_orders_total_amount default 0,
    issued_at datetime2(0) null,
    constraint ck_orders_status check (
        status in (N'новый', N'в работе', N'готов', N'выдан', N'отменён')
    ),
    constraint ck_orders_total_amount check (total_amount >= 0),
    constraint ck_orders_issued check (
        status = N'выдан' and issued_at >= created_at
        or status <> N'выдан' and issued_at is null
    )
);

create table order_items (
    order_item_id int identity
        constraint pk_order_items primary key,
    order_id int not null
        constraint fk_order_items_orders references orders (order_id) on delete cascade,
    product_id int not null
        constraint fk_order_items_products references products (product_id),
    photo_id int null
        constraint fk_order_items_photos references photos (photo_id),
    quantity int not null
        constraint df_order_items_quantity default 1,
    unit_price decimal(10, 2) not null,
    constraint uq_order_items_order_product_photo unique (order_id, product_id, photo_id),
    constraint ck_order_items_quantity check (quantity > 0),
    constraint ck_order_items_unit_price check (unit_price >= 0)
);

create table payments (
    payment_id int identity
        constraint pk_payments primary key,
    order_id int not null
        constraint fk_payments_orders references orders (order_id),
    amount decimal(10, 2) not null,
    paid_at datetime2(0) not null
        constraint df_payments_paid_at default sysdatetime(),
    method nvarchar(20) not null,
    constraint ck_payments_amount check (amount > 0),
    constraint ck_payments_method check (method in (N'наличные', N'карта', N'перевод'))
);
