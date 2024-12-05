use leptos::prelude::*;

use computer_graphics::app::App;

fn main() {
    console_error_panic_hook::set_once();
    mount_to_body(App);
}
