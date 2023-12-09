generate_bindings:
	Godot_v4.2-stable_win64.exe --dump-extension-api --dump-gdextension-interface --headless --quit
	mv -f ./extension_api.json ./godot-cpp/gdextension/extension_api.json
	mv -f ./gdextension_interface.h ./godot-cpp/gdextension/gdextension_interface.h

build_gdextensions:
	scons platform=windows

build_gdextensions_release:
	scons platform=windows target=template_release