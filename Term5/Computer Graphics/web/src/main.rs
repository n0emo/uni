use leptos::prelude::*;

fn main() {
    console_error_panic_hook::set_once();
    console_log::init().unwrap();
    
    mount_to_body(web::app::App);
}
