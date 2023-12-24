# GODOUSE
Remote mouse controller made with godot and c++ gdextensions

client (Android), server (windows)

![main](./.github/assets/screen-main.png)
![options](./.github/assets/screen-config.png)

![tray](./.github/assets/tray.png)

# Master submodule command

	git submodule update --init --recursive

# Building gdextensions

This repository contains some useful task defined at [Makefile](Makefile) and [.vscode/tasks.json](.vscode/tasks.json)

## Android
Just follow this:
https://docs.godotengine.org/en/4.2/tutorials/export/exporting_for_android.html

- [godouse-cpp-gdextensions/traypp](./godouse-cpp-gdextensions/traypp) is not included during the build process, a CPPDEFINES preprocessor named "\_\_EXCLUDE_TRAY_SYSTEM\_\_" is added in the scons build for android to not include that cpp part because it builds correctly but does not work on the device 🤷

## Windows
- Just follow this: https://docs.godotengine.org/en/stable/contributing/development/compiling/compiling_for_windows.html
- Have the Shell32.lib (it comes with the visual studio c++ installation)
- Have the User32.lib (it comes with the visual studio c++ installation)

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


## traypp

- Upstream: https://github.com/jmariner/traypp
- commit f876fdf6d2ac283f7a85fce14e3e3d538c0abbe6
- location: godouse-cpp-gdextensions\traypp

# Useful stuff
- Construction variables: https://scons.org/doc/0.96.90/HTML/scons-user/a3061.html
- CXX (CMAKE) location: C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe