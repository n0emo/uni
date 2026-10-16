// Первым делом необходимо внести в область видимости
// файла различные типы и функции из библиотек,
// которые есть в проекте. Это не обязательно, так
// как можно обратиться к любой функции или типу, указав
// прямо в коде пространство имён перед его именем,
// однако это очень сильно загромождает код.
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
    query_as,
    FromRow,
    postgres::{PgPool, PgPoolOptions},
    types::chrono::NaiveDateTime};
use std::time::Duration;


// Это URL, который будет слушать приложения.
// Можно его брать из переменной среды, но для простоты
// пусть оно будет константой.
const BASE_URL: &str = "localhost:3000";

// Определение структур, которые будут представлять
// результаты запросов. Обратите внимание: название полей
// должно совпадать с названиями столбцов, получаемых при
// запросе. В этом случае SQLx сможет реализовать соответствие
// между запросом и структурой автоматически.
//
// Так же у каждой из этих структур присутствует
// #[derive(Serialize)] - это нужно для автоматической
// реализации трейта serde::Serialize, который позволит
// преобразовать экземпляр структуры в JSON. 
#[derive(Serialize)]
struct Customer {
    id: i32,
    name: String,
    surname: String,
    address: String,
    phone: String,
}

#[derive(Serialize)]
struct Material {
    id: i32,
    name: String,
    description: String,
    price: f32,
    stock: f32,
}

#[derive(Serialize)]
struct Size {
    id: i32,
    name: String
}

#[derive(Serialize)]
struct BookOrder {
    id: i32,
    customer_id: i32,
    datetime: NaiveDateTime,
    cost: f32,
    number_of_turns: i32,
    size_id: i32,
    material_id: i32,
}

#[derive(Serialize)]
struct PaintingOrder {
    id: i32,
    customer_id: i32,
    datetime: NaiveDateTime,
    cost: f32,
    width: i32,
    height: i32,
}

// Помиму Serialize, данная структура так же наследует
// реализацию sqlx::FromRow. С этой структурой не получается
// использовать макрос sqlx::query_as!, поэтому используем функцию
// sqlx::query_as, а она требует реализацию этого трейта.
#[derive(Serialize, FromRow)]
struct Order {
    name: String,
    surname: String,
    datetime: NaiveDateTime,
    cost: f32,
    kind: String,
}

#[derive(Serialize)]
struct TopBook {
    cost: f32,
    number_of_turns: i32,
    size: String,
    material: String
}

// Эта структура-кортеж представляет внутреннюю ошибку сервера.
// Её единственное поле типа anyhow::Error может содержать
// в себе ошибку любого рода.
struct AppError(anyhow::Error);

// Поскольку мы хотим использовать AppError в API сервера,
// необходимо определить логику для преобразования
// ошибки в ответ сервера. Для этого необходимо самостоятельно
// реализовать трейт IntoResponse.
impl IntoResponse for AppError {
    fn into_response(self) -> Response {
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            format!("Something went wrong: {}", self.0),
        ).into_response()
    }
}

// Реализация этого трейта необходима для того, чтобы можно было
// преобразовать anyhow::Error в AppError.
impl<E> From<E> for AppError
where
    E: Into<anyhow::Error>,
{
    fn from(err: E) -> Self {
        Self(err.into())
    }
}

// Точка входа программы.
// #[tokio::main()] необходим, поскольку приложение
// использует tokio runtime и является асинхронным.
// Без этого макроса нельзя сделать main async и выполнять
// внутри await.
#[tokio::main()]
async fn main() {
    // Берём URL к базе данных из той же переменной среды, которую
    // использует SQLx CLI.
    let db_url = std::env::var("DATABASE_URL")
        .expect("DATABASE_URL env is not provided");
    
    // Определим пул подключений к базе данных. Он необходим
    // для совершения любых запросов.
    let pool = PgPoolOptions::new()
        .max_connections(5) 
        .acquire_timeout(Duration::from_secs(3))
        .connect(db_url.as_str())
        .await
        .expect("Error connecting to database");
    
    // Созданим новый Router, который будет перенаправлять
    // запросы в специальные функции-обработчики.
    // Так же добавим в роутер пул подключений к базе данных,
    // чтобы функции-обработчики могли к ней подключиться.
    let app = Router::new()
        .route("/customers", get(customers))
        .route("/sizes", get(sizes))
        .route("/materials", get(materials))
        .route("/book_orders", get(book_orders))
        .route("/painting_orders", get(painting_orders))
        .route("/history", get(history))
        .route("/top_books", get(top_books))
        .with_state(pool);

    // Определим listener, который по своей сути является
    // сокет-сервером и привяжем его к URL приложения.
    let listener = TcpListener::bind(BASE_URL)
        .await
        .expect(format!("Error binding to {}", BASE_URL).as_str());

    println!("Listening at {}", BASE_URL);
    
    // Теперь, когда всё готово, можно запустить приложения
    // и начать обрабатывать запросы.
    serve(listener, app)
        .await
        .expect("Error serving app")
}

