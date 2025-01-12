use framework::run;
use lab3::Application;

fn main() {
    env_logger::init();
    run::<Application>(None);
}
