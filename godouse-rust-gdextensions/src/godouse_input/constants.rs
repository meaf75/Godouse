use godot::prelude::*;


#[derive(GodotClass)]
#[class(init)]
/// Class to handle mouse and keyaboard input using Enigo
pub struct GodouseInputConstants {}

#[godot_api]
impl GodouseInputConstants {
    #[constant]
    pub const MOUSE_BUTTON_LEFT_CLICK: i32 = 0;
    #[constant]
    pub const MOUSE_BUTTON_RIGHT_CLICK: i32 = 1;
    #[constant]
    pub const MEDIA_KEY_PLAY_PAUSE: i32 = 2;
    #[constant]
    pub const MEDIA_KEY_NEXT_TRACK: i32 = 3;
    #[constant]
    pub const MEDIA_KEY_PREVIOUS_TRACK: i32 = 4;
}