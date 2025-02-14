#pragma once
#include <PDFxTMDLib/Common/ICommand.h>
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
    //filling context means the user want to handle downloading automatically
    bool Start(const std::string &pdfName, StandardTypeMap* context = nullptr);

  private:
    std::vector<std::shared_ptr<ICommand>> m_commands;
    StandardTypeMap m_context;
};
} // namespace PDFxTMD
