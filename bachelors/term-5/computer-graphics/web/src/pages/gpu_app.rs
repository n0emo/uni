use std::{
    marker::PhantomData,
    sync::{Arc, Mutex},
};

use framework::Application;
use leptos::{html, prelude::*};
use stylance::import_crate_style;

import_crate_style!(style, "src/pages/gpu_app.module.scss");

#[component]
fn App<A: Application + 'static>(#[prop(optional)] marker: PhantomData<A>) -> impl IntoView {
    let _ = marker;

    let handle = Arc::new(Mutex::new(framework::ApplicationHandle::default()));
    let handle_cloned = handle.clone();

    let canvas = NodeRef::<html::Canvas>::new();
    canvas.on_load(|_| {
        framework::run::<A>(Some(handle_cloned));
    });

    on_cleanup(move || {
        handle.lock().unwrap().exit();
    });

    view!(
        <h1>{A::DESCRIPTION}</h1>
        <canvas node_ref=canvas id="canvas" class=style::window />
    )
}

#[component]
pub fn Lab1() -> impl IntoView {
    view!(<App marker={PhantomData::<lab1::Application>} />)
}

#[component]
pub fn Lab2() -> impl IntoView {
    view!(<App marker={PhantomData::<lab2::Application>} />)
}

#[component]
pub fn Lab3() -> impl IntoView {
    view!(<App marker={PhantomData::<lab3::Application>} />)
}

#[component]
pub fn CourseProject() -> impl IntoView {
    view!(<App marker={PhantomData::<course_project::Application>} />)
}
