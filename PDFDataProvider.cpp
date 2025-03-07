#include "pdfdataprovider.h"
#include <PDFxTMDLib/Factory.h>
#include "Utils.h"
#include <QDebug>
#include <QQmlEngine>
#include <limits>

using namespace PDFxTMD;

// Static member initialization
PDFDataProvider* PDFDataProvider::s_instance = nullptr;

// Constructor
PDFDataProvider::PDFDataProvider(QObject *parent) : QObject(parent) {
    if (s_instance) {
        qWarning("PDFDataProvider: Singleton already exists!");
    }
    s_instance = this;
}

// Destructor
PDFDataProvider::~PDFDataProvider() {
    for (auto &list : m_pdfObjectInfos) {
        qDeleteAll(list);
    }
}



QList<PDFObjectInfo *> PDFDataProvider::getPDFData(TabIndex tabIndex)
{
    QList<PDFObjectInfo*> result;

    if (m_pdfObjectInfos.contains(tabIndex)) {
        int plotType = getPlotTypeOfTab(tabIndex);

        foreach (auto pdfObjectInfo_,  m_pdfObjectInfos[tabIndex])
        {
            QVector<double> xVals_, yVals_;

            PartonFlavor flavor_ = pdfObjectInfo_->FindPartonFlavor();
            if (flavor_ == static_cast<PartonFlavor>(-1)) {
                break;
            }
            double xMin_ = 0;
            double xMax_ = 0;
            if (plotType == PlotTypeIndex::X)
            {
                xMin_ = pdfObjectInfo_->xMin();
                xMax_ = pdfObjectInfo_->xMax();
            }
            else if (plotType == PlotTypeIndex::Mu2)
            {
                xMin_ = pdfObjectInfo_->muMin();
                xMax_ = pdfObjectInfo_->muMax();
                qDebug() << "plotType mu2 " << xMin_<< "--" << xMax_;
            }
            else if (plotType == PlotTypeIndex::Kt2)
            {
                xMin_ = pdfObjectInfo_->ktMin();
                xMax_ = pdfObjectInfo_->ktMax();
                qDebug() << "plotType kt2 " << xMin_<< "--" << xMax_;
            }
            auto bins_ = Utils::BinGeneratorInLogSpace(xMin_, xMax_, 200);
            std::string pdfSetName = pdfObjectInfo_->pdfSet().toStdString();
            QString selectedPDFType = getPDFTypeOfTab(tabIndex);
            if (selectedPDFType == "cPDF")
            {
                GenericCPDFFactory cPDFFfactory;
                auto cPDF_ = cPDFFfactory.mkCPDF(pdfSetName, 0);
                xVals_.reserve(bins_.size());
                yVals_.reserve(bins_.size());
                foreach (double bin_, bins_) {
                    xVals_.push_back(bin_);
                    if (pdfObjectInfo_->plotTypeIndex() == PlotTypeIndex::X) {
                        yVals_.push_back(cPDF_.pdf(flavor_, bin_, pdfObjectInfo_->currentMuVal() * pdfObjectInfo_->currentMuVal()));
                    } else if (pdfObjectInfo_->plotTypeIndex() == PlotTypeIndex::Mu2) {
                        double pdfval_ = cPDF_.pdf(flavor_, pdfObjectInfo_->currentXVal(), bin_ * bin_);
                        yVals_.push_back(pdfval_);
                    }
                }
                pdfObjectInfo_->setXVals(xVals_);
                pdfObjectInfo_->setYVals(yVals_);
                qDebug() << "[RAMINkord] " << pdfObjectInfo_->xVals().length();

                result.append(pdfObjectInfo_);
            }
            else if (selectedPDFType == "TMD")
            {
                auto tmdFactory = GenericTMDFactory();
                auto tmd_ = tmdFactory.mkTMD(pdfSetName, 0);
                xVals_.reserve(bins_.size());
                yVals_.reserve(bins_.size());
                double kt_;
                double mu_;
                foreach (double bin_ , bins_) {
                    xVals_.push_back(bin_);
                    if (pdfObjectInfo_->plotTypeIndex() == PlotTypeIndex::X) {
                        mu_ = pdfObjectInfo_->currentMuVal();
                        kt_ = pdfObjectInfo_->currentKtVal();
                        double pdfval_ = tmd_.tmd(flavor_, bin_, kt_ * kt_,  mu_ * mu_ );
                        if (pdfval_ <= 0)
                            pdfval_ = MIN_PDF_VAL;
                        yVals_.push_back(pdfval_);
                    }
                    else if (pdfObjectInfo_->plotTypeIndex() == PlotTypeIndex::Mu2)
                    {
                        kt_ = pdfObjectInfo_->currentKtVal();
                        mu_ = bin_;
                        double pdfval_ = tmd_.tmd(flavor_, pdfObjectInfo_->currentXVal(), kt_ * kt_ , mu_ * mu_);
                        if (pdfval_ <= 0)
                            pdfval_ = MIN_PDF_VAL;
                        yVals_.push_back(pdfval_);
                    }
                    else if (pdfObjectInfo_->plotTypeIndex() == PlotTypeIndex::Kt2) {
                        mu_ = pdfObjectInfo_->currentMuVal();
                        kt_ = bin_;
                        double pdfval_ = tmd_.tmd(flavor_, pdfObjectInfo_->currentXVal(), kt_ * kt_,  mu_ * mu_);

                        if (pdfval_ <= 0)
                            pdfval_ = MIN_PDF_VAL;
                        yVals_.push_back(pdfval_);
                    }
                    else
                    {
                        std::runtime_error("Unkown plot type index selected!");
                    }
                }
                pdfObjectInfo_->setXVals(xVals_);
                pdfObjectInfo_->setYVals(yVals_);
                result.append(pdfObjectInfo_);
            }
            else
            {
                std::runtime_error("Unkown pdf type is selected!");
            }
        }
    }
    return result;
}

