use godot::prelude::*;

#[derive(GodotClass)]
#[class(init)]
/// Class to handle mouse and keyaboard input using Enigo
pub struct GodouseInput {}


#[godot_api]
impl GodouseInput {
    #[func]
    pub fn setup(&mut self) {}

    /// Returns a Vector2 representing the current cursor position on the screen.
    #[func]
    pub fn get_cursor_position(&mut self) -> Vector2 {
        return Vector2::ZERO;
    }

    /// Moves the mouse to the specified (x, y) coordinates on the screen.
    #[func]
    pub fn move_mouse_to(&mut self, _x: i32, _y: i32) {}

    /// Simulates a mouse button click or a keyboard key.
    #[func]
    pub fn simulate_button(&mut self, _button: i32) {}
}