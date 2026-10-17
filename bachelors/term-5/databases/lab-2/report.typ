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

  #code-file(read("../infotab/src/parse/mod.rs"), name: "src/parse/mod.rs")
  #code-file(read("../infotab/src/parse/scrapping.rs"), name: "src/parse/scrapping.rs")
  #code-file(read("../infotab/src/parse/model.rs"), name: "src/parse/model.rs")
  #code-file(read("../infotab/src/parse/error.rs"), name: "src/parse/error.rs")
]
