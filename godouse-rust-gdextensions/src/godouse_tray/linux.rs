use std::sync::mpsc::{Receiver, Sender, SyncSender};

use godot::classes::Node;
use godot::prelude::*;
use {
    std::sync::mpsc,
    tray_item::{IconSource, TrayItem},
};

/// Class to handle system tray functionality on Linux
#[derive(GodotClass)]
#[class(base=Node, init)]
pub struct GodouseTray {
    base: Base<Node>,
    tx: Option<SyncSender<Message>>,
    godot_tx: Option<Sender<GodotEvent>>,
    godot_rx: Option<Receiver<GodotEvent>>,
}

enum Message {
    Quit,
}

enum GodotEvent {
    TrayQuit,
}

#[godot_api]
impl GodouseTray {
    /// Signal emitted when a close request is received from the tray menu.
    #[signal]
    fn on_receive_close_request();

    /// Starts the system tray with the specified icon.vaca
    #[func]
    pub fn start(&mut self, icon_path: String) {
        let icon_path_static: &'static str = Box::leak(icon_path.into_boxed_str());

        let (godot_tx, godot_rx) = mpsc::channel::<GodotEvent>();
        self.godot_tx = Some(godot_tx.clone());
        self.godot_rx = Some(godot_rx);

        let (tx, rx) = mpsc::sync_channel::<Message>(2);
        self.tx = Some(tx.clone());

        godot_print!("Starting tray...");
        std::thread::spawn(move || {
            let mut tray = TrayItem::new("Godouse", IconSource::Resource(icon_path_static)).unwrap();
            tray.add_label("Godouse").unwrap();

            let quit_tx = tx.clone();
            tray.add_menu_item("Quit", move || {
                quit_tx.send(Message::Quit).unwrap();
            })
            .unwrap();

            loop {
                match rx.recv() {
                    Ok(Message::Quit) => {
                        godot_tx.send(GodotEvent::TrayQuit).unwrap();
                        break;
                    }
                    _ => {}
                }
            }
        });
    }
    

    /// Terminates the system tray.
    #[func]
    pub fn terminate_tray(&mut self) {
        godot_print!("Terminating tray...");
        if self.tx.is_some() {
            let tx = self.tx.take().unwrap();
            tx.send(Message::Quit).unwrap();
        }
    }
}

#[godot_api]
impl INode for GodouseTray {
    fn process(&mut self, _delta: f64) {
        let event_opt = {
            let rx_opt = self.godot_rx.as_ref();
            rx_opt.and_then(|rx| rx.try_recv().ok())
        };

        if let Some(event) = event_opt {
            match event {
                GodotEvent::TrayQuit => {
                    godot_print!("Tray quit received");
                    self.signals().on_receive_close_request().emit();
                }
            }
        }
    }
}