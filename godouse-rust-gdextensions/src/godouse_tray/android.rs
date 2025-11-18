use godot::classes::Node;
use godot::prelude::*;

/// Class to handle system tray functionality on Linux
#[derive(GodotClass)]
#[class(base=Node, init)]
pub struct GodouseTray {
    base: Base<Node>,
}


#[godot_api]
impl GodouseTray {
    /// Signal emitted when a close request is received from the tray menu.
    #[signal]
    fn on_receive_close_request();

    /// Starts the system tray with the specified icon.vaca
    #[func]
    pub fn start(&mut self, _icon_path: String){}

    /// Terminates the system tray.
    #[func]
    pub fn terminate_tray(&mut self){}
}
