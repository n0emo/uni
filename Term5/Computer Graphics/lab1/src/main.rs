use framework::run;
use lab1::Application;

fn main() {
    env_logger::init();
    run::<Application>(None);
}
