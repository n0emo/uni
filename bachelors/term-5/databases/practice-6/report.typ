ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Базы данных и управление данными»

#strong[ОТЧЁТ]

#strong[ПО ПРАКТИЧЕСКОЙ РАБОТЕ № 6]

#strong[«Хранение объектов с помощью Minio»]

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    [Выполнили студенты

    Факультет: АИТ

    Группа: ИВБ-211

    ], [Ахмедов Х.А.

    Кот Н.Д.

    Шефнер А.

    ],
    [Проверил:

    Профессор кафедры

    «Информационные и вычислительные

    системы

    ], [Хомоненко А.Д.],
  )]
  , kind: table
  )

#strong[Санкт-Петербург]

#strong[2024]

Оценочный лист результатов ПР № 6

Ф.И.О. студентов :#emph[Ахмедов Х.А., Кот Н.Д., Шефнер А.]

Группа \_\_\_\_\_\_\_\_\_\_\_\_\_#emph[ИВБ-211]\_\_\_\_\_\_\_\_\_\_\_\_

Профессор кафедры

«Информационные и вычислительные

системы»#strong[ Хомоненко А.Д. «\_\_» \_\_\_\_\_\_\_\_\_\_2024 г. ]

#strong[Цель]

Установка и настройка #strong[Minio] в локальной среде или с
использованием облачного сервиса, создание веб-приложения с
использованием объектного хранилища.

#strong[Ход работы]

Для разработки веб-приложения выбран язык программирования высокого
уровня #strong[Rust] со следующими библиотеками:

- #strong[tokio] -- асинхронная среда выполнения
- #strong[axum] -- веб-фреймворк
- #strong[tracing] -- вывод логов приложения
- #strong[rust-s3] -- взаимодействие с S3-совместимыми хранилищами
- #strong[askama] -- шаблонизатор

#strong[HTML-страницы сервиса:]

#strong[templates/index.html]

\<!DOCTYPE html\>

\<html\>

\<head\>

\<meta charset=\"utf-8\" /\>

\<title\>ПГУПС Галерея\</title\>

\</head\>

\<body\>

\<h1\>Добро пожаловать в ПГУПС галерею!\</h1\>

\<form action=\"/images\" method=\"get\" \>

\<input type=\"submit\" value=\"Загрузить фото\" /\>

\</form\>

{% for image in images %}

\<img src=\"/images/{{ image }}\" alt=\"{{ image }}\" /\>

{% endfor %}

\</body\>

\</html\>

#strong[templates/images.html]

\<!DOCTYPE html\>

\<html\>

\<head\>

\<meta charset=\"utf-8\" /\>

\<title\>ПГУПС Галерея\</title\>

\</head\>

\<body\>

\<h1\>Загрузить фото\</h1\>

\<form action=\"/images\" method=\"post\"
enctype=\"multipart/form-data\" \>

\<input type=\"file\" name=\"image\" value=\"Выбрать фото...\" required
\/\>

\<input type=\"submit\" value=\"Загрузить\" /\>

\</form\>

\</body\>

\</html\>

#strong[#strong[Разработка сервиса для доступа к Minio]]

#strong[src/images.rs]

use std::sync::Arc;

use itertools::Itertools as \_;

use s3::{creds::Credentials, Bucket, BucketConfiguration, Region};

use tracing::info;

\#\[derive(Clone)\]

pub struct ImageService {

bucket: Arc\<Bucket\>,

}

