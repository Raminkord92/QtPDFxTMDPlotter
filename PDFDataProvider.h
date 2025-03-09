#ifndef PDFDATAPROVIDER_H
#define PDFDATAPROVIDER_H


#include <PDFxTMDLib/Common/PartonUtils.h>
#include "PDFInfo.h"
#include "GenericPDFContainer.h"

#pragma comment(lib, "PDFxTMDLibStatic.lib")

class PDFDataProvider : public QObject {
    Q_OBJECT
    Q_ENUMS(LineStyleIndex)
    Q_ENUMS(PlotTypeIndex)

public:
    enum LineStyleIndex {
        Solid = 0,
        Dashed = 1,
        Dotted = 2,
        DashDot = 3
    };

    enum PlotTypeIndex {
        X = 0,
        Mu2 = 1,
        Kt2 = 2
    };

    explicit PDFDataProvider(QObject *parent = nullptr);
    ~PDFDataProvider();

    // Q_INVOKABLE QList<PDFObjectInfo*> getPDFData(TabIndex tabIndex, double xMin, double xMax);
    Q_INVOKABLE QList<PDFObjectInfo*> getPDFData(TabIndex tabIndex);
    Q_INVOKABLE int getPlotTypeOfTab(TabIndex tabIndex);
    Q_INVOKABLE QString getPDFTypeOfTab(TabIndex tabIndex);
    Q_INVOKABLE void setPDFData(TabIndex tabIndex, PDFObjectInfo *info);

    // New methods
    Q_INVOKABLE PDFObjectInfo* createPDFObjectInfo();
    Q_INVOKABLE void notifyDataChanged(TabIndex tabIndex);
    Q_INVOKABLE void deleteTab(TabIndex tabIndex);
    Q_INVOKABLE void deletePDFObjectInfoInTab(TabIndex tabIndex, int objectId);
    static PDFDataProvider* instance();
    static QObject* provider(QQmlEngine *engine, QJSEngine *scriptEngine);

    static void registerTypes() {
        qmlRegisterType<PDFObjectInfo>("QtPDFxTMDPlotter", 1, 0, "PDFObjectInfo");
        qmlRegisterSingletonType<PDFDataProvider>("QtPDFxTMDPlotter", 1, 0, "PDFDataProvider", provider);
    }

signals:
    void pdfDataChanged(TabIndex tabIndex);

private:
    QHash<TabIndex, QList<PDFObjectInfo*>> m_pdfObjectInfos;
    static PDFDataProvider* s_instance;
};

#endif // PDFDATAPROVIDER_H
