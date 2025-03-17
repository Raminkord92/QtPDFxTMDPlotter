#ifndef PDFINFO_H
#define PDFINFO_H
#include <PDFxTMDLib/Common/PartonUtils.h>
#include <PDFxTMDLib/Common/YamlInfoReader.h>
#include <QString>
#include <QObject>
#include <QHash>
#include <QColor>
#include <QQmlEngine>
#include <QVariant>

enum PDFSetType
{
    CPDF,
    TMD
};

struct PDFInfo: PDFxTMD::YamlStandardTMDInfo
{
    QString pdfSetName;
    PDFSetType pdfSetType;
    PDFInfo(const YamlStandardTMDInfo& base)
        : YamlStandardTMDInfo(base) {}
};


using TabIndex = int;
#define MIN_PDF_VAL 2e-12

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
    Q_PROPERTY(double currentXVal READ currentXVal WRITE setCurrentXVal NOTIFY currentXValChanged)
    Q_PROPERTY(double currentMuVal READ currentMuVal WRITE setCurrentMuVal NOTIFY currentMuValChanged)
    Q_PROPERTY(double currentKtVal READ currentKtVal WRITE setCurrentKtVal NOTIFY currentKtValChanged)
    Q_PROPERTY(double xMin READ xMin WRITE setXMin NOTIFY currentXMinChanged)
    Q_PROPERTY(double xMax READ xMax WRITE setXMax NOTIFY currentXMaxChanged)
    Q_PROPERTY(double muMin READ muMin WRITE setMuMin NOTIFY currentMuMinChanged)
    Q_PROPERTY(double muMax READ muMax WRITE setMuMax NOTIFY currentMuMaxChanged)
    Q_PROPERTY(double ktMin READ ktMin WRITE setKtMin NOTIFY currentKtMinChanged)
    Q_PROPERTY(double ktMax READ ktMax WRITE setKtMax NOTIFY currentKtMaxChanged)
    Q_PROPERTY(QString selectePDFType READ selectePDFType WRITE setSelectePDFType NOTIFY selectedPDFSetChanged)
    Q_PROPERTY(int  id READ id WRITE setId NOTIFY idChanged)
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
    QString selectePDFType() const{return m_selectedPDFType;}
    QVector<double> xVals() const { return m_xVals; }
    QVector<double> yVals() const { return m_yVals; }
    int currentTabIndex() const { return m_currentTabIndex; }
    double currentXVal() const {return m_currentXVal;}
    double currentMuVal() const {return m_currentMuVal;}
    double currentKtVal() const {return m_currentKtVal;}
    double muMin() const {return m_muMin;}
    double muMax() const {return m_muMax;}
    double xMin() const {return m_xMin;}
    double xMax() const {return m_xMax;}
    double ktMin() const {return m_ktMin;}
    double ktMax() const {return m_ktMax;}
    int id() const {return m_id;}
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
    void setCurrentXVal(double xVal);
    void setCurrentMuVal(double muVal);
    void setCurrentKtVal(double ktVal);
    void setSelectePDFType(const QString& selectedPDFType);

    void setXMin(double xMin);
    void setXMax(double xMax);
    void setMuMin(double muMin);
    void setMuMax(double muMax);
    void setKtMin(double ktMin);
    void setKtMax(double ktMax);
    void setId(int id);
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
    void currentXValChanged();
    void currentMuValChanged();
    void currentKtValChanged();
    void currentXMinChanged();
    void currentXMaxChanged();
    void currentMuMinChanged();
    void currentMuMaxChanged();
    void currentKtMinChanged();
    void currentKtMaxChanged();
    void selectedPDFSetChanged();
    void idChanged();
private:
    QString m_pdfSet;
    QString m_displayText;
    QColor m_color;
    int m_lineStyleIndex = 0;
    int m_partonFlavorIndex = 0;
    QStringList m_partonFlavors;
    int m_plotTypeIndex = 0;
    QString m_selectedPDFType;
    QVector<double> m_xVals;
    QVector<double> m_yVals;
    int m_currentTabIndex = 0;
    double m_currentXVal = 0;
    double m_currentMuVal = 0;
    double m_currentKtVal = 0;
    double m_muMin = 0;
    double m_muMax = 0;
    double m_xMin = 0.1;
    double m_xMax = 0.1;
    double m_ktMin = 0.;
    double m_ktMax = 0.;
    int m_id = 0;
};


#endif // PDFINFO_H
