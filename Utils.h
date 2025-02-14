#ifndef UTILS_H
#define UTILS_H
#include <QString>
#include <vector>
#include <PDFxTMDLib/Common/PartonUtils.h>


namespace Utils
{
QString CovertFlavorsVecToStr(const std::vector<int> &flavors);
QString CovertFlavorToString(PDFxTMD::PartonFlavor flavor);
QString ConvertOrderQCDToString(PDFxTMD::OrderQCD orderQCD);
};

#endif // UTILS_H
