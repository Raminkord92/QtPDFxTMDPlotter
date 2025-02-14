#ifndef PDFINFO_H
#define PDFINFO_H
#include <PDFxTMDLib/Common/PartonUtils.h>
#include <PDFxTMDLib/Common/YamlInfoReader.h>
#include <QString>

struct PDFInfo: PDFxTMD::YamlStandardPDFInfo
{
    QString pdfSetName;
};

#endif // PDFINFO_H
