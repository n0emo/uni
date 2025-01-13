use leptos::prelude::*;

stylance::import_crate_style!(style, "src/pages/index.module.scss");

#[component]
pub fn Index() -> impl IntoView {
    view!(
        <div class=style::header>
            <h1>"Главная"</h1>
            <p>
                {"На данной странице представлены лабораторные работы и курсовой
                проект по дисциплине \"Компьютерная графика\", выполненные
                студентом Альбертом Шефнером. Исходный код этого сайта каждой
                работы доступен "}
                <a href="https://github.com/n0emo/uni/tree/main/Term5/Computer%20Graphics/">здесь</a>.
            </p>
        </div>
    )
}
