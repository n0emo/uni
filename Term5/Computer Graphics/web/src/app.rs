use std::time::Duration;

use framework::Application as _;
use leptos::prelude::*;
use leptos_router::{
    components::{Route, Router, Routes, RoutingProgress},
    path,
};

use crate::{components::{Link, Header}, pages::{CourseProject, Index, Lab1, Lab2, Lab3}};

stylance::import_crate_style!(pub style, "src/app.module.scss");

#[component]
pub fn App() -> impl IntoView {
    let (is_routing, set_is_routing) = signal(false);
    view!(
        <Router set_is_routing>
            <div class=style::sidebar>
                <Link href="/" text="На главную" top=true />
                <Link href="/lab/1" text=lab1::Application::NAME/>
                <Link href="/lab/2" text=lab2::Application::NAME/>
                <Link href="/lab/3" text=lab3::Application::NAME/>
                <Link href="/course-project" text=course_project::Application::NAME/>
            </div>
            <main class=style::page>
                <Header />
                <Routes transition=true fallback=|| "Невозможно найти запрошенную страницу">
                    <Route path=path!("/") view=Index/>
                    <Route path=path!("/lab/1") view=Lab1 />
                    <Route path=path!("/lab/2") view=Lab2 />
                    <Route path=path!("/lab/3") view=Lab3 />
                    <Route path=path!("/course-project") view=CourseProject />
                </Routes>
            </main>
            <div class="routing-progress">
                <RoutingProgress is_routing max_time=Duration::from_millis(250)/>
            </div>
        </Router>
    )
}
