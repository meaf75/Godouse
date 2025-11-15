use godot::prelude::*;
use enigo::{Button, Coordinate::Abs, Enigo, Keyboard, Mouse, Settings};
use device_query::{DeviceQuery, DeviceState};

use super::constants::GodouseInputConstants;

#[derive(GodotClass)]
#[class(init)]
/// Class to handle mouse and keyaboard input using Enigo
pub struct GodouseInput {
    enigo: Option<Enigo>,
    device_state: DeviceState
}


#[godot_api]
impl GodouseInput {
    #[func]
    pub fn setup(&mut self) {
        self.enigo = Some(Enigo::new(&Settings::default()).unwrap());
        self.device_state = DeviceState::new();
    }

    /// Returns a Vector2 representing the current cursor position on the screen.
    #[func]
    pub fn get_cursor_position(&mut self) -> Vector2 {
        self.device_state.get_mouse().coords;
        return Vector2::new(
            self.device_state.get_mouse().coords.0 as f32,
            self.device_state.get_mouse().coords.1 as f32,
        );
    }

    /// Moves the mouse to the specified (x, y) coordinates on the screen.
    #[func]
    pub fn move_mouse_to(&mut self, x: i32, y: i32) {
        let Some(enigo) = &mut self.enigo else {
            godot_print!("Enigo not initialized. Call setup() first.");
            return;
        };

        enigo.move_mouse(x, y, Abs).unwrap();        
    }

    /// Simulates a mouse button click or a keyboard key.
    #[func]
    pub fn simulate_button(&mut self, button: i32) {
        let Some(enigo) = &mut self.enigo else {
            godot_print!("Enigo not initialized. Call setup() first.");
            return;
        };

        if button == GodouseInputConstants::MOUSE_BUTTON_LEFT_CLICK {
            enigo.button(Button::Left, enigo::Direction::Click).unwrap();
        } else if button == GodouseInputConstants::MOUSE_BUTTON_RIGHT_CLICK {
            enigo.button(Button::Right, enigo::Direction::Click).unwrap();
        } else if button == GodouseInputConstants::MEDIA_KEY_PLAY_PAUSE {
            enigo.raw(172, enigo::Direction::Click).unwrap();
        } else if button == GodouseInputConstants::MEDIA_KEY_NEXT_TRACK {
            enigo.raw(171, enigo::Direction::Click).unwrap();
        } else if button == GodouseInputConstants::MEDIA_KEY_PREVIOUS_TRACK {
            enigo.raw(173, enigo::Direction::Click).unwrap();
        } else {
            godot_print!("Unsupported mouse button: {}", button);
        }
    }
}