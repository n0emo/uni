use std::sync::{Arc, Mutex};

use leptos::prelude::*;

#[derive(Clone)]
pub struct Application {
}

impl framework::Application for Application {
    fn init() -> Self {
        todo!()
    }

    fn resize() {
        todo!()
    }

    fn update() {
        todo!()
    }

    fn render() {
        todo!()
    }
}


pub struct Context {
}

#[component]
pub fn FullName() -> impl IntoView {
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
