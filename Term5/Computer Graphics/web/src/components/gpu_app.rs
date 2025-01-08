use std::{
    marker::PhantomData,
    sync::{Arc, Mutex},
};

use framework::Application;
use leptos::{html, prelude::*};

#[component]
pub fn App<A: Application + 'static>(#[prop(optional)] marker: PhantomData<A>) -> impl IntoView {
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
        <canvas node_ref=canvas id="canvas" style="display: block; width: 100%; height: 100%; aspect-ratio: 16 / 9" />
    )
}
