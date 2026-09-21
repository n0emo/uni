```rs
use serde::{
    Deserialize,
    Serialize,
};
use utoipa::ToSchema;

/// Represents a university lesson information
#[derive(Debug, Serialize, Deserialize, ToSchema)]
pub struct Lesson {
    pub id: i32,
    pub pair_num: u32,
    pub discipline: Option<String>,
    pub type_of_discipline: Option<String>,
    pub teacher: Option<Teacher>,
    pub groups: Vec<String>,
}

/// Represents lessons vector per day
#[derive(Debug, Serialize, Deserialize, ToSchema)]
pub struct Day {
    pub lessons: Vec<Lesson>,
}

/// Represents schedule of all week
#[derive(Debug, Serialize, Deserialize, ToSchema)]
pub struct Week {
    pub days: [Day; 7],
}

/// Represents schedule for classroom
#[derive(Debug, Serialize, Deserialize, ToSchema)]
pub struct ClassroomSchedule {
    pub odd: Week,
    pub even: Week,
}

/// Represents teacher
#[derive(Debug, Serialize, Deserialize, ToSchema)]
pub struct Teacher {
    pub id: i32,
    pub name: String,
    pub occupation: Option<String>,
    pub department: Option<String>,
}

/// Command to send to the device
#[derive(Debug, Serialize, Deserialize, ToSchema)]
#[serde(tag = "command", content = "data")]
pub enum InfotabDeviceCommand {
    Ping,

    DisplaySchedule { room: String, schedule: Box<ClassroomSchedule>, },
}

/// Message for sending to Infotab device
#[derive(Debug, Serialize, Deserialize, ToSchema)]
pub enum InfotabDeviceMessage {
    DisplaySchedule { room: String, schedule: ClassroomSchedule, },
}
```
