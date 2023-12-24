#if defined(__linux__) && !defined(__ANDROID__)
#include <core/icon.hpp>

Tray::Icon::Icon(std::string path) : iconPath(std::move(path)) {}
Tray::Icon::Icon(const char *path) : iconPath(path) {}
Tray::Icon::operator const char *()
{
    return iconPath.c_str();
}

#endif