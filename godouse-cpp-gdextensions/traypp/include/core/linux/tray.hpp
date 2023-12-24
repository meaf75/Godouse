#pragma once
#if defined(__linux__) && !defined(__ANDROID__)
#include <core/traybase.hpp>
#include <libappindicator/app-indicator.h>

namespace Tray
{
    class Tray : public BaseTray
    {
        AppIndicator *appIndicator;
        static void callback(GtkWidget *, gpointer);
        std::vector<std::pair<GtkContainer *, GtkWidget *>> imageWidgets;
        static GtkMenuShell *construct(const std::vector<std::shared_ptr<TrayEntry>> &, Tray *parent);

      public:
        Tray(std::string identifier, Icon icon);
        template <typename... T> Tray(std::string identifier, Icon icon, const T &...entries) : Tray(identifier, icon)
        {
            addEntries(entries...);
        }

        void setTooltip(std::string tooltip) override;
        void setIcon(Icon icon) override;
        void run() override;
        void pump() override;
        void exit() override;
        void update() override;
    };
} // namespace Tray
#endif