#pragma once
#include <string>

namespace PDFxTMD
{
class EnvUtils
{
  public:
    static bool AddPathToEnvironment(const std::string &newPath);
};
} // namespace PDFxTMD