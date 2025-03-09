#include "PDFInfo.h"
#include "Utils.h"
using namespace PDFxTMD;

// Constructor
PDFObjectInfo::PDFObjectInfo(QObject *parent) : QObject(parent) {}

// Find the parton flavor based on the current index
PartonFlavor PDFObjectInfo::FindPartonFlavor() {
    if (m_partonFlavorIndex < 0 || m_partonFlavorIndex >= m_partonFlavors.size()) {
        return static_cast<PartonFlavor>(-1); // Invalid flavor
    }
    QString partonFlavor_ = m_partonFlavors.at(m_partonFlavorIndex);
    return static_cast<PartonFlavor>(Utils::ConvertStringToFlavor(partonFlavor_));
}

// Setter functions with signal emissions
void PDFObjectInfo::setPdfSet(const QString &value) {
    if (m_pdfSet != value) {
        m_pdfSet = value;
        m_xVals.clear();
        m_yVals.clear();
        emit pdfSetChanged();
    }
}

void PDFObjectInfo::setDisplayText(const QString &value) {
    if (m_displayText != value) {
        m_displayText = value;
        emit displayTextChanged();
    }
}

void PDFObjectInfo::setColor(const QColor &value) {
    if (m_color != value) {
        m_color = value;
        emit colorChanged();
    }
}

void PDFObjectInfo::setLineStyleIndex(int value) {
    if (m_lineStyleIndex != value) {
        m_lineStyleIndex = value;
        emit lineStyleIndexChanged();
    }
}

void PDFObjectInfo::setPartonFlavorIndex(int value) {
    if (m_partonFlavorIndex != value) {
        m_partonFlavorIndex = value;
        m_xVals.clear();
        m_yVals.clear();
        emit partonFlavorIndexChanged();
    }
}

void PDFObjectInfo::setPartonFlavors(const QStringList &value) {
    if (m_partonFlavors != value) {
        m_partonFlavors = value;
        m_xVals.clear();
        m_yVals.clear();
        emit partonFlavorsChanged();
    }
}

void PDFObjectInfo::setPlotTypeIndex(int value) {
    if (m_plotTypeIndex != value) {
        m_plotTypeIndex = value;
        m_xVals.clear();
        m_yVals.clear();
        emit plotTypeIndexChanged();
    }
}

void PDFObjectInfo::setXVals(const QVector<double> &value) {
    if (m_xVals != value) {
        m_xVals = value;
        emit xValsChanged();
    }
}

void PDFObjectInfo::setYVals(const QVector<double> &value) {
    if (m_yVals != value) {
        m_yVals = value;
        emit yValsChanged();
    }
}

void PDFObjectInfo::setCurrentTabIndex(int value) {
    if (m_currentTabIndex != value) {
        m_currentTabIndex = value;
        emit currentTabIndexChanged();
    }
}

void PDFObjectInfo::setCurrentXVal(double xVal)
{
    if (m_currentXVal != xVal)
    {
        m_currentXVal = xVal;
        m_xVals.clear();
        m_yVals.clear();
        emit currentXValChanged();
    }
}

void PDFObjectInfo::setCurrentMuVal(double muVal)
{
    if (m_currentMuVal != muVal)
    {
        m_currentMuVal = muVal;
        m_xVals.clear();
        m_yVals.clear();
        emit currentMuValChanged();
    }
}

void PDFObjectInfo::setCurrentKtVal(double ktVal)
{
    if (m_currentKtVal != ktVal)
    {
        m_currentKtVal = ktVal;
        m_xVals.clear();
        m_yVals.clear();
        emit currentKtValChanged();
    }
}

void PDFObjectInfo::setSelectePDFType(const QString &selectedPDFType)
{
    if (m_selectedPDFType != selectedPDFType) {
        m_selectedPDFType = selectedPDFType;
        m_xVals.clear();
        m_yVals.clear();
        emit selectedPDFSetChanged();
    }
}

void PDFObjectInfo::setXMin(double xMin)
{
    m_xMin = xMin;
    m_xVals.clear();
    m_yVals.clear();
    emit currentXMinChanged();
}

void PDFObjectInfo::setXMax(double xMax)
{
    m_xMax = xMax;
    m_xVals.clear();
    m_yVals.clear();
    emit currentXMaxChanged();
}

void PDFObjectInfo::setMuMin(double muMin)
{
    m_muMin = muMin;
    m_xVals.clear();
    m_yVals.clear();
    emit currentMuMinChanged();
}

void PDFObjectInfo::setMuMax(double muMax)
{
    m_muMax = muMax;
    m_xVals.clear();
    m_yVals.clear();
    emit currentMuMaxChanged();
}

void PDFObjectInfo::setKtMin(double ktMin)
{
    m_ktMin = ktMin;
    m_xVals.clear();
    m_yVals.clear();
    emit currentKtMinChanged();
}

void PDFObjectInfo::setKtMax(double ktMax)
{
    m_ktMax = ktMax;
    m_xVals.clear();
    m_yVals.clear();
    emit currentKtMaxChanged();
}

void PDFObjectInfo::setId(int id)
{
    m_id = id;
}
