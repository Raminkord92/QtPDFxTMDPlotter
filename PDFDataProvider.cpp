#include "pdfdataprovider.h"
#include <PDFxTMDLib/Factory.h>
#include "Utils.h"
#include <QDebug>
#include <QQmlEngine>
#include <limits>
#include <QtConcurrent/QtConcurrent>

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

// Asynchronous getPDFData
void PDFDataProvider::getPDFData(TabIndex tabIndex) {
    // Use a lambda to run computePDFData asynchronously
    QFuture<QList<PDFObjectInfo*>> future = QtConcurrent::run([this, tabIndex]() {
        return computePDFData(tabIndex);
    });

    // Connect a watcher to emit the result when ready
    QFutureWatcher<QList<PDFObjectInfo*>> *watcher = new QFutureWatcher<QList<PDFObjectInfo*>>(this);
    connect(watcher, &QFutureWatcher<QList<PDFObjectInfo*>>::finished, this, [this, tabIndex, watcher]() {
        QList<PDFObjectInfo*> result = watcher->result();
        emit pdfDataReady(tabIndex, result);
        watcher->deleteLater(); // Clean up the watcher
    });
    watcher->setFuture(future);
}

// The actual computation logic (previously getPDFData)
QList<PDFObjectInfo*> PDFDataProvider::computePDFData(TabIndex tabIndex) {
    QList<PDFObjectInfo*> result;

    if (m_pdfObjectInfos.contains(tabIndex)) {
        int plotType = getPlotTypeOfTab(tabIndex);

        foreach (auto pdfObjectInfo_, m_pdfObjectInfos[tabIndex]) {
            if (pdfObjectInfo_->yVals().size() != 0) {
                result.append(pdfObjectInfo_);
                continue;
            }

            QVector<double> xVals_, yVals_;

            PartonFlavor flavor_ = pdfObjectInfo_->FindPartonFlavor();
            if (flavor_ == static_cast<PartonFlavor>(-1)) {
                break;
            }
            double xMin_ = 0;
            double xMax_ = 0;
            if (plotType == PlotTypeIndex::X) {
                xMin_ = pdfObjectInfo_->xMin();
                xMax_ = pdfObjectInfo_->xMax();
            } else if (plotType == PlotTypeIndex::Mu2) {
                xMin_ = pdfObjectInfo_->muMin();
                xMax_ = pdfObjectInfo_->muMax();
            } else if (plotType == PlotTypeIndex::Kt2) {
                xMin_ = pdfObjectInfo_->ktMin();
                xMax_ = pdfObjectInfo_->ktMax();
            }
            auto bins_ = Utils::BinGeneratorInLogSpace(xMin_, xMax_, 200);
            std::string pdfSetName = pdfObjectInfo_->pdfSet().toStdString();
            QString selectedPDFType = getPDFTypeOfTab(tabIndex);
            if (selectedPDFType == "cPDF") {
                auto& pdfContainerInstance = GenericPDFContainer::getInstance();
                pdfContainerInstance.AddToContainer(pdfSetName, PDFSetType::CPDF);
                auto cPDF_ = pdfContainerInstance.GetcPDFFromContainer(pdfSetName);
                xVals_.reserve(bins_.size());
                yVals_.reserve(bins_.size());
                foreach (double bin_, bins_) {
                    xVals_.push_back(bin_);
                    if (pdfObjectInfo_->plotTypeIndex() == PlotTypeIndex::X) {
                        yVals_.push_back(cPDF_->pdf(flavor_, bin_, pdfObjectInfo_->currentMuVal() * pdfObjectInfo_->currentMuVal()));
                    } else if (pdfObjectInfo_->plotTypeIndex() == PlotTypeIndex::Mu2) {
                        double pdfval_ = cPDF_->pdf(flavor_, pdfObjectInfo_->currentXVal(), bin_ * bin_);
                        yVals_.push_back(pdfval_);
                    }
                }
                pdfObjectInfo_->setXVals(xVals_);
                pdfObjectInfo_->setYVals(yVals_);

                result.append(pdfObjectInfo_);
            } else if (selectedPDFType == "TMD") {
                auto& pdfContainerInstance = GenericPDFContainer::getInstance();
                pdfContainerInstance.AddToContainer(pdfSetName, PDFSetType::TMD);
                auto tmd_ = pdfContainerInstance.GetTMDFromContainer(pdfSetName);

                xVals_.reserve(bins_.size());
                yVals_.reserve(bins_.size());
                double kt_;
                double mu_;
                foreach (double bin_, bins_) {
                    xVals_.push_back(bin_);
                    if (pdfObjectInfo_->plotTypeIndex() == PlotTypeIndex::X) {
                        mu_ = pdfObjectInfo_->currentMuVal();
                        kt_ = pdfObjectInfo_->currentKtVal();
                        double pdfval_ = tmd_->tmd(flavor_, bin_, kt_ * kt_, mu_ * mu_);
                        if (pdfval_ <= 0)
                            pdfval_ = MIN_PDF_VAL;
                        yVals_.push_back(pdfval_);
                    } else if (pdfObjectInfo_->plotTypeIndex() == PlotTypeIndex::Mu2) {
                        kt_ = pdfObjectInfo_->currentKtVal();
                        mu_ = bin_;
                        double pdfval_ = tmd_->tmd(flavor_, pdfObjectInfo_->currentXVal(), kt_ * kt_, mu_ * mu_);
                        if (pdfval_ <= 0)
                            pdfval_ = MIN_PDF_VAL;
                        yVals_.push_back(pdfval_);
                    } else if (pdfObjectInfo_->plotTypeIndex() == PlotTypeIndex::Kt2) {
                        mu_ = pdfObjectInfo_->currentMuVal();
                        kt_ = bin_;
                        double pdfval_ = tmd_->tmd(flavor_, pdfObjectInfo_->currentXVal(), kt_ * kt_, mu_ * mu_);
                        if (pdfval_ <= 0)
                            pdfval_ = MIN_PDF_VAL;
                        yVals_.push_back(pdfval_);
                    } else {
                        throw std::runtime_error("Unknown plot type index selected!");
                    }
                }
                pdfObjectInfo_->setXVals(xVals_);
                pdfObjectInfo_->setYVals(yVals_);
                result.append(pdfObjectInfo_);
            } else {
                throw std::runtime_error("Unknown pdf type is selected!");
            }
        }
    }
    return result;
}

