#pragma once
#include <string>
#if defined(_WIN32)
#include "icon.hpp"
#include <Windows.h>
#elif defined(__linux__) && !defined(__ANDROID__)
#include <gtk/gtk.h>
#endif

namespace Tray
{
#if defined(__linux__) && !defined(__ANDROID__)
    class Image
    {
        GtkWidget *image;

      public:
        Image(GtkWidget *image);
        Image(const char *path);
        Image(const std::string &path);

        operator GtkWidget *();
    };
#elif defined(_WIN32)
    class Image
    {
        HBITMAP image;

      public:
        Image(HBITMAP image);
        Image(WORD resource);
        Image(const char *path);
        Image(const std::string &path);

        operator HBITMAP();
    };
#elif defined(__ANDROID__)
  class Image {

    public:
      Image(const char *path);
  };
#endif
} // namespace Tray