#include "Common/ICommand.h"

namespace PDFxTMD
{
class RepoSelectionCommand : public ICommand
{
  public:
    bool execute(StandardTypeMap &context) override;
};
} // namespace PDFxTMD
