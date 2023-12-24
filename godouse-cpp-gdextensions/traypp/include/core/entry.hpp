#pragma once
#include <string>

namespace Tray
{
    class BaseTray;
    class TrayEntry
    {
      protected:
        std::string text;
        bool disabled = false;
        bool defaultEntry = false;
        BaseTray *parent = nullptr;

      public:
        TrayEntry(std::string text);
        virtual ~TrayEntry() = default;

        BaseTray *getParent();
        void setParent(BaseTray *);

        std::string getText();
        void setText(std::string);

        void setDisabled(bool);
        bool isDisabled() const;

        void setDefault(bool state = true);
        bool isDefault() const;
    };
} // namespace Tray