// Далее идут функции-обработчики.
// Все они принимают в себя пул подключений к базе
// данных для совершения запросов.
// И все они возвращают Result, который может
// содержать либо JSON с ответом на запрос, либо ошибку.
//
// Обратите внимание на макрос query_as!. Он автоматически
// преобразует результат запроса к указанному типу, а так же
// проверит правильность написанного SQL. В том числе проверит
// на соответствие существующим таблицам в базе. Если запрос
// составлен неправильно, будет ошибка компиляции, а не исключение
// во время запуска приложения.
async fn customers(State(db): State<PgPool>) 
    -> Result<Json<Vec<Customer>>, AppError> {
    let customers = query_as!(Customer, 
        "SELECT 
            id,
            name,
            surname,
            address,
            phone 
        FROM 
            customers")
        .fetch_all(&db)
        .await?;

    Ok(Json(customers))
}

async fn sizes(State(db): State<PgPool>) 
    -> Result<Json<Vec<Size>>, AppError> {
    let sizes = query_as!(Size, 
        "SELECT id, name FROM sizes")
        .fetch_all(&db)
        .await?;

    Ok(Json(sizes))
}

async fn materials(State(db): State<PgPool>) 
    -> Result<Json<Vec<Material>>, AppError> {
    let materials = query_as!(Material, "
        SELECT
            id,
            name,
            description,
            price,
            stock 
        FROM
            materials")
        .fetch_all(&db)
        .await?;

    Ok(Json(materials))
}

async fn book_orders(State(db): State<PgPool>) 
    -> Result<Json<Vec<BookOrder>>, AppError> {
    let orders = query_as!(BookOrder, "
        SELECT
            id, 
            customer_id,
            datetime,
            cost,
            number_of_turns,
            size_id,
            material_id 
        FROM 
            book_orders")
        .fetch_all(&db)
        .await?;

    Ok(Json(orders))
}

async fn painting_orders(State(db): State<PgPool>) 
    -> Result<Json<Vec<PaintingOrder>>, AppError> {
    let orders = query_as!(PaintingOrder, "
        SELECT 
            id,
            customer_id,
            datetime,
            cost,
            width,
            height 
        FROM 
            painting_orders")
        .fetch_all(&db)
        .await?;

    Ok(Json(orders))
}

// Здесь компилятор уже не может адекватно проверить
// запрос на правильность, поскольку считает, что каждый 
// из столбцов результата может содержать NULL. Однако мы
// можем гарантировать, что все эти поля будут не NULL, поэтому
// используем чуть менее безопасную функцию query_as вместо макроса.
async fn history(State(db): State<PgPool>)
    -> Result<Json<Vec<Order>>, AppError> {
    let orders: Vec<Order> = query_as("
        SELECT
        	customers.name,
        	customers.surname,
        	subquery.datetime,
        	subquery.cost,
        	subquery.kind
        FROM (
        	SELECT
        		customer_id, cost, datetime, 'book' as kind
        	FROM 
        		book_orders
        	UNION
        	SELECT
        		customer_id, cost, datetime, 'painting' as kind
        	FROM 
        		painting_orders
        ) AS subquery
        JOIN
        	customers
        ON subquery.customer_id = customers.id
        ")
        .fetch_all(&db)
        .await?;

    Ok(Json(orders))
}

async fn top_books(State(db): State<PgPool>)
    -> Result<Json<Vec<TopBook>>, AppError> {
    let books = query_as!(TopBook, "
        SELECT
            book_orders.cost as cost,
            book_orders.number_of_turns as number_of_turns,
        	sizes.name as size,
        	materials.name as material
        FROM 
            book_orders
        JOIN 
        	materials 
        ON 
        	book_orders.material_id = materials.id
        JOIN 
        	sizes
        ON 
        	book_orders.size_id = sizes.id
        ORDER BY 
        	book_orders.cost DESC
        LIMIT 5
        ")
        .fetch_all(&db)
        .await?;

    Ok(Json(books))
}
