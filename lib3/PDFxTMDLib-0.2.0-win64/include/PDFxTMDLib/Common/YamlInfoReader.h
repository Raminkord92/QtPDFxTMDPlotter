#pragma once
#include <iostream>

#include <PDFxTMDLib/Common/ConfigWrapper.h>

#define DEFULT_NUM_FLAVORS 5
namespace PDFxTMD
{
struct YamlStandardPDFInfo
{
    OrderQCD orderQCD;
    std::string Format;
    double XMin = 0;
    double XMax = 0;
    double QMin = 0;
    double QMax = 0;
    int NumMembers = 0;
    std::vector<int> Flvors;
};

struct YamlStandardTMDInfo : YamlStandardPDFInfo
{
    double KtMin = 0;
    double KtMax = 0;
    std::string TMDScheme = "";
};
struct YamlImpelemntationInfo
{
    std::string reader = "";
    std::string interpolator = "";
    std::string extrapolator = "";
};
enum class AlphasType
{
    analytic,
    ipol
};
enum class AlphasFlavorScheme
{
    fixed,
    variable
};

struct YamlCouplingInfo
{
    AlphasType alphasOrder = AlphasType::analytic;
    OrderQCD alphsOrder = OrderQCD::NLO;
    std::vector<double> mu_vec;
    std::vector<double> alphas_vec;
    double alphasLambda3 = -1;
    double alphasLambda4 = -1;
    double alphasLambda5 = -1;
    double MZ = 91.1876;
    std::map<PartonFlavor, double> quarkThreshhold;
    std::map<PartonFlavor, double> quarkMasses;
    AlphasFlavorScheme flavorScheme = AlphasFlavorScheme::variable;
    int numFlavors = DEFULT_NUM_FLAVORS;
    AlphasType alphaCalcMethod = AlphasType::analytic;
};
std::pair<std::optional<YamlImpelemntationInfo>, ErrorType> YamlImpelemntationInfoReader(
    const std::string &yamlInfoPath);
template <typename T>
std::enable_if_t<std::is_same_v<T, YamlStandardPDFInfo> || std::is_same_v<T, YamlStandardTMDInfo>,
                 std::pair<std::optional<YamlStandardTMDInfo>, ErrorType>>
YamlStandardPDFInfoReader(const std::string &yamlInfoPath)
{
    ErrorType errTot = ErrorType::None;
    ConfigWrapper ConfigWrapper;
    YamlStandardTMDInfo output;
    if (!ConfigWrapper.loadFromFile(yamlInfoPath, ConfigWrapper::Format::YAML))
    {
        return {std::nullopt, ErrorType::FILE_NOT_FOUND};
    }
    //////OrderQCD
    auto [orderQCD, errorOrderQCD] = ConfigWrapper.get<int>("OrderQCD");
    if (errorOrderQCD != ErrorType::None)
    {
        std::cout << "[PDFxTMD][YamlInfoReader] OrderQCD not "
                     "found in yaml file"
                  << std::endl;
        return {std::nullopt, errorOrderQCD};
    }
    output.orderQCD = static_cast<OrderQCD>(*orderQCD);
    //////Format
    auto [format, errorFormat] = ConfigWrapper.get<std::string>("Format");
    if (errorFormat != ErrorType::None)
    {
        std::cout << "[PDFxTMD][YamlInfoReader] Format is not "
                     "found in yaml config file"
                  << std::endl;
        return {std::nullopt, errorFormat};
    }
    output.Format = *format;
    //////NumMembers
    auto [NumMembers, errorNumMembers] = ConfigWrapper.get<int>("NumMembers");
    if (errorNumMembers != ErrorType::None)
    {
        std::cout << "[PDFxTMD][YamlInfoReader] NumMembers is not "
                     "found in yaml config file"
                  << std::endl;
        return {std::nullopt, errorNumMembers};
    }
    output.NumMembers = *NumMembers;
    //////NumMembers
    auto [Flavors, errorFlavors] = ConfigWrapper.get<std::vector<int>>("Flavors");
    if (errorFlavors != ErrorType::None)
    {
        std::cout << "[PDFxTMD][YamlInfoReader] Flavors is not "
                     "found in yaml config file"
                  << std::endl;
        return {std::nullopt, errorFlavors};
    }
    output.Flvors = *Flavors;
    //////xMin
    auto [XMin, errorXMin] = ConfigWrapper.get<double>("XMin");
    if (errorXMin != ErrorType::None)
    {
        std::cout << "[PDFxTMD][YamlInfoReader] XMin is not found "
                     "in yaml config file"
                  << std::endl;
        return {std::nullopt, errorXMin};
    }
    output.XMin = *XMin;
    //////XMax
    auto [XMax, errorXMax] = ConfigWrapper.get<double>("XMax");
    if (errorXMax != ErrorType::None)
    {
        std::cout << "[PDFxTMD][YamlInfoReader] XMax is not found "
                     "in yaml config file"
                  << std::endl;
        return {std::nullopt, errorXMin};
    }
    output.XMax = *XMax;

    //////QMin
    auto [QMin, errorQMin] = ConfigWrapper.get<double>("QMin");
    if (errorQMin != ErrorType::None)
    {
        std::cout << "[PDFxTMD][YamlInfoReader] QMin is not found "
                     "in yaml config file"
                  << std::endl;
        return {std::nullopt, errorQMin};
    }
    output.QMin = *QMin;
    //////QMax
    auto [QMax, errorQMax] = ConfigWrapper.get<double>("QMax");
    if (errorQMax != ErrorType::None)
    {
        std::cout << "[PDFxTMD][YamlInfoReader] QMax is not found "
                     "in yaml config file"
                  << std::endl;
        return {std::nullopt, errorQMax};
    }
    output.QMax = *QMax;
    if constexpr (std::is_same_v<T, YamlStandardTMDInfo>)
    {
        auto [TMDScheme, errorTMDScheme] = ConfigWrapper.get<std::string>("TMDScheme");
        if (errorTMDScheme != ErrorType::None)
        {
            std::cout << "[PDFxTMD][YamlInfoReader] Format is not "
                         "found in yaml config file"
                      << std::endl;
            errTot = errorTMDScheme;
            output.TMDScheme = "";
        }
        else
            output.TMDScheme = *TMDScheme;
        //////KtMin
        auto [KtMin, errorKtMin] = ConfigWrapper.get<double>("KtMin");
        if (errorKtMin != ErrorType::None)
        {
            std::cout << "[PDFxTMD][YamlInfoReader] KtMin is not "
                         "found in yaml config file"
                      << std::endl;
            errTot = errorKtMin;
            output.KtMin = -1;
        }
        else
            output.KtMin = *KtMin;
        //////KtMax
        auto [KtMax, errorKtMax] = ConfigWrapper.get<double>("KtMax");
        if (errorKtMax != ErrorType::None)
        {
            std::cout << "[PDFxTMD][YamlInfoReader] KtMax is not "
                         "found in yaml config file"
                      << std::endl;
            errTot = errorKtMax;
            output.KtMax = -1;
        }
        else
            output.KtMax = *KtMax;

    }

    return {output, errTot};
}
std::pair<std::optional<YamlCouplingInfo>, ErrorType> YamlCouplingInfoReader(
    const std::string &yamlInfoPath);
} // namespace PDFxTMD
