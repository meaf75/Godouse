#ifndef GXTRAYPP_H
#define GXTRAYPP_H

#include <godot_cpp/classes/node.hpp>

#if !defined(__EXCLUDE_TRAY_SYSTEM__)
#include <traypp/include/tray.hpp>
#endif


namespace godot
{

#if !defined(__EXCLUDE_TRAY_SYSTEM__)
	namespace tray_n = Tray;
#endif

	class GXTraypp : public Node {
		GDCLASS(GXTraypp, Node)

		protected:
			static void _bind_methods();

		public:
			GXTraypp();
			~GXTraypp();
			
			#if !defined(__EXCLUDE_TRAY_SYSTEM__)
			tray_n::Tray tray = tray_n::Tray();
			#endif

			void _process(double delta) override;
			
			void add_to_system_tray(String name, String icon_path);
			void stop_system_tray();
	};
}

#endif