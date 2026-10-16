#strong[ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА]

#strong[Федеральное государственное бюджетное образовательное учреждение
высшего образования]

#strong[«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ
Императора Александра I»]

Кафедра «ИНФОРМАЦИОННЫЕ И ВЫЧИСЛИТЕЛЬНЫЕ СИСТЕМЫ»

Дисциплина «Базы данных и управление данными»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № #strong[5/6]]

«Взаимодействие приложений с СУБД»

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    [Выполнил студент

    Факультет: АИТ

    Группа: ИВБ-211

    ], [Шефнер А.],
    [Проверил: проф.], [Хомоненко А. Д.],
  )]
  , kind: table
  )

#strong[Санкт-Петербург]

#quote(block: true)[
#strong[2024]
]

#strong[Задание]:

+ Для выбранной предметной области разработать схему реляционной БД и
  написать скрипт её создания и наполнения. \ Схема должна описывать не
  менее четырех сущностей, иметь хотя бы одно отношение n-m и отражать
  некоторый бизнес-процесс, разворачивающийся во времени. \ Для схемы
  привести примеры запросов, использующих имеющиеся отношения между
  сущностями.
+ Для выбранной предметной области разработать Rust-приложение,
  выводящее в поток вывода содержимое таблиц.

#strong[Ход работы:]

В данном отчёте представлен процесс установки и настройки
инструментальных средств. В процессе работы использовались такие
технологии, как PostgreSQL, PGAdmin, Docker, Rust и Cargo.

#strong[#strong[Настройка базы данных:]]

Для начала с помощью Docker установим на сервер PostgreSQL. Для этого
сначала необходимо скачать образ системы:

docker pull postgres:14.5

В команде указана конкретная версия PostgreSQL. По умолчанию, если её не
указать, загрузится образ последней версии, что может быть неудобно:
если в новой версии вышли изменения, которые ломают совместимость с той,
что вы использовали, то вам придётся либо исправлять ошибки, либо
загружать более старую версию.

После того, как образ загружен, можно его запустить:

docker run -itd -e POSTGRES\_USER=albert -e POSTGRES\_PASSWORD=xd1337 -p
5432:5432 -v /data:/var/lib/postgresql/data -\-name postgresql
postgres:14.5

Это единственная команда запустит контейнер с PostgreSQL с заданными
именем пользователя и паролем. Так же настройка -p 5432:5432 означает,
что системный порт 5432 будет привязан к порту контейнера 5432. Именно
по этому порту мы сможем в дальнейшем подключиться к базе данных.

Теперь мы можем установить PGAdmin для удобного просмотра базы данных и
её управления. Так же используем докер. Загрузим образ pgadmin4:

docker pull dpage/pgadmin4

После загрузки его так же можно запустить:

docker run -\-name pgadmin-albert -p 5000:80 -e
\"PGADMIN\_DEFAULT\_EMAIL=solaris945\@gmail.com\" -e
\"PGADMIN\_DEFAULT\_PASSWORD=xd1337\" -d dpage/pgadmin4

Эта единственная команда запустит PGAdmin и привяжет системный порт 5000
к порту контейнера 80. Теперь, зная IP-адрес, мы можем подключиться к
программе. Для этого в браузере в адресную строку вводим URL в формате
«IP-Адрес:Порт». Например, 0.0.0.0:5000. После ввода почты и пароля
(почту можно ввести любую, а пароль --- xd1337, так как он задан при
запуске образа) увидим начальную страницу:

#box(image("./assets/1000000100000A000000050CBB031943.png", height: 2.3161in, width: 4.5902in))

Здесь нам необходимо добавить новый сервер. Для этого нажмём на «Add New
Server».

#box(image("./assets/100000010000057300000443515670A1.png", height: 2.7118in, width: 3.4681in))

В открывшемся окне в качестве названия сервера (Name) введём «Server».
Далее переходим во вкладку Connection.

