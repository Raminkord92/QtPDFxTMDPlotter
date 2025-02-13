#ifndef PDFINFO_H
#define PDFINFO_H
#include <string>

struct PDFInfo {
    std::string pdfSetName;
    double muMax = 100;
    double muMin = 1;
};
#endif // PDFINFO_H
