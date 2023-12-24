#pragma once
#include <core/entry.hpp>
#include <functional>

namespace Tray
{
    class Toggle : public TrayEntry
    {
        bool toggled;
        std::function<void(bool)> callback;

      public:
        ~Toggle() override = default;
        Toggle(
            std::string text, bool state, std::function<void(bool)> callback = [](bool /**/) {});

        void onToggled();
        void setToggledNoCallback(bool state);
        bool isToggled() const;
    };
} // namespace Tray