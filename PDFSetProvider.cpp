#include "PDFSetProvider.h"
#include <QDir>
#include <optional>


using namespace PDFxTMD;

PDFSetProvider::PDFSetProvider(QObject *parent)
    : QObject{parent}
{
    CalcEnvPaths();
}

QVector<PDFInfo> PDFSetProvider::getPDFSets() const
{
    using namespace PDFxTMD;
    m_pdfSetInfos.clear();
    for (auto envPath : m_envPDFxTMDPaths)
    {
        QDir envPathDir(envPath);
        if (!envPathDir.exists())
        {
            continue;
        }
        auto fileInfos = envPathDir.entryInfoList(QDir::AllDirs | QDir::NoDotAndDotDot);
        for (const auto& fileInfo: fileInfos)
        {
            QString PDFSetName = fileInfo.fileName();
            auto stdFileInfoPair = PDFxTMD::StandardInfoFilePath(PDFSetName.toStdString());
            std::pair<std::optional<YamlStandardPDFInfo>, ErrorType> pdfStandardInfo = PDFxTMD::YamlStandardPDFInfoReader<YamlStandardPDFInfo>(*stdFileInfoPair.first);
            if (pdfStandardInfo.second == PDFxTMD::ErrorType::None)
            {
                auto yamlStdInfo_ = *pdfStandardInfo.first;
                PDFInfo pdfInfo_;
                pdfInfo_.Flvors = yamlStdInfo_.Flvors;
                pdfInfo_.Format = yamlStdInfo_.Format;
                pdfInfo_.NumMembers = yamlStdInfo_.NumMembers;
                pdfInfo_.orderQCD = yamlStdInfo_.orderQCD;
                pdfInfo_.QMax = yamlStdInfo_.QMax;
                pdfInfo_.QMin = yamlStdInfo_.QMin;
                pdfInfo_.XMax = yamlStdInfo_.XMax;
                pdfInfo_.XMin = yamlStdInfo_.XMin;
                pdfInfo_.pdfSetName = PDFSetName;
                m_pdfSetInfos.emplaceBack(pdfInfo_);
            }
        }
    }
    return m_pdfSetInfos;
}

QStringList PDFSetProvider::getPDFSetEnvPaths()
{
    CalcEnvPaths();
    return m_envPDFxTMDPaths;
}

// bool PDFSetProvider::SelectEnvPath(const QString &selectedEnvPath)
// {
//     m_selectedDownloadPath = selectedEnvPath;
//     QDir selectedDownloadQDir(m_selectedDownloadPath);
//     if (!selectedDownloadQDir.exists())
//     {
//         return false;
//     }
// }

// bool PDFSetProvider::AddToEnvPaths(const QString &envPath)
// {
//     return PDFxTMD::EnvUtils::AddPathToEnvironment(envPath.toStdString());
// }

// bool PDFSetProvider::SelectDownloadUrl(DownloadUrlType downloadUrlType, QString url)
// {
//     m_downloadUrlType = downloadUrlType;
//     if (m_downloadUrlType == DownloadUrlType::LHAPDF)
//     {
//         std::string normalizedPDFSet = RepoSelectionCommand::normalizePDFSetName(m_pdfSetName.toStdString());
//         std::string url =
//             "http://lhapdfsets.web.cern.ch/lhapdfsets/current/" + normalizedPDFSet + ".tar.gz";
//         if (RepoSelectionCommand::CheckUrl(url, m_context))
//         {
//             m_context["URL"] = url;
//             return true;
//         }
//     }
//     else if (m_downloadUrlType == DownloadUrlType::TMDLib)
//     {
//         std::string normalizedPDFSet = RepoSelectionCommand::normalizePDFSetName(m_pdfSetName.toStdString());
//         std::string url = "https://syncandshare.desy.de/index.php/s/GjjcwKQC93M979e/"
//                           "download?path=%2FTMD%20grid%20files&files=" +
//                           normalizedPDFSet + ".tgz";
//         if (RepoSelectionCommand::CheckUrl(url, m_context))
//         {
//             m_context["URL"] = url;
//             return true;
//         }
//         return false;
//     }
//     else if (m_downloadUrlType == DownloadUrlType::Custom)
//     {
//         m_url = url;
//         return true;
//     }
//     return false;
// }

// void PDFSetProvider::SelectPDFSet(const QString &pdfSetName)
// {
//     m_pdfSetName = pdfSetName;
// }

// bool PDFSetProvider::StartDownload()
// {
//     PDFSetDownloadHandler pdfSetDownloadHandler;
//     m_context["SelectedPath"] = m_selectedDownloadPath.toStdString();
//     m_context["PDFSet"] = m_pdfSetName.toStdString();
//     m_context["URL"] = m_url.toStdString();
//     return pdfSetDownloadHandler.Start(m_pdfSetName.toStdString(), &m_context);
// }

void PDFSetProvider::CalcEnvPaths()
{
    auto envPaths = PDFxTMD::GetEnviormentalVariablePaths();

    for(auto&& envPath : envPaths)
    {
        m_envPDFxTMDPaths.emplaceBack(QString::fromStdString(envPath));
    }
    qDebug() << "Ramin " <<m_envPDFxTMDPaths;
}
