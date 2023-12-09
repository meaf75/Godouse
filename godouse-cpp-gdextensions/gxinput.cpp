#include "gxinput.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

#include <XInputSimulator/xinputsimulator.h>
// #include <MeafTestux/meaftestux.h>

using namespace godot;
// using namespace henlux;

void GXInput::_bind_methods() {
	// ClassDB::bind_method(D_METHOD("get_amplitude"), &GDExample::get_amplitude);
    // ClassDB::bind_method(D_METHOD("set_amplitude", "p_amplitude"), &GDExample::set_amplitude);
    ClassDB::bind_method(D_METHOD("say_hello_2"), &GXInput::say_hello_local);
    ClassDB::bind_static_method(GXInput::get_class_static(), D_METHOD("say_hello"), &GXInput::say_hello);
    
    // ClassDB::bind_method(D_METHOD("henlux"), &GXInput::testux);
    ClassDB::bind_static_method(GXInput::get_class_static(), D_METHOD("testux_static"), &GXInput::testux);
    ClassDB::bind_static_method(GXInput::get_class_static(), D_METHOD("simulate_click", "button"), &GXInput::simulate_click);
    ClassDB::bind_static_method(GXInput::get_class_static(), D_METHOD("get_cursor_position"), &GXInput::get_cursor_position);
    ClassDB::bind_static_method(GXInput::get_class_static(), D_METHOD("set_cursor_position","pos"), &GXInput::set_cursor_position);
    ClassDB::bind_static_method(GXInput::get_class_static(), D_METHOD("simulate_virtual_key_click","key"), &GXInput::simulate_virtual_key_click);
    
    BIND_CONSTANT(GX_MOUSE_BUTTON_LEFT);
    BIND_CONSTANT(GX_MOUSE_BUTTON_RIGHT);
    BIND_CONSTANT(GX_MOUSE_BUTTON_MIDDLE);

    BIND_CONSTANT(GX_VIRTUAL_KEY_PLAY_PAUSE);
    BIND_CONSTANT(GX_VIRTUAL_KEY_NEXT_TRACK);
    BIND_CONSTANT(GX_VIRTUAL_KEY_PREVIOUS_TRACK);
}

GXInput::GXInput() {
    // Initialize any variables here.
}

GXInput::~GXInput() {
    // Add your cleanup here.
}

// henlux
void GXInput::say_hello() {    
    UtilityFunctions::print("henlux pana from static v2");
}

void GXInput::say_hello_local() {
    UtilityFunctions::print("henlux pana from local v2");
}

void GXInput::testux() {
    UtilityFunctions::print("running testux");

    // if (&supreme_input == NULL){
    //     UtilityFunctions::print("supreme input is null, getting instance");
    //     XInputSimulator& sim = XInputSimulator::getInstance();
    //     supreme_input=&sim;
    // }
    
    // supreme_input->mouseDown(XIS::RIGHT_MOUSE_BUTTON);

    XInputSimulator& sim = XInputSimulator::getInstance();
    sim.mouseDown(XIS::RIGHT_MOUSE_BUTTON);

    UtilityFunctions::print("clicked?");
}

void GXInput::simulate_click(int button) {
    XInputSimulator& sim = XInputSimulator::getInstance();
    sim.mouseClick(button);
}

void GXInput::simulate_virtual_key_click(int button) {
    XInputSimulator& sim = XInputSimulator::getInstance();
    sim.keyClick(button);
}

Vector2 GXInput::get_cursor_position() {
    XInputSimulator& sim = XInputSimulator::getInstance();
    auto pos = sim.getCursorPosition();    
    return Vector2(std::get<0>(pos),std::get<1>(pos));
}

void GXInput::set_cursor_position(Vector2 pos) {
    XInputSimulator& sim = XInputSimulator::getInstance();
    sim.mouseMoveTo(pos.x,pos.y);
}