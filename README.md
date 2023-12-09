# GODOUSE
Remote mouse controller made with godot and c++ gdextensions

client (Android), server (windows)

![main](./.github/assets/screen-main.png)
![main](./.github/assets/screen-config.png)


# Master submodule command

	git submodule update --init --recursive

# Building gdextensions

This repository contains some useful task defined at [Makefile](Makefile) and [.vscode/tasks.json](.vscode/tasks.json)

## Android
Just follow this:
https://docs.godotengine.org/en/4.2/tutorials/export/exporting_for_android.html

## Windows
Just follow this:
https://docs.godotengine.org/en/stable/contributing/development/compiling/compiling_for_windows.html

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

# Third party

## XInputSimulator

- Upstream: https://github.com/pythoneer/XInputSimulator
- XInputSimulator folder without root content
- commit 19d5be6dfc4cda837f2395713fdd6475ace32314
- location: godouse-cpp-gdextensions\XInputSimulator

# Useful stuff
- Construction variables: https://scons.org/doc/0.96.90/HTML/scons-user/a3061.html
- CXX (CMAKE) location: C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe