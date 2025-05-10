use maud::{html, Markup};


pub mod pages {
    use super::{components::*, *};

    pub fn index() -> Markup {
        base(
            "Призывники",
            html! {
                h1 { "Призывники" }
            p {
                "Добро пожаловать на страницу сервиса призывников"
            }
        }
        )
    }

    pub fn add() -> Markup {
        base(
            "Призывники",
            html! {

            }
        )
    }

    pub fn list() -> Markup {
        base(
            "Призывники",
            html! {

            }
        )
    }
}

mod components {
    use super::*;
    pub fn base(
        title: &str,
        content: Markup,
    ) -> Markup {
        html! {
            html {
                head {
                    title { (title) }
                    script
                        src="https://unpkg.com/htmx.org@2.0.4"
                        integrity="sha384-HGfztofotfshcF7+8n44JQL2oJmowVChPTg48S+jvZoztPfvwD79OC/LTtG6dMp+"
                        crossorigin="anonymous"
                        {}
                }
                body {
                    (app_bar())
                    (content)
                }
            }
        }
    }

    pub fn app_bar() -> Markup {
        html! {
            nav {
                ul {
                    li { a href="/" { "Главная" } }
                    li { a href="/add" { "Добавить данные" } }
                    li { a href="/list" { "Список призывников" } }
                }
            }
        }
    }
}
