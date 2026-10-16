use framework::run;
use lab_3::Application;

fn main() {
    env_logger::init();
    run::<Application>(None);
}