#box(image("./assets/1000000100000573000004436FF1B85E.png", height: 2.7965in, width: 3.5756in))Здесь
необходимо ввести IP-адрес, порт, имя пользователя и пароль. Имя
пользователя и пароль необходимо указать в соответствии с теми, что были
указаны в параметрах запуска образа postgres.

После успешного подключения мы увидим новый сервер:

#box(image("./assets/1000000100000A000000050DCD01AA10.png", height: 3.0398in, width: 6.0181in))

#strong[#strong[Настройка приложения:]]

Теперь созданим новое Rust-приложение и настроем в нём доступ к базе
данных. Первым делом создадим новый проект «fbook»:

cargo new fbook

В результате выполнения команды мы получим директорию, вид которой будет
следующим:

fbook

├── Cargo.toml

└── src

└── main.rs

В файле «Cargo.toml» находятся настройки проекта (например название или
список зависимостей). В файле src/main.rs находится точка входа
программы. В этих файлах будет располагаться рабочая программа.

Теперь установим sqlx-cli с помощью cargo. Он нам нужен для
первоначальной настройки базы данных.

cargo install sqlx-cli

В директории «fbook» созданим файл app.env. Он нам нужен для того, чтобы
задать переменную среды «DATABASE\_URL». Его содержание представлено
ниже:

export
DATABASE\_URL=\"postgres:/\/albert:xd1337#link("mailto:Jfcvby2014@5.144.96.93")[\@0]\.0.0.0:5432/postgres\"

Теперь мы можем создать базу данных на сервере:

source app.env \ cargo sqlx database create

Теперь создадим несколько файлов миграции. Они будут содержать SQL для
создания таблиц и их наполнения.

cargo sqlx migrate add drop \ cargo sqlx migrate add create \ cargo sqlx
migrate add fill

В результате мы увидим появившуюся директорию migrations и несколько
пустых файлов в ней. Вот дерево проекта после всех этих операций:

fbook \ ├── app.env \ ├── Cargo.toml \ ├── migrations \ │~~ ├──
20240510201331\_drop.sql \ │~~ ├── 20240510201339\_create.sql \ │~~ └──
20240510201342\_fill.sql \ └── src \ └── main.rs

Обратите внимание, что в начале названия каждого файла добавлено число
--- это дата его создания. Скрипты миграции будут выполняться в том
порядке, в котором они были созданы. Заполним новые \.sql файлы. В файл
«\*\_drop.sql» добавим запросы для удаления таблиц при их наличии:

DROP TABLE IF EXISTS book\_orders; \ DROP TABLE IF EXISTS
painting\_orders; \ DROP TABLE IF EXISTS customers; \ DROP TABLE IF
EXISTS materials; \ DROP TABLE IF EXISTS sizes;

В файл «\*-create.sql» добавим запросы для создания таблиц:

CREATE TABLE IF NOT EXISTS customers ( \ id SERIAL PRIMARY KEY, \ name
TEXT NOT NULL, \ surname TEXT NOT NULL, \ address TEXT NOT NULL, \ phone
TEXT NOT NULL \ ); \ \ CREATE TABLE IF NOT EXISTS materials ( \ id
SERIAL PRIMARY KEY, \ name TEXT NOT NULL, \ description TEXT NOT NULL, \
price REAL NOT NULL, \ stock REAL NOT NULL \ ); \ \ CREATE TABLE IF NOT
EXISTS sizes ( \ id SERIAL PRIMARY KEY, \ name TEXT NOT NULL \ ); \ \
CREATE TABLE IF NOT EXISTS book\_orders ( \ id SERIAL PRIMARY KEY, \
customer\_id INTEGER NOT NULL, \ datetime TIMESTAMP NOT NULL, \ cost
REAL NOT NULL, \ number\_of\_turns INTEGER NOT NULL, \ size\_id INTEGER
NOT NULL, \ material\_id INTEGER NOT NULL, \ FOREIGN KEY(customer\_id)
REFERENCES customers(id), \ FOREIGN KEY(material\_id) REFERENCES
materials(id), \ FOREIGN KEY(size\_id) REFERENCES sizes(id) \ ); \ \
CREATE TABLE IF NOT EXISTS painting\_orders ( \ id SERIAL PRIMARY KEY, \
customer\_id INTEGER NOT NULL, \ datetime TIMESTAMP NOT NULL, \ cost
REAL NOT NULL, \ width INTEGER NOT NULL, \ height INTEGER NOT NULL, \
FOREIGN KEY(customer\_id) REFERENCES customers(id) \ );

