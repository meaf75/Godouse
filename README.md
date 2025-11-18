# GODOUSE
Remote mouse controller made with godot and c++ gdextensions

client (Android), server (windows)

![main](./.github/assets/screen-main.png)
![options](./.github/assets/screen-config.png)

![tray](./.github/assets/tray.png)

# Running as background

## Linux

Copy the [Godouse.desktop](./Godouse.desktop) to `~/.config/autostart/godouse.desktop`, update the property `Exec` by the path to this godot project  (paths with spaces must be scaped with doble \\ \\)

	cp ./Godouse.desktop ~/.config/autostart/Godouse.desktop

# Development 

## Master submodule command

	git submodule update --init --recursive


## Create an android debug keystore

	mkdir -p /home/<your_user_name>/.local/share/godot/keystores && \
		keytool -genkeypair -alias androiddebugkey -keyalg RSA -keysize 2048 \
		-validity 10000 \
		-keystore /home/<your_user_name>/.local/share/godot/keystores/debug.keystore \
		-storepass android \
		-keypass android \
		-dname "CN=Android Debug,O=Android,C=US"


## Building gdextensions

### Android

Setup env variables for android gdextensions builds (`CLANG_PATH`, `CARGO_TARGET_{shoutTargetTriple}_LINKER`)

https://godot-rust.github.io/book/toolchain/export-android.html

### Building

use the tasks at [godouse-rust-gdextensions/.vscode/tasks.json](godouse-rust-gdextensions/.vscode/tasks.json) for building the gdextensions for godot

# Features
- Platforms: [windows,android]
- Remote cursor position controller
- Media buttons (play/pause,next track, previous track)
- Left/Right Click

# TODO
- Android safe area
- Add the application to the system tray, https://github.com/jmariner/traypp
- Support to other platforms
- Cursor sensibility
