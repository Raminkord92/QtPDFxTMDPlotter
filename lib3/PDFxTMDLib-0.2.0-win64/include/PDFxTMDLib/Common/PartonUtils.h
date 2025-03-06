#pragma once
#include <exception>
#include <filesystem>
#include <optional>
#include <sstream>
#include <string>
#include <vector>

#define FOLDER_SEP "/"

#if defined(_WIN32)
#define PDF_X_TMD_REGISTRY_PATH "Software\\PDFxTMD"
#endif
#define STD_PDF_INFO_EXTENSION ".info"
#define STD_PDF_DATA_EXTENSION ".dat"
#define ENV_PATH_VARIABLE "PDFxTMD_PATH"

namespace PDFxTMD
{
// https://www.modernescpp.com/index.php/from-variadic-templates-to-fold-expressions/
template <typename... Args> bool all(Args... args)
{
    return (... && args);
}
enum class PhaseSpaceComponent
{
    X,
    Kt2,
    Q2
};

enum class ErrorType
{
    None,                    // No error
    CONFIG_KeyNotFound,      // The key does not exist
    CONFIG_ConversionFailed, // Conversion to the desired type
                             // failed,
    FILE_NOT_FOUND = 10,
};
enum class OrderQCD
{
    LO,
    NLO,
    N2LO,
    N3LO
};
enum PartonFlavor
{
    tbar = -6,
    bbar = -5,
    cbar = -4,
    sbar = -3,
    dbar = -1,
    ubar = -2,
    gNS = 0, // non-standard g
    u = 2,
    d = 1,
    s = 3,
    c = 4,
    b = 5,
    t = 6,
    g = 21,
    photon = 22,
    // Non stadard ew partciles
    z0 = 100,
    wplus,
    wminus,
    higgs
};

std::vector<std::string> splitPaths(const std::string &paths);
bool hasWriteAccess(const std::string &path);
double _extrapolateLinear(double x, double xl, double xh, double yl, double yh);
std::string StandardPDFNaming(const std::string &pdfName, int set);
std::vector<std::string> GetEnviormentalVariablePaths(
    const std::string &envVariable = ENV_PATH_VARIABLE, char delimiter = ':');
std::vector<std::string> split(const std::string &str, char delimiter);
/// Format an integer @a val as a zero-padded string of length
/// @a nchars
std::string to_str_zeropad(int val, size_t nchars = 4);
std::pair<std::optional<std::string>, ErrorType> StandardInfoFilePath(
    const std::string &pdfSetName);
std::pair<std::optional<std::string>, ErrorType> StandardPDFSetPath(const std::string &pdfSetName,
                                                                    int set);
//taken from the lhapdf
size_t indexbelow(double value, const std::vector<double> &knots);

} // namespace PDFxTMD
