#include "pdfdataprovider.h"
#include <PDFxTMDLib/Factory.h>
#include "Utils.h"
#include <QDebug>
#include <QQmlEngine>

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

// Retrieve PDF data for a given tab index within xMin and xMax range
QList<PDFObjectInfo*> PDFDataProvider::getPDFData(TabIndex tabIndex, double xMin, double xMax) {
    QList<PDFObjectInfo*> result;
    if (m_pdfObjectInfos.contains(tabIndex)) {
        GenericCPDFFactory cPDFFfactory;
        auto bins_ = Utils::BinGeneratorInLogSpace(xMin, xMax, 100);
        QList<PDFObjectInfo*> pdfObjectInfos = m_pdfObjectInfos[tabIndex];
        for (auto pdfObjectInfo_ : pdfObjectInfos) {
            std::string pdfSetName = pdfObjectInfo_->pdfSet().toStdString();
            auto cPDF_ = cPDFFfactory.mkCPDF(pdfSetName, 0);
            QVector<double> xVals_;
            xVals_.reserve(bins_.size());
            QVector<double> yVals_;
            yVals_.reserve(bins_.size());
            for (double bin_ : bins_) {
                xVals_.push_back(bin_);
                PartonFlavor flavor_ = pdfObjectInfo_->FindPartonFlavor();
                if (flavor_ == static_cast<PartonFlavor>(-1)) {
                    break;
                }
                if (pdfObjectInfo_->plotTypeIndex() == PlotTypeIndex::X) {
                    yVals_.push_back(cPDF_.pdf(flavor_, bin_, pdfObjectInfo_->currentMuVal()));
                } else if (pdfObjectInfo_->plotTypeIndex() == PlotTypeIndex::Mu2) {
                    qDebug() << "[RAMIN] pdfObjectInfo_->currentXVal() " << pdfObjectInfo_->currentXVal();
                    double pdfval_ = cPDF_.pdf(flavor_, pdfObjectInfo_->currentXVal(), bin_);
                    yVals_.push_back(pdfval_);
                }
            }
            pdfObjectInfo_->setXVals(xVals_);
            pdfObjectInfo_->setYVals(yVals_);
            result.append(pdfObjectInfo_);
        }
    }
    return result;
}

QList<PDFObjectInfo *> PDFDataProvider::getPDFData(TabIndex tabIndex)
{
    if (m_pdfObjectInfos.contains(tabIndex)) {
        return m_pdfObjectInfos[tabIndex];
    }
}

int PDFDataProvider::getPlotTypeOfTab(TabIndex tabIndex)
{
    if (m_pdfObjectInfos.contains(tabIndex)) {
        return m_pdfObjectInfos[tabIndex].size() > 0 ? m_pdfObjectInfos[tabIndex][0]->plotTypeIndex() : -1;
    }
    return -1;
}

// Set PDF data for a specific tab index
void PDFDataProvider::setPDFData(TabIndex tabIndex, PDFObjectInfo *info) {
    if (!info) {
        return;
    }
    m_pdfObjectInfos[tabIndex].append(info);
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
