use framework::run;
use lab_2::Application;

fn main() {
    env_logger::init();
    run::<Application>(None);
}
