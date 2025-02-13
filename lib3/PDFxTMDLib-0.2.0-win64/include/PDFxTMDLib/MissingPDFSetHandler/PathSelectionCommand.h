#pragma once
#include "Common/ICommand.h"
#include <string>

namespace PDFxTMD
{
class pathSelectionCommnand : public ICommand
{
  public:
    bool execute(StandardTypeMap &context) override;
};
} // namespace PDFxTMD
