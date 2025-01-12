use course_project::Application;
use framework::run;

fn main() {
    env_logger::init();
    run::<Application>(None);
}
