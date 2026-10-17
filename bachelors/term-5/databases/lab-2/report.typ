#import "../common.typ": *

#show: report.with(
  number: "2",
  title: "Разделение и организация данных с сайта",
  kind: "laboratory",
)

== Цель работы

Получить HTML-код страницы некоторого сайта. Распарсить его на данные. Проанализировать полученные
данные.

== Ход работы

=== Получение HTML-кода

Для получения HTML-кода страницы с информацией о преподавателях использовалась библиотека `reqwest`.
Для структуры `ParseScheduleProvider` был реализован метод `get_teachers`, который выполняет
HTTP-запрос к URL-адресу, содержащему информацию о преподавателях:

```rust
pub async fn get_teachers(&self) -> Result<Vec<ParsedTeacher>, ParseError> {
    let document = reqwest::get(self.employees_url.clone())
        .await?
        .text()
        .await?;
    Ok(parse_teachers(document.as_str()))
}
```

=== Парсинг данных

Парсинг HTML-кода осуществляется с помощью библиотеки `scraper`, которая позволяет использовать
CSS-селекторы для извлечения нужных данных. В функции `parse_teachers` происходит следующее:

- Очистка HTML-кода: используются регулярные выражения для замены ненужных элементов, таких как
  `<br>` и лишние символы, чтобы упростить дальнейший парсинг.
- Извлечение данных: с помощью селекторов извлекаются данные о преподавателях. Для каждого элемента,
  соответствующего селектору `STAFF_SELECTOR`, извлекаются имя, должность и кафедра:

Селекторы:

```rust
lazy_static! {
    static ref STAFF_SELECTOR: Selector = Selector::parse("tr[itemprop=teachingStaff]").unwrap();
    static ref TITLE_SELECTOR: Selector = Selector::parse("a.title").unwrap();
    static ref POST_SELECTOR: Selector = Selector::parse("td[itemprop=post]").unwrap();
}
```

Функция парсинга преподавателей:

```rust
pub fn parse_teachers(document: &str) -> Vec<ParsedTeacher> {
    let re = Regex::new(r#"<br\s*\/?>.*<\/td>"#).unwrap();
    let document = re.replace_all(&document, "</td>");
    let re = Regex::new(r#"Кафедра|«|»"#).unwrap();
    let document = re.replace_all(&document, "");

    let document_str: &str = &document;

    let document = Html::parse_document(document_str);

    document
        .select(&STAFF_SELECTOR)
        .flat_map(|r| {
            let post = content(r, &POST_SELECTOR)?;
            let post = post.split_once(" - ");
            Some(ParsedTeacher {
                name: content(r, &TITLE_SELECTOR)?,
                post: post.map(|p| p.0.trim().to_owned()),
                cathedral: post.map(|p| p.1.trim().trim_end_matches(',').to_owned()),
            })
        })
        .collect()
}
```

=== Добавление в БД

Извлеченные данные собираются в вектор `Vec<ParsedTeacher>`, который затем возвращается из функции.
Далее полученные данные заносятся в базу данных преподавателей для дальнейшего использования.

== Выводы

В ходе работы были успешно извлечены ключевые сведения, такие как имена, должности и кафедры,
которые были структурированы в удобные объекты для дальнейшего анализа.

