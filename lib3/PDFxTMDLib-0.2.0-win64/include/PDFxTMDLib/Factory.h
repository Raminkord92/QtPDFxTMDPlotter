#pragma once
#include "GenericPDF.h"
#include "ICPDF.h"
#include "IQCDCoupling.h"
#include "ITMD.h"

namespace PDFxTMD
{

class CouplingFactory
{
  public:
    CouplingFactory() = default;
    IQCDCoupling mkCoupling(const std::string &pdfSetName);

  private:
    std::string m_pdfSetName;
    AlphasType m_alphaType = AlphasType::ipol;
};

class GenericTMDFactory
{
  public:
    GenericTMDFactory() = default;
    ITMD mkTMD(const std::string &pdfSetName, int setMember);
};

class GenericCPDFFactory
{
  public:
    GenericCPDFFactory() = default;
    ICPDF mkCPDF(const std::string &pdfSetName, int setMember);
};
} // namespace PDFxTMD
