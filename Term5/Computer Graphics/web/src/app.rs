use std::{marker::PhantomData, time::Duration};

use framework::Application as _;
use leptos::prelude::*;
use leptos_router::{
    components::{Route, Router, Routes, RoutingProgress, A},
    path,
};

use crate::pages::{About, Index};
use crate::components::gpu_app::App as GpuApp;

#[component]
pub fn App() -> impl IntoView {
    let (is_routing, set_is_routing) = signal(false);
    view!(
        <Router set_is_routing>
            <nav>
                <ul>
                    <li><A href="/">"На главную"</A></li>
                    <li><A href="/lab/1">{lab1::Application::NAME}</A></li>
                    <li><A href="/lab/2">{lab2::Application::NAME}</A></li>
                    <li><A href="/about">"О проекте"</A></li>
                </ul>
            </nav>
            <div class="routing-progress">
                <RoutingProgress is_routing max_time=Duration::from_millis(250)/>
            </div>
            <main>
                <Routes transition=true fallback=|| "Невозможно найти запрошенную страницу">
                    <Route path=path!("/") view=Index/>
                    <Route path=path!("/lab/1") view=|| view!(<GpuApp marker={PhantomData::<lab1::Application>} />)/>
                    <Route path=path!("/lab/2") view=|| view!(<GpuApp marker={PhantomData::<lab2::Application>} />)/>
                    <Route path=path!("/about") view=About/>
                </Routes>
            </main>
        </Router>
    )
}
