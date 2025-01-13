use leptos::prelude::*;
use stylance::import_crate_style;

import_crate_style!(style, "src/components/header.module.scss");

#[component]
pub fn Header() -> impl IntoView {
    view!(
        <div class=style::header>
            <h1>"Компьютерная графика"</h1>
        </div>
    )
}