#appendixes[
  = Исходный текст модуля парсинга

  #code-file(
    ```rust
    use error::ParseError;
    use model::{ParsedTeacher, ParsedWeek};
    use scrapping::{parse_teachers, parse_week};

    use crate::{
        mapping::{parsed_day_to_day_nodb, parsed_lesson_to_lesson_nodb, parsed_week_to_week_nodb},
        model::{Day, Lesson, Week},
        week::{WeekParity, Weekday},
    };
    use url::Url;

    pub mod error;
    pub mod model;
    mod scrapping;

    #[derive(Clone)]
    pub struct ParseScheduleProvider {
        room_url: Url,
        employees_url: Url,
    }

    impl ParseScheduleProvider {
        pub fn new() -> Result<Self, url::ParseError> {
            let room_url = Url::parse("https://rasp.pgups.ru/schedule/room")?;
            let employees_url = Url::parse("https://www.pgups.ru/sveden/employees")?;
            Ok(Self {
                room_url,
                employees_url,
            })
        }
        pub async fn get_raw_week(
            &self,
            room_id: &str,
            parity: WeekParity,
        ) -> Result<ParsedWeek, ParseError> {
            let p = match parity {
                WeekParity::Even => 0,
                WeekParity::Odd => 1,
            }
            .to_string();

            let response = reqwest::Client::new()
                .get(self.room_url.clone())
                .query(&[("room", room_id), ("odd", p.as_str())])
                .send()
                .await?
                .text()
                .await?;

            Ok(parse_week(&response))
        }

        pub async fn get_teachers(&self) -> Result<Vec<ParsedTeacher>, ParseError> {
            let document = reqwest::get(self.employees_url.clone())
                .await?
                .text()
                .await?;
            Ok(parse_teachers(document.as_str()))
        }

        pub async fn get_lesson(
            &self,
            room: &str,
            pair_num: i32,
            weekday: Weekday,
            parity: WeekParity,
        ) -> Result<Option<Lesson>, ParseError> {
            let week = self.get_raw_week(room, parity).await?;
            let weekday: Weekday = weekday;

            Ok(week[weekday]
                .data
                .iter()
                .find(|l| l.pair_num == pair_num)
                .map(|l| parsed_lesson_to_lesson_nodb(l.clone())))
        }

        pub async fn get_day(
            &self,
            room: &str,
            weekday: Weekday,
            parity: WeekParity,
        ) -> Result<Day, ParseError> {
            let week = self.get_raw_week(room, parity).await?;
            let weekday: Weekday = weekday;

            Ok(parsed_day_to_day_nodb(week[weekday].clone()))
        }

        pub async fn get_week(&self, room: &str, parity: WeekParity) -> Result<Week, ParseError> {
            let week = self.get_raw_week(room, parity).await?;
            Ok(parsed_week_to_week_nodb(week))
        }
    }
    ```.text,
    name: "src/parse/mod.rs",
  )
  #code-file(
    ```rust
    use super::model::{ParsedDay, ParsedLesson, ParsedTeacher, ParsedWeek};
    use crate::rustr::RuString;
    use crate::week::Weekday;
    use lazy_static::lazy_static;
    use regex::Regex;
    use scraper::{ElementRef, Html, Selector};

    lazy_static! {
        static ref STAFF_SELECTOR: Selector = Selector::parse("tr[itemprop=teachingStaff]").unwrap();
        static ref TITLE_SELECTOR: Selector = Selector::parse("a.title").unwrap();
        static ref POST_SELECTOR: Selector = Selector::parse("td[itemprop=post]").unwrap();
        static ref TABLE_SELECTOR: Selector = Selector::parse(".table.m-table.mb-5").unwrap();
        static ref WEEKDAY_SELECTOR: Selector = Selector::parse(".kt-font-dark").unwrap();
        static ref TR_SELECTOR: Selector = Selector::parse("tr").unwrap();
        static ref PAIR_SELECTOR: Selector = Selector::parse(".text-center.align-middle").unwrap();
        static ref DISCIPLINE_SELECTOR: Selector = Selector::parse("span.mr-1").unwrap();
        static ref TYPE_SELECTOR: Selector = Selector::parse(".badge.badge-pill").unwrap();
        static ref TEACHER_SELECTOR: Selector =
            Selector::parse("td:nth-last-of-type(1) a.kt-link").unwrap();
        static ref GROUP_SELECTOR: Selector =
            Selector::parse("a.btn.btn-sm.btn-elevate.btn-secondary.btn-pill.mr-1.mb-2.py-1.px-2")
                .unwrap();
    }

    pub fn parse_week(document: &str) -> ParsedWeek {
        let days = Html::parse_document(document)
            .select(&TABLE_SELECTOR)
            .flat_map(|d| parse_day(d))
            .collect::<Vec<_>>();

        let mut week = ParsedWeek::new();

        for (weekday, lessons) in days {
            week[weekday] = ParsedDay { data: lessons };
        }

        week
    }

    fn parse_day(block: ElementRef) -> Option<(Weekday, Vec<ParsedLesson>)> {
        let weekday = block
            .select(&WEEKDAY_SELECTOR)
            .next()
            .map(|w| w.text().collect::<String>())
            .and_then(|w| Weekday::from_ru_str(w.as_str()))?;

        let mut lessons = block
            .select(&TR_SELECTOR)
            .flat_map(|l| parse_lesson(l))
            .collect::<Vec<_>>();
        lessons.sort_by(|a, b| a.pair_num.cmp(&b.pair_num));

        Some((weekday, lessons))
    }

    fn parse_lesson(lesson: ElementRef) -> Option<ParsedLesson> {
        Some(ParsedLesson {
            pair_num: content(lesson, &PAIR_SELECTOR)?
                .chars()
                .filter(|c| "0123456789".contains(*c))
                .collect::<String>()
                .parse::<i32>()
                .ok()?,
            discipline: content(lesson, &DISCIPLINE_SELECTOR)?,
            type_of_discipline: content(lesson, &TYPE_SELECTOR),
            teacher: content(lesson, &TEACHER_SELECTOR),
            groups: lesson
                .select(&GROUP_SELECTOR)
                .map(|e| e.text().collect::<String>())
                .collect(),
        })
    }

    #[allow(unused)]
    pub fn parse_teachers(document: &str) -> Vec<ParsedTeacher> {
        let re = Regex::new(r#"<br\s*\/?>.*<\/td>"#).unwrap();
        let document = re.replace_all(&document, "</td>");
        let re = Regex::new(r#"Кафедра|«|»"#).unwrap();
        let document = re.replace_all(&document, "");

        let document_str: &str = &document;

        let document = Html::parse_document(document_str);

        document
            .select(&STAFF_SELECTOR)
            .flat_map(|r| {
                let post = content(r, &POST_SELECTOR)?;
                let post = post.split_once(" - ");
                Some(ParsedTeacher {
                    name: content(r, &TITLE_SELECTOR)?,
                    post: post.map(|p| p.0.trim().to_owned()),
                    cathedral: post.map(|p| p.1.trim().trim_end_matches(',').to_owned()),
                })
            })
            .collect()
    }

    fn content(block: ElementRef, selector: &Selector) -> Option<String> {
        Some(block.select(selector).next()?.text().collect::<String>())
    }
    ```.text,
    name: "src/parse/scrapping.rs",
  )
  #code-file(
    ```rust
    use std::ops::{Index, IndexMut};

    use crate::week::Weekday;
    use serde::Serialize;
    use utoipa::ToSchema;

    #[derive(Debug, Serialize, Clone)]
    pub struct ParsedLesson {
        pub pair_num: i32,
        pub discipline: String,
        pub type_of_discipline: Option<String>,
        pub teacher: Option<String>,
        pub groups: Vec<String>,
    }

    #[derive(Debug, Serialize, Clone, Default)]
    pub struct ParsedDay {
        pub data: Vec<ParsedLesson>,
    }

    #[derive(Debug, Serialize)]
    pub struct ParsedWeek {
        pub days: Vec<ParsedDay>,
    }

    impl ParsedWeek {
        pub fn new() -> Self {
            let mut days: Vec<ParsedDay> = Vec::with_capacity(7);
            for _ in 0..7 {
                days.push(ParsedDay::default())
            }

            Self { days }
        }
    }

    impl Index<Weekday> for ParsedWeek {
        type Output = ParsedDay;

        fn index(&self, weekday: Weekday) -> &Self::Output {
            &self.days[weekday.days_from_monday() as usize]
        }
    }

    impl IndexMut<Weekday> for ParsedWeek {
        fn index_mut(&mut self, weekday: Weekday) -> &mut Self::Output {
            &mut self.days[weekday.days_from_monday() as usize]
        }
    }

    // TODO: other fields
    #[derive(Debug, Clone, Serialize, ToSchema)]
    pub struct ParsedTeacher {
        pub name: String,
        pub post: Option<String>,
        pub cathedral: Option<String>,
    }
    ```.text,
    name: "src/parse/model.rs",
  )
  #code-file(
    ```rust
    use thiserror::Error;

    #[derive(Debug, Error)]
    pub enum ParseError {
        #[error("Request error: {0}")]
        Reqwest(#[from] reqwest::Error),

        #[error("SQL error: {0}")]
        Sql(#[from] sqlx::Error),
    }
    ```.text,
    name: "src/parse/error.rs",
  )
]