int PDFDataProvider::getPlotTypeOfTab(TabIndex tabIndex)
{
    if (m_pdfObjectInfos.contains(tabIndex)) {
        return m_pdfObjectInfos[tabIndex].size() > 0 ? m_pdfObjectInfos[tabIndex][0]->plotTypeIndex() : -1;
    }
    return -1;
}

QString PDFDataProvider::getPDFTypeOfTab(TabIndex tabIndex)
{
    if (m_pdfObjectInfos.contains(tabIndex)) {
        QString result = m_pdfObjectInfos[tabIndex].size() > 0 ? m_pdfObjectInfos[tabIndex][0]->selectePDFType() : "";
        qDebug() << "result " << result;
        return result;
    }
    return "";
}

// Set PDF data for a specific tab index
void PDFDataProvider::setPDFData(TabIndex tabIndex, PDFObjectInfo *info) {
    if (!info) {
        return;
    }

    m_pdfObjectInfos[tabIndex].append(info);
    qDebug() << "[RAMIN] pdfdat " << m_pdfObjectInfos[tabIndex].size() <<" tabIndex " << tabIndex;
    emit pdfDataChanged(tabIndex);
}

// Create a new PDFObjectInfo instance
PDFObjectInfo* PDFDataProvider::createPDFObjectInfo() {
    return new PDFObjectInfo(this);
}

// Notify that data has changed for a tab index
void PDFDataProvider::notifyDataChanged(TabIndex tabIndex) {
    emit pdfDataChanged(tabIndex);
}

void PDFDataProvider::deleteTab(TabIndex tabIndex)
{
    if (m_pdfObjectInfos.contains(tabIndex))
    {
        qDeleteAll(m_pdfObjectInfos[tabIndex]);
        qDebug() << "tabIndex " << tabIndex << " deleted";
    }
}

// Singleton instance accessor
PDFDataProvider* PDFDataProvider::instance() {
    if (!s_instance) {
        s_instance = new PDFDataProvider();
    }
    return s_instance;
}

// QML provider function
QObject* PDFDataProvider::provider(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(scriptEngine);
    PDFDataProvider *provider = instance();
    QQmlEngine::setObjectOwnership(provider, QQmlEngine::CppOwnership);
    return provider;
}

// --- PDFObjectInfo Implementations ---

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
        emit partonFlavorIndexChanged();
    }
}

void PDFObjectInfo::setPartonFlavors(const QStringList &value) {
    if (m_partonFlavors != value) {
        m_partonFlavors = value;
        emit partonFlavorsChanged();
    }
}

void PDFObjectInfo::setPlotTypeIndex(int value) {
    if (m_plotTypeIndex != value) {
        m_plotTypeIndex = value;
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
        emit currentXValChanged();
    }
}

void PDFObjectInfo::setCurrentMuVal(double muVal)
{
    if (m_currentMuVal != muVal)
    {
        m_currentMuVal = muVal;
        emit currentMuValChanged();
    }
}

void PDFObjectInfo::setCurrentKtVal(double ktVal)
{
    if (m_currentKtVal != ktVal)
    {
        m_currentKtVal = ktVal;
        emit currentKtValChanged();
    }
}

void PDFObjectInfo::setSelectePDFType(const QString &selectedPDFType)
{
    if (m_selectedPDFType != selectedPDFType) {
        m_selectedPDFType = selectedPDFType;
        emit selectedPDFSetChanged();
    }
}

void PDFObjectInfo::setXMin(double xMin)
{
    m_xMin = xMin;
    emit currentXMinChanged();
}

void PDFObjectInfo::setXMax(double xMax)
{
    m_xMax = xMax;
    emit currentXMaxChanged();
}

void PDFObjectInfo::setMuMin(double muMin)
{
    m_muMin = muMin;
    emit currentMuMinChanged();
}

void PDFObjectInfo::setMuMax(double muMax)
{
    m_muMax = muMax;
    emit currentMuMaxChanged();
}

void PDFObjectInfo::setKtMin(double ktMin)
{
    m_ktMin = ktMin;
    emit currentKtMinChanged();
}

void PDFObjectInfo::setKtMax(double ktMax)
{
    m_ktMax = ktMax;
    emit currentKtMaxChanged();
}
