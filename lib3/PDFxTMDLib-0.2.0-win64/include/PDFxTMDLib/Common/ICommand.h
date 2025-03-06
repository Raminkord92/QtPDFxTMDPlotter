#pragma once
#include "PDFxTMDLib/Common/KeyValueStore.h"
#include <map>
#include <memory>

namespace PDFxTMD
{
class ICommand
{
  public:
    virtual ~ICommand() = default;
    virtual bool execute(StandardTypeMap &context) = 0;
};
} // namespace PDFxTMD
