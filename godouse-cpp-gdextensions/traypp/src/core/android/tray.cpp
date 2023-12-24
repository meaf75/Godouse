#if defined(__ANDROID__)
#include <core/android/tray.hpp>

Tray::Tray::Tray(std::string identifier, Icon icon) : BaseTray(std::move(identifier), std::move(icon)){}

void Tray::Tray::exit(){}

void Tray::Tray::update(){}

void Tray::Tray::setTooltip(std::string tooltip){}

void Tray::Tray::setIcon(Icon icon){}

void Tray::Tray::run(){}

void Tray::Tray::pump(){}

#endif