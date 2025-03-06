#ifndef PDFINFO_H
#define PDFINFO_H
#include <PDFxTMDLib/Common/PartonUtils.h>
#include <PDFxTMDLib/Common/YamlInfoReader.h>
#include <QString>

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

#endif // PDFINFO_H
