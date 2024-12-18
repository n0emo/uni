use leptos::prelude::*;
use leptos_router::{hooks::use_params, params::Params};

use crate::components::lab::{FullName, Lightning};

#[derive(Params, PartialEq)]
struct LabParams {
    id: Option<u32>,
}

#[component]
pub fn Lab() -> impl IntoView {
    let params = use_params::<LabParams>();
    let id = move || params.read().as_ref().ok().and_then(|params| params.id).unwrap_or_default();

    view!(
        {move || match id() {
            1 => FullName.into_any(),
            4 => Lightning.into_any(),
            _ => view!(<h1>"Лабораторной с таким номером \""{id()}"\" нет!"</h1>).into_any(),
        }}
    )
}

