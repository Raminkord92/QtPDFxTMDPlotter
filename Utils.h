#ifndef UTILS_H
#define UTILS_H
#include <QString>
#include <vector>
#include <PDFxTMDLib/Common/PartonUtils.h>
#include <QVector>

namespace Utils
{
QString CovertFlavorsVecToStr(const std::vector<int> &flavors);
QString CovertFlavorToString(PDFxTMD::PartonFlavor flavor);
int ConvertStringToFlavor(const QString& flavor);
QString ConvertOrderQCDToString(PDFxTMD::OrderQCD orderQCD);
QVector<double> BinGeneratorInLogSpace(double xMin, double xMax, int n);
};

#endif // UTILS_H
