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
