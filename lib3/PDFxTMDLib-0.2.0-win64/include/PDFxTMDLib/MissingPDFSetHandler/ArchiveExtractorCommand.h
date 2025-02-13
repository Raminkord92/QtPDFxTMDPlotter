#pragma once
#include "Common/ICommand.h"
#include <archive.h>
#include <archive_entry.h>
#include <cstring>
#include <iostream>
#include <sys/stat.h>

namespace PDFxTMD
{
class ArchiveExtractorCommand : public ICommand
{
  public:
    bool execute(StandardTypeMap &context) override;
};
} // namespace PDFxTMD