impl ImageService {

pub async fn new(endpoint: String, access\_key: &str, secret\_key: &str)
\-\> anyhow::Result\<Self\> {

info!(\"Creating Minio bucket\");

let bucket\_name = \"pgups-images\";

let region = Region::Custom {

region: \"eu-central-1\".to\_owned(),

endpoint,

};

let credentials = Credentials::new(Some(access\_key), Some(secret\_key),
None, None, None)?;

let bucket = {

let mut bucket = Bucket::new(bucket\_name, region.clone(),
credentials.clone())?.with\_path\_style();

if !bucket.exists().await? {

bucket = Bucket::create\_with\_path\_style(

bucket\_name,

region,

credentials,

BucketConfiguration::default()

).await?.bucket;

}

Arc::new(\*bucket)

};

Ok(Self { bucket })

}

pub async fn list\_all(&self) -\> anyhow::Result\<Vec\<String\>\> {

let images = self.bucket.list(\"\".to\_owned(),
Some(\"/\".to\_owned())).await?;

Ok(images.into\_iter()

\.flat\_map(|i| i.contents.into\_iter())

\.sorted\_by\_key(|o| o.last\_modified.clone())

\.map(|o| o.key)

\.collect())

}

pub async fn get(&self, path: &str) -\> anyhow::Result\<(Vec\<u8\>,
String)\> {

let content\_type =
self.bucket.head\_object(path).await?.0.content\_type

\.ok\_or\_else(|| anyhow::anyhow!(\"There is no content-type in response
from Minio\"))?;

let image = self.bucket.get\_object(path).await?;

Ok((image.to\_vec(), content\_type))

}

pub async fn put(&self, image: &\[u8\], name: &str, content\_type: &str)
\-\> anyhow::Result\<()\> {

self.bucket.put\_object\_with\_content\_type(name, image,
content\_type).await?;

Ok(())

}

}

#strong[Разработка точек веб-приложения]

#strong[src/app.rs]

use askama\_axum::IntoResponse;

use askama::Template;

use axum::{body::Bytes, extract::{Path, State}, http::HeaderMap,
response::Redirect, routing::{get, post}, Router};

use axum\_typed\_multipart::{FieldData, TryFromMultipart,
TypedMultipart};

use crate::images::ImageService;

pub struct AppError(anyhow::Error);

impl IntoResponse for AppError {

fn into\_response(self) -\> askama\_axum::Response {

\(axum::http::StatusCode::INTERNAL\_SERVER\_ERROR,
self.0.to\_string()).into\_response()

}

}

impl From\<anyhow::Error\> for AppError {

fn from(value: anyhow::Error) -\> Self {

Self(value)

}

}

\#\[derive(Clone)\]

pub struct AppState {

pub images: ImageService,

}

\#\[derive(Template)\]

\#\[template(path = \"index.html\")\]

pub struct IndexTemplate {

images: Vec\<String\>,

}

\#\[derive(Template)\]

\#\[template(path = \"images.html\")\]

pub struct ImagesTemplate { }

\#\[derive(TryFromMultipart)\]

pub struct ImageMultipart {

pub image: FieldData\<Bytes\>,

}

pub fn app(state: AppState) -\> Router {

Router::new()

\.route(\"/\", get(get\_index))

\.route(\"/images/:path\", get(get\_images\_path))

\.route(\"/images\", get(get\_images))

\.route(\"/images\", post(post\_images))

\.with\_state(state)

}

async fn get\_index(State(state): State\<AppState\>) -\>
Result\<IndexTemplate, AppError\> {

let images = state.images.list\_all().await?;

Ok(IndexTemplate { images })

}

async fn get\_images\_path(State(state): State\<AppState\>, Path(path):
Path\<String\>) -\> Result\<impl IntoResponse, AppError\> {

let image = state.images.get(&path).await?;

let mut headers = HeaderMap::new();

headers.insert(\"Content-Type\", image.1.as\_str().parse().unwrap());

Ok((headers, image.0))

}

async fn get\_images() -\> ImagesTemplate {

ImagesTemplate { }

}

\#\[axum::debug\_handler\]

async fn post\_images(

State(state): State\<AppState\>,

TypedMultipart(ImageMultipart { image }):
TypedMultipart\<ImageMultipart\>

) -\> Result\<impl IntoResponse, AppError\> {

state.images.put(

&image.contents,

&image.metadata.file\_name.as\_deref()

\.ok\_or\_else(|| anyhow::anyhow!(\"No name provided!\"))?,

image.metadata.content\_type.as\_deref()

\.ok\_or\_else(|| anyhow::anyhow!(\"No content-type provided!\"))?

).await?;

Ok(Redirect::to(\"/\"))

}

#strong[Конфигурация и запуск сервера]

#strong[src/main.rs]

use tracing::info;

mod app;

mod images;

\#\[tokio::main\]

async fn main() -\> anyhow::Result\<()\> {

tracing\_subscriber::fmt()

\.compact()

\.with\_target(false)

\.with\_file(false)

\.init();

let images = {

let access\_key = \"48jbTBFkn9bjSpJJFtsA\";

let secret\_key = \"xVMtBeZGcVgsDLzuLt1XKugduSJWb6Br8zfDNms7\";

let endpoint = \"http:/\/localhost:9000\".to\_owned();

images::ImageService::new(endpoint, access\_key, secret\_key).await?

};

let state = app::AppState { images };

let app = app::app(state);

let listener = tokio::net::TcpListener::bind((\"0.0.0.0\",
3000)).await?;

info!(\"Listening at {}\", listener.local\_addr()?);

axum::serve(listener, app).await?;

Ok(())

}

#strong[Демонстрация работы веб-приложения]

#box(image("./assets/1000000100000405000003CCA827CF3A.png", height: 4.9311in, width: 5.2193in))#strong[Рис.
1 --- ]главная страница

#box(image("./assets/100000010000022B000000F01B45AA00.png", height: 2.1854in, width: 5.0543in))#strong[Рис.
2 --- ]страница загрузки фото

#strong[Вывод]

#strong[ ]В ходе данной работы был изучен принцип работы хранилища
Minio, а так же разработано веб-приложение, демонстрирующее хранение
изображений в виде объектов S3-совместимого хранилища. Rust позволяет
создавать более надёжные и безопасные приложения за счёт своих функций
безопасности типов и управления памятью, что важно для современной
разработки программного обеспечения.
