#pragma once
#if defined(__ANDROID__)
#include <core/traybase.hpp>
#include <map>

namespace Tray {
    class Tray : public BaseTray {
      public:
        ~Tray();
        Tray();
        Tray(std::string identifier, Icon icon);
        template <typename... T> Tray(std::string identifier, Icon icon, const T &...entries) : Tray(identifier, icon) {
            addEntries(entries...);
        }

        void setTooltip(std::string tooltip) override;
        void setIcon(Icon icon) override;
        void run() override;
        void pump() override;
        void exit() override;
        void update() override;
    };
}
#endif