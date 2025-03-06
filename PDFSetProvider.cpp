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
    foreach (auto envPath, m_envPDFxTMDPaths)
    {
        QDir envPathDir(envPath);
        if (!envPathDir.exists())
        {
            continue;
        }
        auto fileInfos = envPathDir.entryInfoList(QDir::AllDirs | QDir::NoDotAndDotDot);
        foreach (const auto& fileInfo, fileInfos)
        {
            QString PDFSetName = fileInfo.fileName();
            auto stdFileInfoPair = PDFxTMD::StandardInfoFilePath(PDFSetName.toStdString());
            std::pair<std::optional<YamlStandardTMDInfo>, ErrorType> pdfStandardInfo = PDFxTMD::YamlStandardPDFInfoReader<YamlStandardTMDInfo>(*stdFileInfoPair.first);
            if (pdfStandardInfo.first != std::nullopt)
            {
                PDFInfo pdfInfo_ = PDFInfo(*pdfStandardInfo.first);
                qDebug() << "[RAMIN] ktmin" << pdfInfo_.KtMin;
                pdfInfo_.pdfSetName = PDFSetName;
                //because we expect to obtain tmdinfo from yaml info file, then if there is no error, it means it is tmd else it is cPDF
                if (pdfStandardInfo.second == ErrorType::None)
                {
                    pdfInfo_.pdfSetType = PDFSetType::TMD;
                }
                else
                {
                    pdfInfo_.pdfSetType = PDFSetType::CPDF;
                }
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

void PDFSetProvider::CalcEnvPaths()
{
    auto envPaths = PDFxTMD::GetEnviormentalVariablePaths();

    for(auto&& envPath : envPaths)
    {
        m_envPDFxTMDPaths.emplaceBack(QString::fromStdString(envPath));
    }
}
