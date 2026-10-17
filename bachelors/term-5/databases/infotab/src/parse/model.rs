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
