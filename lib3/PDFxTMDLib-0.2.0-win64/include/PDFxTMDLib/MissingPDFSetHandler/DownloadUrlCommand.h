#include "Common/ICommand.h"

namespace PDFxTMD
{
class DownloadUrlCommand : public ICommand
{
  public:
    bool execute(StandardTypeMap &context) override;
};
} // namespace PDFxTMD