#ifndef PDFDATAPROVIDER_H
#define PDFDATAPROVIDER_H

#include <QObject>
#include <QHash>
#include <QColor>
#include <QQmlEngine>
#include <QVariant>
#include <PDFxTMDLib/Common/PartonUtils.h>
#pragma comment(lib, "PDFxTMDLibStatic.lib")

using TabIndex = int;

class PDFObjectInfo : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString pdfSet READ pdfSet WRITE setPdfSet NOTIFY pdfSetChanged)
    Q_PROPERTY(QString displayText READ displayText WRITE setDisplayText NOTIFY displayTextChanged)
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(int lineStyleIndex READ lineStyleIndex WRITE setLineStyleIndex NOTIFY lineStyleIndexChanged)
    Q_PROPERTY(int partonFlavorIndex READ partonFlavorIndex WRITE setPartonFlavorIndex NOTIFY partonFlavorIndexChanged)
    Q_PROPERTY(QStringList partonFlavors READ partonFlavors WRITE setPartonFlavors NOTIFY partonFlavorsChanged)
    Q_PROPERTY(int plotTypeIndex READ plotTypeIndex WRITE setPlotTypeIndex NOTIFY plotTypeIndexChanged)
    Q_PROPERTY(QVector<double> xVals READ xVals WRITE setXVals NOTIFY xValsChanged)
    Q_PROPERTY(QVector<double> yVals READ yVals WRITE setYVals NOTIFY yValsChanged)
    Q_PROPERTY(int currentTabIndex READ currentTabIndex WRITE setCurrentTabIndex NOTIFY currentTabIndexChanged)

public:
    explicit PDFObjectInfo(QObject *parent = nullptr);

    // Getters
    QString pdfSet() const { return m_pdfSet; }
    QString displayText() const { return m_displayText; }
    QColor color() const { return m_color; }
    int lineStyleIndex() const { return m_lineStyleIndex; }
    int partonFlavorIndex() const { return m_partonFlavorIndex; }
    QStringList partonFlavors() const { return m_partonFlavors; }
    int plotTypeIndex() const { return m_plotTypeIndex; }
    QVector<double> xVals() const { return m_xVals; }
    QVector<double> yVals() const { return m_yVals; }
    int currentTabIndex() const { return m_currentTabIndex; }
    PDFxTMD::PartonFlavor FindPartonFlavor();

    // Setters
    void setPdfSet(const QString &value);
    void setDisplayText(const QString &value);
    void setColor(const QColor &value);
    void setLineStyleIndex(int value);
    void setPartonFlavorIndex(int value);
    void setPartonFlavors(const QStringList &value);
    void setPlotTypeIndex(int value);
    void setXVals(const QVector<double> &value);
    void setYVals(const QVector<double> &value);
    void setCurrentTabIndex(int value);

signals:
    void pdfSetChanged();
    void displayTextChanged();
    void colorChanged();
    void lineStyleIndexChanged();
    void partonFlavorIndexChanged();
    void partonFlavorsChanged();
    void plotTypeIndexChanged();
    void xValsChanged();
    void yValsChanged();
    void currentTabIndexChanged();

private:
    QString m_pdfSet;
    QString m_displayText;
    QColor m_color;
    int m_lineStyleIndex = 0;
    int m_partonFlavorIndex = 0;
    QStringList m_partonFlavors;
    int m_plotTypeIndex = 0;
    QVector<double> m_xVals;
    QVector<double> m_yVals;
    int m_currentTabIndex = 0;
};

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

    Q_INVOKABLE QList<PDFObjectInfo*> getPDFData(TabIndex tabIndex, double xMin, double xMax);
    Q_INVOKABLE void setPDFData(TabIndex tabIndex, PDFObjectInfo *info);

    // New methods
    Q_INVOKABLE PDFObjectInfo* createPDFObjectInfo();
    Q_INVOKABLE void notifyDataChanged(TabIndex tabIndex);

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
