use framework::run;
use lab_1::Application;

fn main() {
    env_logger::init();
    run::<Application>(None);
}
