use std::time::Duration;

use leptos::prelude::*;
use leptos_router::{
    components::{Route, Router, Routes, RoutingProgress, A},
    path,
};

use crate::pages::{About, Index, Lab};

#[component]
pub fn App() -> impl IntoView {
    let (is_routing, set_is_routing) = signal(false);
    view!(
        <Router set_is_routing>
            <nav>
                <ul>
                    <li><A href="/">"На главную"</A></li>
                    <li><A href="/lab/1">"ЛР№1. Фамилия на WebGPU"</A></li>
                    <li><A href="/lab/2">"ЛР№2. (не готово)"</A></li>
                    <li><A href="/lab/3">"ЛР№3. (не готово)"</A></li>
                    <li><A href="/lab/4">"ЛР№4. (не готово)"</A></li>
                    <li><A href="/lab/5">"ЛР№5. (не готово)"</A></li>
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