// Remaining methods unchanged
int PDFDataProvider::getPlotTypeOfTab(TabIndex tabIndex) {
    if (m_pdfObjectInfos.contains(tabIndex)) {
        return m_pdfObjectInfos[tabIndex].size() > 0 ? m_pdfObjectInfos[tabIndex][0]->plotTypeIndex() : -1;
    }
    return -1;
}

QString PDFDataProvider::getPDFTypeOfTab(TabIndex tabIndex) {
    if (m_pdfObjectInfos.contains(tabIndex)) {
        QString result = m_pdfObjectInfos[tabIndex].size() > 0 ? m_pdfObjectInfos[tabIndex][0]->selectePDFType() : "";
        return result;
    }
    return "";
}

void PDFDataProvider::setPDFData(TabIndex tabIndex, PDFObjectInfo *info) {
    if (!info) {
        return;
    }
    m_pdfObjectInfos[tabIndex].append(info);
    emit pdfDataChanged(tabIndex);
}

PDFObjectInfo* PDFDataProvider::createPDFObjectInfo() {
    return new PDFObjectInfo(this);
}

void PDFDataProvider::notifyDataChanged(TabIndex tabIndex) {
    emit pdfDataChanged(tabIndex);
}

void PDFDataProvider::deleteTab(TabIndex tabIndex) {
    if (m_pdfObjectInfos.contains(tabIndex)) {
        qDeleteAll(m_pdfObjectInfos[tabIndex]);
    }
}

void PDFDataProvider::deletePDFObjectInfoInTab(TabIndex tabIndex, int objectId) {
    if (m_pdfObjectInfos.contains(tabIndex)) {
        for (int i = 0; i < m_pdfObjectInfos[tabIndex].size(); i++) {
            if (m_pdfObjectInfos[tabIndex][i]->id() == objectId) {
                m_pdfObjectInfos[tabIndex].removeAt(i);
                emit pdfDataChanged(tabIndex);
                break;
            }
        }
    }
}

PDFDataProvider* PDFDataProvider::instance() {
    if (!s_instance) {
        s_instance = new PDFDataProvider();
    }
    return s_instance;
}

QObject* PDFDataProvider::provider(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(scriptEngine);
    PDFDataProvider *provider = instance();
    QQmlEngine::setObjectOwnership(provider, QQmlEngine::CppOwnership);
    return provider;
}
