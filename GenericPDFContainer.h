#ifndef GENERICPDFCONTAINER_H
#define GENERICPDFCONTAINER_H

#include <map>
#include <QString>
#include <QMap>
#include <PDFxTMDLib/Factory.h>
#include <memory>
#include "PDFInfo.h"
#include <variant>
#include <optional>

class GenericPDFContainer
{
public:
    static GenericPDFContainer& getInstance() {
        static GenericPDFContainer instance;
        return instance;
    }
    void AddToContainer(const std::string& pdfSetName, PDFSetType pdfSetType );
    std::shared_ptr<PDFxTMD::ICPDF> GetcPDFFromContainer(const std::string& pdfSetName);
    std::shared_ptr<PDFxTMD::ITMD> GetTMDFromContainer(const std::string& pdfSetName);
    GenericPDFContainer(const GenericPDFContainer&) = delete;
    GenericPDFContainer(GenericPDFContainer&&) = delete;
    GenericPDFContainer&& operator=(GenericPDFContainer&&) = delete;
private:
    GenericPDFContainer() = default;
private:
    QMap<std::string, std::shared_ptr<PDFxTMD::ICPDF>> m_cpdfSetNameToObject;
    QMap<std::string, std::shared_ptr<PDFxTMD::ITMD>> m_tmdSetNameToObject;
    PDFxTMD::GenericCPDFFactory m_cpdfFfactory;
    PDFxTMD::GenericTMDFactory m_tmdFactory;
};

#endif // GENERICPDFCONTAINER_H
