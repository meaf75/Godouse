#include "gxtraypp.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

// Tray::Tray GXTraypp::tray;
// tray_n::Tray tray("My Tray", "icon.ico");

void GXTraypp::_bind_methods() {
    ClassDB::bind_method(D_METHOD("add_to_system_tray", "name", "icon_path"), &GXTraypp::add_to_system_tray);
    ClassDB::bind_method(D_METHOD("stop_system_tray"), &GXTraypp::stop_system_tray);

    ADD_SIGNAL(MethodInfo("on_receive_exit_request"));
}

GXTraypp::GXTraypp() {
    // Initialize any variables here.
}

GXTraypp::~GXTraypp() {
    // Add your cleanup here.
}

void GXTraypp::_process(double delta) {
}

void GXTraypp::add_to_system_tray(String name, String icon_path){
    #if !defined(__EXCLUDE_TRAY_SYSTEM__)
    tray_n::Tray _tray(name.utf8().get_data(), icon_path.utf8().get_data());
    tray = _tray;
    
    _tray.addEntry(tray_n::Button("Exit", [&]{
        tray.exit();
        auto tree = get_tree();
        call_deferred("emit_signal","on_receive_exit_request");
    }));

    _tray.run();
    #endif
}

void GXTraypp::stop_system_tray(){
    #if !defined(__EXCLUDE_TRAY_SYSTEM__)
    UtilityFunctions::print("Stopping tray");
    tray.exit();
    #endif
}