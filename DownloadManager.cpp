#include "DownloadManager.h"
#include <PDFxTMDLib/Common/PartonUtils.h>
#include <PDFxTMDLib/Common/FileUtils.h>
#include <QDir>
#include <QUrl>
#include <QFileInfo>
#include <QProcessEnvironment>
#include <archive.h>
#include <archive_entry.h>


std::pair<bool, std::string> extract_archive(const std::string &archive_path,
                                             const std::string &output_dir)
{
    using namespace std::string_literals;
    struct archive *a;
    struct archive_entry *entry;
    int flags;
    int r;

    // Set extraction flags
    flags =
        ARCHIVE_EXTRACT_TIME | ARCHIVE_EXTRACT_PERM | ARCHIVE_EXTRACT_ACL | ARCHIVE_EXTRACT_FFLAGS;

    // Create a new archive reader
    a = archive_read_new();
    archive_read_support_format_all(a);
    archive_read_support_filter_all(a);

    // Open the archive file
    if ((r = archive_read_open_filename(a, archive_path.c_str(), 10240)))
    {
        archive_read_free(a);
        return {false, "Error opening archive: "s + archive_error_string(a)};
    }

    // Iterate over each entry in the archive
    while (true)
    {
        r = archive_read_next_header(a, &entry);
        if (r == ARCHIVE_EOF)
            break;
        if (r < ARCHIVE_OK)
            qWarning() << "Error reading header: " << archive_error_string(a);
        if (r < ARCHIVE_WARN)
        {
            archive_read_free(a);
            return {false, "Error reading header: "s + archive_error_string(a)};
        }

        // Construct the full output path
        std::string full_output_path = output_dir + "/" + archive_entry_pathname(entry);

        // Ensure the directory exists
        std::string dir_path = full_output_path.substr(0, full_output_path.find_last_of('/'));
        PDFxTMD::FileUtils::CreateDirs(dir_path);
        // Set the output path
        archive_entry_set_pathname(entry, full_output_path.c_str());

        // Extract the entry
        r = archive_read_extract(a, entry, flags);
        if (r < ARCHIVE_OK)
            qWarning() << "Error extracting file: " << archive_error_string(a);
        if (r < ARCHIVE_WARN)
        {
            archive_read_free(a);
            return {false, "Error extracting file: "s + archive_error_string(a)};
        }
    }

    // Clean up
    archive_read_close(a);
    archive_read_free(a);

    return {true, ""};
}

DownloadManager::DownloadManager(QObject *parent)
    : QObject(parent),
    m_networkManager(new QNetworkAccessManager(this)),
    m_reply(nullptr),
    m_tempFile(nullptr),
    m_progress(0.0),
    m_isDownloading(false)
{
    auto pathEnvs =  PDFxTMD::GetPDFxTMDPathsAsVector();
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
        if (PDFxTMD::AddPathToEnvironment(newPath.toStdString()))
        {
            m_availablePaths.append(newPath);
            emit availablePathsChanged();

            return true;
        }
        else
        {
            qWarning() << "Failed to add new path to environment variable ";
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
        emit progressChanged(m_progress);
    }
}

void DownloadManager::onDownloadFinished()
{
    if (!m_reply)
        return;
    if (m_reply->error() == QNetworkReply::NoError) {
        m_tempFile->write(m_reply->readAll());
        m_tempFile->close();
        m_progress = 1.0;
        emit progressChanged(100);

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
    if (m_reply && m_reply->isOpen())
    {
        emit downloadFinished(false, m_reply->errorString());
        m_isDownloading = false;
        m_progress = 0.0;
        emit progressChanged(0);
        emit isDownloadingChanged();
        if (m_tempFile) {
            m_tempFile->remove();
            delete m_tempFile;
            m_tempFile = nullptr;
        }
        m_reply->deleteLater();
        m_reply = nullptr;
    }

}

bool DownloadManager::extractAndCleanup(const QString &archivePath, const QString &outputDir)
{
    auto result = extract_archive(archivePath.toStdString(), outputDir.toStdString());
    if (!result.first) {
        emit downloadFinished(false, QString::fromStdString(result.second));
        return false;
    }
    return true;
}
