use godot::prelude::*;
mod godouse_input;

struct Godouse;

#[gdextension]
unsafe impl ExtensionLibrary for Godouse {}