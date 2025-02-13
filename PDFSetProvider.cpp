#include "PDFSetProvider.h"
#include <QDir>
#include <optional>

PDFSetProvider::PDFSetProvider(QObject *parent)
    : QObject{parent}
{
    auto envPaths = PDFxTMD::GetEnviormentalVariablePaths();

    for(auto&& envPath : envPaths)
    {
        m_envPDFxTMDPaths.emplaceBack(QString::fromStdString(envPath));
    }
    qDebug() << "Ramin " <<m_envPDFxTMDPaths;
}

QVector<PDFSetInfo> PDFSetProvider::getPDFSets() const
{
    using namespace PDFxTMD;
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
                m_pdfSetInfos.push_back(*pdfStandardInfo.first);
            }
        }
    }
    return m_pdfSetInfos;
}
