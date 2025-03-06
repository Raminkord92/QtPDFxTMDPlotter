#include "DownloadManager.h"
#include <PDFxTMDLib/MissingPDFSetHandler/ArchiveExtractorCommand.h>
#include <PDFxTMDLib/Common/PartonUtils.h>
#include <PDFxTMDLib/Common/EnvUtils.h>
#include <QDir>
#include <QUrl>
#include <QFileInfo>
#include <QProcessEnvironment>
namespace PDFxTMD {
std::pair<bool, std::string> extract_archive(const std::string &archive_path, const std::string &output_dir);
}
DownloadManager::DownloadManager(QObject *parent)
    : QObject(parent),
    m_networkManager(new QNetworkAccessManager(this)),
    m_reply(nullptr),
    m_tempFile(nullptr),
    m_progress(0.0),
    m_isDownloading(false)
{
    auto pathEnvs =  PDFxTMD::GetEnviormentalVariablePaths();
    for (const auto& path : pathEnvs) {
        m_availablePaths.append(QString::fromStdString(path));
        emit availablePathsChanged();
    }
}
DownloadManager::~DownloadManager()
{
    if (m_reply) m_reply->deleteLater();
    if (m_tempFile) delete m_tempFile;
}

void DownloadManager::startDownload(const QString &pdfSetName, int repoType, const QString &customUrl, const QString &extractPath)
{
    if (m_isDownloading) {
        emit downloadFinished(false, "Download already in progress");
        return;
    }

    m_extractPath = extractPath.isEmpty() ? QDir::tempPath() : extractPath;
    if (!checkPathRequirements(m_extractPath)) {
        emit downloadFinished(false, "Failed to validate extraction directory: " + m_extractPath);
        return;
    }

    QString url = constructUrl(pdfSetName, repoType, customUrl);
    if (url.isEmpty()) {
        emit downloadFinished(false, "Invalid repository selection or URL");
        return;
    }

    m_isDownloading = true;
    emit isDownloadingChanged();
    performDownload(url);
}
bool DownloadManager::addPath(const QString &newPath)
{
    if (newPath.isEmpty() || m_availablePaths.contains(newPath)) {
        return false;
    }
    if (checkPathRequirements(newPath)) {
        // Update PATH environment (session-only)
        if (PDFxTMD::EnvUtils::AddPathToEnvironment(newPath.toStdString()))
        {
#if defined(__linux__)
            const char *currentPaths = getenv(ENV_PATH_VARIABLE);
               std::string updatedPaths = currentPaths ? std::string(currentPaths) + ":" + *pathStr : *pathStr;
            setenv(ENV_PATH_VARIABLE, updatedPaths.c_str(), 1);
#elif defined(_WIN32)

#endif
            m_availablePaths.append(newPath);
            emit availablePathsChanged();

            return true;
        }
        else
        {
            std::cerr << "Failed to add new path to environment variable "
                      << ENV_PATH_VARIABLE << std::endl;
        }
        return true;
    }
    return false;
}

bool DownloadManager::checkPathRequirements(const QString &path)
{
    QFileInfo dirInfo(path);
    QString parentPath = dirInfo.dir().absolutePath();
    QFileInfo parentInfo(parentPath);

    if (!parentInfo.isWritable() || !parentInfo.isReadable()) {
        return false;
    }
    if (!QDir().exists(path)) {
        return QDir().mkpath(path);
    }
    return true;
}

QString DownloadManager::normalizePDFSetName(const QString &pdfSetName) const
{
    QString normalized;
    for (const QChar &c : pdfSetName) {
        if (c == '+' || c == '=') {
            normalized += QString("%%%1").arg(static_cast<int>(c.toLatin1()), 2, 16, QChar('0')).toUpper();
        } else {
            normalized += c;
        }
    }
    return normalized;
}

QString DownloadManager::constructUrl(const QString &pdfSetName, int repoType, const QString &customUrl) const
{
    QString normalizedName = normalizePDFSetName(pdfSetName);
    switch (repoType) {
    case 1: // LHAPDF
        return QString("http://lhapdfsets.web.cern.ch/lhapdfsets/current/%1.tar.gz").arg(normalizedName);
    case 2: // TMDLib
        return QString("https://syncandshare.desy.de/index.php/s/GjjcwKQC93M979e/download?path=%2FTMD%20grid%20files&files=%1.tgz")
            .arg(normalizedName);
    case 3: // Custom
        if (!customUrl.isEmpty() && QUrl(customUrl).isValid()) {
            return customUrl;
        }
        break;
    default:
        break;
    }
    return QString();
}

void DownloadManager::performDownload(const QString &url)
{
    m_tempFile = new QTemporaryFile(QDir::tempPath() + "/XXXXXX.tar.gz");
    if (!m_tempFile->open()) {
        emit downloadFinished(false, "Failed to create temporary file");
        delete m_tempFile;
        m_tempFile = nullptr;
        m_isDownloading = false;
        emit isDownloadingChanged();
        return;
    }

    QUrl qUrl(url);
    QNetworkRequest request(qUrl);
    request.setHeader(QNetworkRequest::UserAgentHeader, "Mozilla/5.0");

    m_reply = m_networkManager->get(request);
    connect(m_reply, &QNetworkReply::downloadProgress, this, &DownloadManager::onDownloadProgress);
    connect(m_reply, &QNetworkReply::finished, this, &DownloadManager::onDownloadFinished);
    connect(m_reply, QOverload<QNetworkReply::NetworkError>::of(&QNetworkReply::errorOccurred),
            this, &DownloadManager::onError);
}

void DownloadManager::onDownloadProgress(qint64 bytesReceived, qint64 bytesTotal)
{
    if (bytesTotal > 0) {
        m_progress = static_cast<double>(bytesReceived) / bytesTotal;
        emit progressChanged();
    }
}

void DownloadManager::onDownloadFinished()
{
    if (m_reply->error() == QNetworkReply::NoError) {
        m_tempFile->write(m_reply->readAll());
        m_tempFile->close();
        m_progress = 1.0;
        emit progressChanged();

        if (extractAndCleanup(m_tempFile->fileName(), m_extractPath)) {
            m_isDownloading = false;
            emit isDownloadingChanged();
            emit downloadFinished(true, "Extracted to: " + m_extractPath);
        } else {
            m_isDownloading = false;
            emit isDownloadingChanged();
            emit downloadFinished(false, "Extraction failed");
        }
    } else {
        m_isDownloading = false;
        emit isDownloadingChanged();
        emit downloadFinished(false, m_reply->errorString());
    }

    if (m_tempFile) {
        m_tempFile->remove();
        delete m_tempFile;
        m_tempFile = nullptr;
    }
    m_reply->deleteLater();
    m_reply = nullptr;
}

void DownloadManager::onError(QNetworkReply::NetworkError error)
{
    emit downloadFinished(false, m_reply->errorString());
    m_isDownloading = false;
    m_progress = 0.0;
    emit progressChanged();
    emit isDownloadingChanged();
    if (m_tempFile) {
        m_tempFile->remove();
        delete m_tempFile;
        m_tempFile = nullptr;
    }
    m_reply->deleteLater();
    m_reply = nullptr;
}

bool DownloadManager::extractAndCleanup(const QString &archivePath, const QString &outputDir)
{
    auto result = PDFxTMD::extract_archive(archivePath.toStdString(), outputDir.toStdString());
    if (!result.first) {
        emit downloadFinished(false, QString::fromStdString(result.second));
        return false;
    }
    return true;
}
