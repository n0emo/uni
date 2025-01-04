use std::sync::{Arc, Mutex};
use lab1::Application;

use leptos::prelude::*;

#[component]
pub fn Lab1() -> impl IntoView {
    let handle = Arc::new(Mutex::new(framework::ApplicationHandle::default()));
    framework::run::<Application>("Hello, World!".to_owned(), Some(handle.clone()));

    on_cleanup(move || {
        handle.lock().unwrap().exit();
    });

    view!(
        <h1>"Лабораторная работа №1 - ФИО на WebGPU"</h1>
        <canvas id="canvas" style="display: block; width: 100%; height: 100%; aspect-ratio: 16 / 9" />
    )
}
