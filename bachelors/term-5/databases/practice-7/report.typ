#import "../common.typ": *

#show: report.with(number: "7", title: "Добыча данных (сбор информации с сервиса)")

== Цель работы

Получить HTML-код страницы некоторого сайта. Распарсить его на данные. Проанализировать полученные
данные.

== Ход работы

=== Получение HTML-кода

Для получения HTML-кода страницы с расписанием использовалась библиотека `reqwest`. В структуре
`ParseScheduleProvider` был реализован метод `get_raw_week`, который выполняет HTTP-запрос к
URL-адресу, содержащему информацию о расписании:

```rust
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
```

=== Парсинг данных

Парсинг HTML-кода осуществляется с помощью библиотеки `scraper`, которая позволяет использовать
CSS-селекторы для извлечения нужных данных. В функции `parse_week` происходит следующее:

Извлечение данных: с помощью селекторов извлекаются данные о расписании. Для каждой таблицы с
расписанием вызывается функция `parse_day`, которая обрабатывает каждый день недели, а в `parse_day`
вызывается `parse_lesson`, которая обрабатывает каждое занятие:

Методы парсинга расписания:

```rust
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
```

Селекторы:

```rust
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
```

=== Управление через админ-панель

Загрузка данных о расписании организована через админ-панель, где администраторы могут инициировать
процесс парсинга и добавления в базу данных.

#figure(
  caption: [Страница управления базой данных в админ-панели],
  image("./assets/admin-panel.png", width: 90%),
) <fig-admin-panel>

=== Вывод на информационные таблички

#figure(
  caption: [Расписание аудитории на информационной табличке],
  image("./assets/info-board.jpg", width: 90%),
) <fig-info-board>

== Выводы

В ходе практической работы по парсингу и анализу данных о расписании были успешно извлечены ключевые
сведения, такие как дни недели, номера пар, дисциплины, преподаватели и группы. Эти данные были
структурированы в удобные объекты для дальнейшего анализа и отображения в интерфейсе приложения.
Управление процессом парсинга осуществляется через админ-панель, что делает систему более удобной и
функциональной.

#appendixes[
  = Исходный текст модуля парсинга

  #code-file(read("../infotab/src/parse/mod.rs"), name: "src/parse/mod.rs")
  #code-file(read("../infotab/src/parse/scrapping.rs"), name: "src/parse/scrapping.rs")
  #code-file(read("../infotab/src/parse/model.rs"), name: "src/parse/model.rs")
  #code-file(read("../infotab/src/parse/error.rs"), name: "src/parse/error.rs")
]
