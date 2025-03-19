#ifndef DOWNLOADMANAGER_H
#define DOWNLOADMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QTemporaryFile>
#include <QStringList>

class DownloadManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(bool isDownloading READ isDownloading NOTIFY isDownloadingChanged)
    Q_PROPERTY(QStringList availablePaths READ availablePaths NOTIFY availablePathsChanged)

public:
    explicit DownloadManager(QObject *parent = nullptr);
    ~DownloadManager() override;

    double progress() const { return m_progress; }
    bool isDownloading() const { return m_isDownloading; }
    QStringList availablePaths() const { return m_availablePaths; }

public slots:
    void startDownload(const QString &pdfSetName, int repoType, const QString &customUrl = "", const QString &extractPath = "");
    Q_INVOKABLE bool addPath(const QString &newPath);

signals:
    void progressChanged(double progress);
    void isDownloadingChanged();
    void downloadFinished(bool success, const QString &errorMessage);
    void availablePathsChanged();

private slots:
    void onDownloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    void onDownloadFinished();
    void onError(QNetworkReply::NetworkError error);

private:
    QString normalizePDFSetName(const QString &pdfSetName) const;
    QString constructUrl(const QString &pdfSetName, int repoType, const QString &customUrl) const;
    void performDownload(const QString &url);
    bool extractAndCleanup(const QString &archivePath, const QString &outputDir);
    bool checkPathRequirements(const QString &path);

    QNetworkAccessManager *m_networkManager;
    QNetworkReply *m_reply;
    QTemporaryFile *m_tempFile;
    double m_progress;
    bool m_isDownloading;
    QString m_extractPath;
    QStringList m_availablePaths;
};

#endif // DOWNLOADMANAGER_H
