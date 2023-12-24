#if defined(__linux__) && !defined(__ANDROID__)
#include <core/image.hpp>

Tray::Image::Image(GtkWidget *image) : image(image) {}
Tray::Image::Image(const char *path) : Image(std::string(path)) {}
Tray::Image::Image(const std::string &path) : image(gtk_image_new_from_file(path.c_str())) {}

Tray::Image::operator GtkWidget *()
{
    return image;
}
#endif