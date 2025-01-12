use framework::run;
use lab2::Application;

fn main() {
    env_logger::init();
    run::<Application>(None);
}
