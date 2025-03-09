#include "GenericPDFContainer.h"

void GenericPDFContainer::AddToContainer(const std::string &pdfSetName, PDFSetType pdfSetType)
{
    if (pdfSetType == PDFSetType::CPDF)
    {
        if (m_cpdfSetNameToObject.contains(pdfSetName))
            return;
        m_cpdfSetNameToObject[pdfSetName] = std::make_shared<PDFxTMD::ICPDF>(m_cpdfFfactory.mkCPDF(pdfSetName, 0));
        return;
    }
    else if (pdfSetType == PDFSetType::TMD)
    {
        if (m_tmdSetNameToObject.contains(pdfSetName))
            return;
        m_tmdSetNameToObject[pdfSetName] = std::make_shared<PDFxTMD::ITMD>(m_tmdFactory.mkTMD(pdfSetName, 0));
        return;
    }
    throw std::runtime_error("No reachable GenericPDFContainer::AddToContainer");
    return;

}

std::shared_ptr<PDFxTMD::ICPDF> GenericPDFContainer::GetcPDFFromContainer(const std::string& pdfSetName)
{
    if (m_cpdfSetNameToObject.contains(pdfSetName))
    {
        return m_cpdfSetNameToObject[pdfSetName];
    }

    return nullptr;
}

std::shared_ptr<PDFxTMD::ITMD> GenericPDFContainer::GetTMDFromContainer(const std::string &pdfSetName)
{
    if (m_tmdSetNameToObject.contains(pdfSetName))
    {
        return m_tmdSetNameToObject[pdfSetName];
    }
    return nullptr;

}

