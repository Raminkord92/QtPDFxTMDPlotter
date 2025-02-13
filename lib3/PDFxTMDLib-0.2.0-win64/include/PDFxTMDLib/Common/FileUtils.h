#pragma once
#include <filesystem>
#include <fstream>
#include <string>
#include <system_error>

namespace PDFxTMD
{
class FileUtils
{
  public:
    static bool HasUserAccess(const std::string &path);
    static double FreeSize(const std::string &path);
    static bool Exists(const std::string &path);
    static std::string ParentDir(const std::string &path);
    static bool CreateDirs(const std::string &path);
};
} // namespace PDFxTMD