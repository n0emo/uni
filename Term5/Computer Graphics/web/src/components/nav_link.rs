use leptos::prelude::*;
use leptos_router::{components::A, location::BrowserUrl};
use stylance::import_crate_style;
use leptos_router::location::LocationProvider;

import_crate_style!(style, "src/components/nav_link.module.scss");

#[component]
pub fn Link(
    text: &'static str,
    href: &'static str,
    #[prop(default = false)]
    top: bool,
) -> impl IntoView {
    let location = use_context::<BrowserUrl>().unwrap();

    view!(
        <div class={move || {
            let mut class = String::from(style::link);
            if location.as_url().get().path() == href {
                class.push(' ');
                class.push_str(style::active);
            }
            if top {
                class.push(' ');
                class.push_str(style::top);
            }
            class
        }}>
            <A href={href}>{text}</A>
        </div>
    )
}
