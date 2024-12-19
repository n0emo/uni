use std::time::Duration;

use leptos::prelude::*;
use leptos_router::{components::{Route, Router, Routes, RoutingProgress, A}, path};

use crate::pages::{About, Index, Lab};

#[component]
pub fn App() -> impl IntoView {
    let (is_routing, set_is_routing) = signal(false);
    view!(
        <Router set_is_routing>
            <nav>
                <ul>
                    <li><A href="/">"На главную"</A></li>
                    <li><A href="/lab/1">"1. ФИО на WebGPU"</A></li>
                    <li><A href="/lab/2">"2. 3D-объект вроде"</A></li>
                    <li><A href="/lab/3">"3. Что-то про шейдеры?"</A></li>
                    <li><A href="/lab/4">"4. Освещение"</A></li>
                    <li><A href="/lab/5">"5. Что-то ещё не помню"</A></li>
                    <li><A href="/about">"О проекте"</A></li>
                </ul>
            </nav>
            <div class="routing-progress">
                <RoutingProgress is_routing max_time=Duration::from_millis(250)/>
            </div>
            <main>
                <Routes transition=true fallback=|| "Невозможно найти запрошенную страницу">
                    <Route path=path!("/") view=Index/>
                    <Route path=path!("/lab/:id") view=Lab/>
                    <Route path=path!("/about") view=About/>
                </Routes>
            </main>
        </Router>
    )
}

