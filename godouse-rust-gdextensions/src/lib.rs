use godot::prelude::*;
mod godouse_input;
mod godouse_tray;

struct Godouse;

#[gdextension]
unsafe impl ExtensionLibrary for Godouse {}