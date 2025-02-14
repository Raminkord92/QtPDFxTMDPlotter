#ifndef PDFSETPROVIDER_H
#define PDFSETPROVIDER_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QQmlApplicationEngine>
#include <QVector>
#include <PDFxTMDLib/Common/PartonUtils.h>
#include <PDFxTMDLib/Common/EnvUtils.h>
// #include <PDFxTMDLib/MissingPDFSetHandler/PDFSetDownloadHandler.h>
// #include <PDFxTMDLib/MissingPDFSetHandler/RepoSelectionCommand.h>
// #include <PDFxTMDLib/Common/KeyValueStore.h>
#include "PDFInfo.h"

enum class PDFSetType
{
    cPDF,
    TMD
};

enum class DownloadUrlType
{
    LHAPDF,
    TMDLib,
    Custom
};

class PDFSetProvider : public QObject
{
    Q_OBJECT
public:
    explicit PDFSetProvider(QObject *parent = nullptr);
    QVector<PDFInfo> getPDFSets() const;
    Q_INVOKABLE QStringList getPDFSetEnvPaths();
    // Q_INVOKABLE bool SelectEnvPath(const QString& selectedEnvPath);
    // Q_INVOKABLE bool AddToEnvPaths(const QString& envPath);
    // Q_INVOKABLE bool SelectDownloadUrl(DownloadUrlType downloadUrlType, QString url = "");
    // Q_INVOKABLE void SelectPDFSet(const QString& pdfSetName);
    // Q_INVOKABLE bool StartDownload();

signals:
private:
    void CalcEnvPaths();
private:
    QStringList m_envPDFxTMDPaths;
    // QString m_selectedDownloadPath;
    // DownloadUrlType m_downloadUrlType;
    // QString m_url;
    // QString m_pdfSetName;
    mutable QVector<PDFInfo> m_pdfSetInfos;
    // PDFxTMD::StandardTypeMap m_context;
};

#endif // PDFSETPROVIDER_H