В файл «\*\_fill.sql» добавим запросы для наполнения таблиц:

INSERT INTO customers \ (name, surname, address, phone) \ VALUES \
(\'Виталий\', \'Петров\', \'ул. Пушкина, д. 22\', \'88005553535\'), \
(\'Андрей\', \'Штефанов\', \'ул. Привокзальная, д. 12\',
\'89811213123\'), \ (\'Родион\', \'Базаров\', \'пр. Меньшевиков, д.
143\', \'89814744747\'), \ (\'Светлана\', \'Владимирова\', \'ул. Крутая,
д. 121\', \'88001239098\'), \ (\'Мёске\', \'Кобарёв\', \'ул. Японская,
д. 211\', \'88005758495\'), \ (\'Аристарх\', \'Попов\', \'пр.
Энергетиков, д. 32\', \'88005767384\'), \ (\'Владимир\', \'Моисеенко\',
\'ул. Горького, д. 123\', \'98710654321\'), \ (\'Галина\', \'Рыбкина\',
\'пр. Горбачёва, д. 333\', \'81249876543\'), \ (\'Иван\', \'Курчатов\',
\'ул. Некрасовского, д. 120\', \'87819200312\'), \ (\'Сергей\',
\'Нечаев\', \'ул. Горького, д. 56\', \'98710654321\'), \ (\'Александр\',
\'Киселёв\', \'пр. Горбачёва, д. 14\', \'81249876543\'),0 \
(\'Анастасия\', \'Грицева\', \'ул. Строителей, д. 234\',
\'81249876543\'),0 \ (\'Владимир\', \'Петров\', \'ул. Полесская, д.
100\', \'98710654321\'), \ (\'Марина\', \'Медведева\', \'ул. Гоголя, д.
333\', \'81249876543\'); \ \ INSERT INTO materials \ (name, description,
price, stock) \ VALUES \ (\'Крокодил\', \'Зелёная крокодилья кожа\',
120, 24.6), \ (\'Кожа\', \'Обычная коричневая кожа\', 60, 36.1), \
(\'Картон\', \'Печатный картон средней плотности\', 23, 67), \
(\'Пластик\', \'Эксперементальный прочный пластик\', 100, 3.4), \
(\'Маленькая пчела\', \'Полосатая золотистая кожа\', 100, 35.8), \
(\'Солнечная тетрадь\', \'Эксперементальный прочный пластик\', 67, 2.7),
\ (\'Жарко\', \'Для пекинского огородного питания\', 45, 18.2), \
(\'Рождественский дар\', \'Эксперементальный прочный пластик\', 90,
3.6), \ (\'Тигр\', \'Прочнейший материал для работ на лесоповале\', 25,
41.8); \ \ INSERT INTO sizes (name) VALUES \ (\'Маленький\'), \
(\'Средний\'), \ (\'Большой\'), \ (\'Крупный\'); \ \ INSERT INTO
book\_orders \ (customer\_id, datetime, cost, number\_of\_turns,
size\_id, material\_id) \ VALUES \ (3, \'2024-01-06 12:40:21\', 3500,
12, 3, 1), \ (1, \'2024-01-08 16:12:55\', 1400, 4, 1, 2), \ (4,
\'2024-01-09 13:00:43\', 8000, 120, 3, 2), \ (6, \'2024-01-09
13:43:26\', 6700, 18, 2, 4), \ (5, \'2024-01-12 11:30:59\', 5000, 10, 4,
3), \ (7, \'2024-01-13 12:14:35\', 6000, 8, 2, 4), \ (2, \'2024-02-14
13:57:29\', 1800, 6, 1, 2), \ (8, \'2024-02-16 11:02:11\', 9000, 20, 3,
9), \ (4, \'2024-02-17 15:58:04\', 7000, 30, 4, 8), \ (1, \'2024-02-20
17:18:53\', 6000, 12, 3, 5), \ (9, \'2024-03-22 11:43:05\', 12000, 24,
2, 2), \ (6, \'2024-03-24 15:27:50\', 9000, 28, 1, 6), \ (10,
\'2024-03-27 12:39:48\', 15000, 36, 4, 7), \ (5, \'2024-03-30
14:48:46\', 8000, 20, 3, 7); \ \ INSERT INTO painting\_orders \
(customer\_id, datetime, cost, width, height) \ VALUES \ (13,
\'2024-01-09 13:00:43\', 1500, 240, 127), \ (2, \'2024-01-10 13:12:31\',
1800, 220, 140), \ (10, \'2024-01-10 14:40:45\', 1000, 160, 100), \ (9,
\'2024-02-03 15:17:48\', 600, 100, 50), \ (11, \'2024-02-06 15:34:52\',
1200, 180, 90), \ (7, \'2024-02-13 13:15:11\', 1800, 240, 140), \ (4,
\'2024-02-20 16:47:24\', 600, 80, 45), \ (2, \'2024-03-04 14:38:21\',
900, 100, 60), \ (12, \'2024-03-10 17:09:57\', 1500, 240, 165), \ (6,
\'2024-03-18 16:27:02\', 1800, 300, 180), \ (9, \'2024-03-25 12:59:05\',
1200, 200, 120); \

Теперь мы можем запустить миграцию. Для этого введём команду:

cargo sqlx migrate run

Если после выполнения этой команды вы получите примерно такой вывод,
значит база данных успешно создана и наполнена

Applied 20240510201331/migrate drop (110.542748ms) \ Applied
20240510201339/migrate create (186.979338ms) \ Applied
20240510201342/migrate fill (84.265673ms)

Проверим, что база данных действительно создана. Подключимся к ней с
помощью PGAdmin и посмотрим содержимое таблицы customers:

#box(image("./assets/1000000100000A000000050FAA6A5861.png", height: 3.0437in, width: 6.0181in))

Видим, что таблица заполнена значениями, указанными в файле.

#strong[#strong[Исходный код программы:]]

Теперь можно приступить к написанию кода.

Cargo.toml:

\[package\] \ name = \"fbook\" \ version = \"0.1.0\" \ edition =
\"2021\" \ \ \# See more keys and their definitions at \
#link("https://doc.rust-lang.org/cargo/reference/manifest.html") \ \
\[dependencies\] \ anyhow = \"1.0.83\" \ axum = \"0.7.5\" \ chrono = {
version = \"0.4.38\", features = \[\"serde\"\] } \ serde = { version =
\"1.0.201\", features = \[\"derive\"\] } \ serde\_json = \"1.0.117\" \
sqlx = { version = \"0.7.4\", features = \[\"runtime-tokio\",
\"postgres\", \"chrono\"\] } \ tokio = { version = \"1.37.0\", features
\= \[\"full\"\] }

В этом файле определено название нашего приложения и список
зависимостей. Для чего нужно каждое из них:

- anyhow --- для удобной и эффективной обработки ошибок.
- axum --- необходимо для создания HTTP-сервера.
- chrono --- для работы с датой и временем в таблицах.
- serde и serde\_json --- для преобразования данных в формат JSON.
- sqlx --- для работы с базой данных SQL.
- Tokio - асинхронная среда выполнения, нужная для Axum и SQLx.

main.rs содержит логику приложения. Его содержание с комментариями
представлено ниже:

\/\/ Первым делом необходимо внести в область видимости

\/\/ файла различные типы и функции из библиотек,

\/\/ которые есть в проекте. Это не обязательно, так

\/\/ как можно обратиться к любой функции или типу, указав

\/\/ прямо в коде пространство имён перед его именем,

\/\/ однако это очень сильно загромождает код.

use anyhow::Result;

use axum::{

extract::{Json, State},

http::StatusCode,

response::{IntoResponse, Response},

routing::get,

serve,

Router};

use tokio::net::TcpListener;

use serde::Serialize;

use sqlx::{

query\_as,

FromRow,

postgres::{PgPool, PgPoolOptions},

types::chrono::NaiveDateTime};

use std::time::Duration;

\/\/ Это URL, который будет слушать приложения.

\/\/ Можно его брать из переменной среды, но для простоты

\/\/ пусть оно будет константой.

const BASE\_URL: &str = \"localhost:3000\";

\/\/ Определение структур, которые будут представлять

\/\/ результаты запросов. Обратите внимание: название полей

\/\/ должно совпадать с названиями столбцов, получаемых при

\/\/ запросе. В этом случае SQLx сможет реализовать соответствие

\/\/ между запросом и структурой автоматически.

\/\/

\/\/ Так же у каждой из этих структур присутствует

\/\/ \#\[derive(Serialize)\] - это нужно для автоматической

\/\/ реализации трейта serde::Serialize, который позволит

\/\/ преобразовать экземпляр структуры в JSON.

\#\[derive(Serialize)\]

struct Customer {

id: i32,

name: String,

surname: String,

address: String,

phone: String,

}

\#\[derive(Serialize)\]

struct Material {

id: i32,

name: String,

description: String,

price: f32,

stock: f32,

}

\#\[derive(Serialize)\]

struct Size {

id: i32,

name: String

}

\#\[derive(Serialize)\]

struct BookOrder {

id: i32,

customer\_id: i32,

datetime: NaiveDateTime,

cost: f32,

number\_of\_turns: i32,

size\_id: i32,

material\_id: i32,

}

\#\[derive(Serialize)\]

struct PaintingOrder {

id: i32,

customer\_id: i32,

datetime: NaiveDateTime,

cost: f32,

width: i32,

height: i32,

}

\/\/ Помиму Serialize, данная структура так же наследует

\/\/ реализацию sqlx::FromRow. С этой структурой не получается

\/\/ использовать макрос sqlx::query\_as!, поэтому используем функцию

\/\/ sqlx::query\_as, а она требует реализацию этого трейта.

\#\[derive(Serialize, FromRow)\]

struct Order {

name: String,

surname: String,

datetime: NaiveDateTime,

cost: f32,

kind: String,

}

\#\[derive(Serialize)\]

struct TopBook {

cost: f32,

number\_of\_turns: i32,

size: String,

material: String

}

\/\/ Эта структура-кортеж представляет внутреннюю ошибку сервера.

\/\/ Её единственное поле типа anyhow::Error может содержать

\/\/ в себе ошибку любого рода.

struct AppError(anyhow::Error);

\/\/ Поскольку мы хотим использовать AppError в API сервера,

\/\/ необходимо определить логику для преобразования

\/\/ ошибки в ответ сервера. Для этого необходимо самостоятельно

\/\/ реализовать трейт IntoResponse.

impl IntoResponse for AppError {

fn into\_response(self) -\> Response {

\(

StatusCode::INTERNAL\_SERVER\_ERROR,

format!(\"Something went wrong: {}\", self.0),

).into\_response()

}

}

\/\/ Реализация этого трейта необходима для того, чтобы можно было

\/\/ преобразовать anyhow::Error в AppError.

impl\<E\> From\<E\> for AppError

where

E: Into\<anyhow::Error\>,

{

fn from(err: E) -\> Self {

Self(err.into())

}

}

\/\/ Точка входа программы.

\/\/ \#\[tokio::main()\] необходим, поскольку приложение

\/\/ использует tokio runtime и является асинхронным.

\/\/ Без этого макроса нельзя сделать main async и выполнять

\/\/ внутри await.

\#\[tokio::main()\]

async fn main() {

\/\/ Берём URL к базе данных из той же переменной среды, которую

\/\/ использует SQLx CLI.

let db\_url = std::env::var(\"DATABASE\_URL\")

\.expect(\"DATABASE\_URL env is not provided\");

\/\/ Определим пул подключений к базе данных. Он необходим

\/\/ для совершения любых запросов.

let pool = PgPoolOptions::new()

\.max\_connections(5)

\.acquire\_timeout(Duration::from\_secs(3))

\.connect(db\_url.as\_str())

\.await

\.expect(\"Error connecting to database\");

\/\/ Созданим новый Router, который будет перенаправлять

\/\/ запросы в специальные функции-обработчики.

\/\/ Так же добавим в роутер пул подключений к базе данных,

\/\/ чтобы функции-обработчики могли к ней подключиться.

let app = Router::new()

\.route(\"/customers\", get(customers))

\.route(\"/sizes\", get(sizes))

\.route(\"/materials\", get(materials))

\.route(\"/book\_orders\", get(book\_orders))

\.route(\"/painting\_orders\", get(painting\_orders))

\.route(\"/history\", get(history))

\.route(\"/top\_books\", get(top\_books))

\.with\_state(pool);

\/\/ Определим listener, который по своей сути является

\/\/ сокет-сервером и привяжем его к URL приложения.

let listener = TcpListener::bind(BASE\_URL)

\.await

\.expect(format!(\"Error binding to {}\", BASE\_URL).as\_str());

println!(\"Listening at {}\", BASE\_URL);

\/\/ Теперь, когда всё готово, можно запустить приложения

\/\/ и начать обрабатывать запросы.

serve(listener, app)

\.await

\.expect(\"Error serving app\")

}

\/\/ Далее идут функции-обработчики.

\/\/ Все они принимают в себя пул подключений к базе

\/\/ данных для совершения запросов.

\/\/ И все они возвращают Result, который может

\/\/ содержать либо JSON с ответом на запрос, либо ошибку.

\/\/

\/\/ Обратите внимание на макрос query\_as!. Он автоматически

\/\/ преобразует результат запроса к указанному типу, а так же

\/\/ проверит правильность написанного SQL. В том числе проверит

\/\/ на соответствие существующим таблицам в базе. Если запрос

\/\/ составлен неправильно, будет ошибка компиляции, а не исключение

\/\/ во время запуска приложения.

async fn customers(State(db): State\<PgPool\>)

\-\> Result\<Json\<Vec\<Customer\>\>, AppError\> {

let customers = query\_as!(Customer,

\"SELECT

id,

name,

surname,

address,

phone

FROM

customers\")

\.fetch\_all(&db)

\.await?;

Ok(Json(customers))

}

async fn sizes(State(db): State\<PgPool\>)

\-\> Result\<Json\<Vec\<Size\>\>, AppError\> {

let sizes = query\_as!(Size,

\"SELECT id, name FROM sizes\")

\.fetch\_all(&db)

\.await?;

Ok(Json(sizes))

}

async fn materials(State(db): State\<PgPool\>)

\-\> Result\<Json\<Vec\<Material\>\>, AppError\> {

let materials = query\_as!(Material, \"

SELECT

id,

name,

description,

price,

stock

FROM

materials\")

\.fetch\_all(&db)

\.await?;

Ok(Json(materials))

}

async fn book\_orders(State(db): State\<PgPool\>)

\-\> Result\<Json\<Vec\<BookOrder\>\>, AppError\> {

let orders = query\_as!(BookOrder, \"

SELECT

id,

customer\_id,

datetime,

cost,

number\_of\_turns,

size\_id,

material\_id

FROM

book\_orders\")

\.fetch\_all(&db)

\.await?;

Ok(Json(orders))

}

async fn painting\_orders(State(db): State\<PgPool\>)

\-\> Result\<Json\<Vec\<PaintingOrder\>\>, AppError\> {

let orders = query\_as!(PaintingOrder, \"

SELECT

id,

customer\_id,

datetime,

cost,

width,

height

FROM

painting\_orders\")

\.fetch\_all(&db)

\.await?;

Ok(Json(orders))

}

\/\/ Здесь компилятор уже не может адекватно проверить

\/\/ запрос на правильность, поскольку считает, что каждый

\/\/ из столбцов результата может содержать NULL. Однако мы

\/\/ можем гарантировать, что все эти поля будут не NULL, поэтому

\/\/ используем чуть менее безопасную функцию query\_as вместо макроса.

async fn history(State(db): State\<PgPool\>)

\-\> Result\<Json\<Vec\<Order\>\>, AppError\> {

let orders: Vec\<Order\> = query\_as(\"

SELECT

customers.name,

customers.surname,

subquery.datetime,

subquery.cost,

subquery.kind

FROM (

SELECT

customer\_id, cost, datetime, \'book\' as kind

FROM

book\_orders

UNION

SELECT

customer\_id, cost, datetime, \'painting\' as kind

FROM

painting\_orders

) AS subquery

JOIN

customers

ON subquery.customer\_id = customers.id

\")

\.fetch\_all(&db)

\.await?;

Ok(Json(orders))

}

async fn top\_books(State(db): State\<PgPool\>)

\-\> Result\<Json\<Vec\<TopBook\>\>, AppError\> {

let books = query\_as!(TopBook, \"

SELECT

book\_orders.cost as cost,

book\_orders.number\_of\_turns as number\_of\_turns,

sizes.name as size,

materials.name as material

FROM

book\_orders

JOIN

materials

ON

book\_orders.material\_id = materials.id

JOIN

sizes

ON

book\_orders.size\_id = sizes.id

ORDER BY

book\_orders.cost DESC

LIMIT 5

\")

\.fetch\_all(&db)

\.await?;

Ok(Json(books))

}

#strong[#strong[Отладка приложения:]]

Посмотрим на JSON, который выводит веб-сервер по разным путям.

Оценочный лист результатов ЛР №5

Ф.И.О. студента: Шефнер Альберт

Гру#box(image("./assets/10000001000002CD0000030BC09449FF.png", height: 5.7638in, width: 5.3047in))ппа:
ИВБ-211

#box(image("./assets/10000001000002CD0000025D0BA37686.png", height: 3.9752in, width: 4.711in))#box(image("./assets/10000001000002CD00000311606BBCA7.png", height: 5.0598in, width: 4.6217in))

#box(image("./assets/10000001000002CD000003DF9C5F3F58.png", height: 8.3173in, width: 6.0181in))

#box(image("./assets/10000001000002CD00000467AC703FDE.png", height: 9.4591in, width: 6.0181in))

#box(image("./assets/10000001000002E30000038FBE7F3432.png", height: 7.4181in, width: 6.0181in))

#box(image("./assets/10000001000002E300000409BC351DA4.png", height: 8.4118in, width: 6.0181in))

#figure(
  align(center)[#table(
    columns: 6,
    align: (auto,auto,auto,auto,auto,auto,),
    [№

    п/п

    ], [Материалы необходимые для оценки знаний, умений

    и навыков

    ], [Показатель

    оценивания

    ], [Критерии

    Оценивания

    ], [Шкала оценивания], [],
    table.cell(rowspan: 11)[1], table.cell(rowspan: 11)[Лабораторная
    работа №], table.cell(rowspan: 2)[Наличие
    заготовки], [Присутствует], [1], [],
    [Отсутствует], [0], [],
    table.cell(rowspan: 3)[Правильность ответов на вопрос], [Получены
    правильные ответы на вопросы], [4], [],
    [Получены частично правильные ответы], [2,5], [],
    [Получены неправильные ответы], [0], [],
    table.cell(rowspan: 2)[Соответствие методике
    выполнения], [Соответствует], [2,5], [],
    [Не соответствует], [1,5], [],
    table.cell(rowspan: 3)[Срок выполнения работы], [Работа выполнена в
    срок], [2,5], [],
    [Работа выполнена с опозданием на 1 неделю], [1,5], [],
    [Работа выполнена с опозданием на 2 недели и более], [1,0], [],
    table.cell(colspan: 2)[Итого максимальное количество баллов за
    лабораторную работу №], [10], [],
  )]
  , kind: table
  )

Хомоненко А. Д.

«\_\_\_»\_\_\_\_\_\_\_\_\_\_2024 г.
