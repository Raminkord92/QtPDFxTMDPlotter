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
}

}

