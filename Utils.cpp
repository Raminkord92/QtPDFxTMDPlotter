#include "Utils.h"
#include <QStringList>
namespace Utils {

QString CovertFlavorsVecToStr(const std::vector<int> &flavors)
{
    QStringList flavorsStringList;
    for (auto flavor : flavors) {
        flavorsStringList << CovertFlavorToString(static_cast<PDFxTMD::PartonFlavor>(flavor));
    }
    return flavorsStringList.join(", ");
}

QString CovertFlavorToString(PDFxTMD::PartonFlavor flavor)
{
    switch(flavor)
    {
    case PDFxTMD::u:
        return "up";
    case PDFxTMD::d:
        return "down";
    case PDFxTMD::s:
        return "strange";
    case PDFxTMD::c:
        return "charm";
    case PDFxTMD::b:
        return "bottom";
    case PDFxTMD::ubar:
        return "anti-up";
    case PDFxTMD::dbar:
        return "anti-down";
    case PDFxTMD::sbar:
        return "anti-strange";
    case PDFxTMD::cbar:
        return "anti-charm";
    case PDFxTMD::bbar:
        return "anti-bottom";
    case PDFxTMD::g:
    case PDFxTMD::gNS:
        return "gluon";
    case PDFxTMD::photon:
        return "photon";
    default:
        return "Unkown";
    }
}

QString ConvertOrderQCDToString(PDFxTMD::OrderQCD orderQCD)
{
    switch (orderQCD)
    {
    case PDFxTMD::OrderQCD::LO:
        return "LO";
    case PDFxTMD::OrderQCD::NLO:
        return "NLO";
    case PDFxTMD::OrderQCD::N2LO:
        return "N2LO";
    case PDFxTMD::OrderQCD::N3LO:
        return "N3LO";
    }
    return "Unkown";
}

QVector<double> BinGeneratorInLogSpace(double xMin, double xMax, int n)
{
    if (xMin <= 0 || xMax <= 0 || n <= 0) {
        throw std::invalid_argument("xMin, xMax must be greater than 0 and n must be positive.");
    }

    // Compute the logarithms.
    double logMin = std::log(xMin);
    double logMax = std::log(xMax);

    QVector<double> result;
    result.reserve(n);

    // Compute n evenly spaced points in the logarithmic domain, then exponentiate.
    for (int i = 0; i < n; ++i) {
        double t = static_cast<double>(i) / (n - 1);
        double point = std::exp(logMin + t * (logMax - logMin));
        result.push_back(point);
    }

    return result;

}

int ConvertStringToFlavor(const QString &flavor)
{
    if (flavor == "up")
        return PDFxTMD::u;
    if (flavor == "down")
        return PDFxTMD::d;
    if (flavor == "strange")
        return PDFxTMD::s;
    if (flavor == "charm")
        return PDFxTMD::c;
    if (flavor == "bottom")
        return PDFxTMD::b;
    if (flavor == "anti-up")
        return PDFxTMD::ubar;
    if (flavor == "anti-down")
        return PDFxTMD::dbar;
    if (flavor == "anti-strange")
        return PDFxTMD::sbar;
    if (flavor == "anti-charm")
        return PDFxTMD::cbar;
    if (flavor == "anti-bottom")
        return PDFxTMD::bbar;
    if (flavor == "gluon")
        return PDFxTMD::g;
    if (flavor == "photon")
        return PDFxTMD::photon;

    return -1;
}

QString ConvertPDFSetTypeToString(PDFSetType pdfSetType)
{
    if (pdfSetType == PDFSetType::CPDF)
        return "cPDF";
    else if (pdfSetType == PDFSetType::TMD)
        return "TMD";
    return "Unkown";
}

}

