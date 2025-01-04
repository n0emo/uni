use std::{marker::PhantomData, sync::{Arc, Mutex}};

use framework::Application;
use leptos::prelude::*;

#[component]
pub fn App<A: Application + 'static>(
    #[prop(optional)] marker: PhantomData<A>
) -> impl IntoView {
    let _ = marker;

    let handle = Arc::new(Mutex::new(framework::ApplicationHandle::default()));
    framework::run::<A>("Lab".to_owned(), Some(handle.clone()));

    on_cleanup(move || {
        handle.lock().unwrap().exit();
    });

    view!(
        <h1>"Лабораторная работа №1 - ФИО на WebGPU"</h1>
        <canvas id="canvas" style="display: block; width: 100%; height: 100%; aspect-ratio: 16 / 9" />
    )
}
