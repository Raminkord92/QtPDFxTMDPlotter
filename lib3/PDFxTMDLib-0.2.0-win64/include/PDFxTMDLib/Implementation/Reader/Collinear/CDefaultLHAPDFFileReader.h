#pragma once
#include "Common/AllFlavorsShape.h"
#include "Common/NumParser.h"
#include "Interface/IReader.h"

namespace PDFxTMD
{

class CDefaultLHAPDFFileReader : public IReader<CDefaultLHAPDFFileReader>
{
  public:
    void read(const std::string &pdfName, int setNumber);
    DefaultAllFlavorShape getData() const;
    std::vector<double> getValues(PhaseSpaceComponent comp) const;
    std::pair<double, double> getBoundaryValues(PhaseSpaceComponent comp) const;

  private:
    DefaultAllFlavorShape m_pdfShape;
    int m_blockNumber = 0;
    int m_blockLine = 0;

  private:
    void processDataLine(const std::string &line, DefaultAllFlavorShape &data);
    void readXKnots(NumParser &parser, DefaultAllFlavorShape &data);
    void readQ2Knots(NumParser &parser, DefaultAllFlavorShape &data);
    void readParticleIds(NumParser &parser, DefaultAllFlavorShape &data);
    void readValues(NumParser &parser, DefaultAllFlavorShape &data);
};
} // namespace PDFxTMD
