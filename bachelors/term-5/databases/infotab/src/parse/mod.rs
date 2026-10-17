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
