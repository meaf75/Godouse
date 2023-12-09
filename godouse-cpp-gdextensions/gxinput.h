#ifndef GXINPUT_H
#define GXINPUT_H

#include <godot_cpp/classes/node.hpp>
#include <XInputSimulator/xinputsimulator.h>

namespace godot
{

	class GXInput : public Node {
		GDCLASS(GXInput, Node)

		// private:
		// 	static XInputSimulator* supreme_input;

		protected:
			static void _bind_methods();

		public:
			enum {
				GX_MOUSE_BUTTON_LEFT = XInputSimulator::LEFT_MOUSE_BUTTON,
				GX_MOUSE_BUTTON_RIGHT = XInputSimulator::RIGHT_MOUSE_BUTTON,
				GX_MOUSE_BUTTON_MIDDLE = XInputSimulator::MIDDLE_MOUSE_BUTTON,

				GX_VIRTUAL_KEY_PLAY_PAUSE = XInputSimulator::VIRTUAL_KEY_MEDIA_PLAY_PAUSE,
				GX_VIRTUAL_KEY_NEXT_TRACK = XInputSimulator::VIRTUAL_KEY_MEDIA_NEXT_TRACK,
				GX_VIRTUAL_KEY_PREVIOUS_TRACK = XInputSimulator::VIRTUAL_KEY_MEDIA_PREVIOUS_TRACK,
			};

			GXInput();
			~GXInput();

			/// @brief henlux panita .com
			static void say_hello();
			static void testux();
			
			static void simulate_click(int button);
			static void simulate_virtual_key_click(int key);
			static Vector2 get_cursor_position();
			static void set_cursor_position(Vector2 pos);
			
			void say_hello_local();
	};

}

#endif