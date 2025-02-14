#pragma once
#include <PDFxTMDLib/Common/ICommand.h>

namespace PDFxTMD
{
class RepoSelectionCommand : public ICommand
{
  public:
    static bool CheckUrl(const std::string &url, StandardTypeMap &context);
    static std::string normalizePDFSetName(const std::string &pdfSet);
    bool execute(StandardTypeMap &context) override;
};
} // namespace PDFxTMD
