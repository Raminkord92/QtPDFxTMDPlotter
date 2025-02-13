#include "Common/ICommand.h"
#include <iostream>
#include <memory>
#include <string>
#include <vector>

namespace PDFxTMD
{

class PDFSetDownloadHandler
{
  public:
    PDFSetDownloadHandler();
    bool Start(const std::string &pdfName);

  private:
    std::vector<std::shared_ptr<ICommand>> m_commands;
    StandardTypeMap m_context;
};
} // namespace PDFxTMD