#ifndef PDFSETPROVIDER_H
#define PDFSETPROVIDER_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QQmlApplicationEngine>
#include <QVector>
#include <PDFxTMDLib/Common/PartonUtils.h>
#include <PDFxTMDLib/Common/YamlInfoReader.h>

enum class PDFSetType
{
    cPDF,
    TMD
};

using PDFSetInfo = PDFxTMD::YamlStandardPDFInfo;

class PDFSetProvider : public QObject
{
    Q_OBJECT
public:
    explicit PDFSetProvider(QObject *parent = nullptr);
    Q_INVOKABLE QVector<PDFSetInfo> getPDFSets() const;
signals:
private:
    QStringList m_envPDFxTMDPaths;
    mutable QVector<PDFSetInfo> m_pdfSetInfos;
};

#endif // PDFSETPROVIDER_H
