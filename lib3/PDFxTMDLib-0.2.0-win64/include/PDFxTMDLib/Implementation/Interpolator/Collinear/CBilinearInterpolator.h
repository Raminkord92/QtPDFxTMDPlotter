#pragma once
#include "Implementation/Reader/Collinear/CDefaultLHAPDFFileReader.h"
#include "Interface/IInterpolator.h"

namespace PDFxTMD
{
class CBilinearInterpolator
    : public IcPDFInterpolator<CBilinearInterpolator, CDefaultLHAPDFFileReader>
{
  public:
    CBilinearInterpolator() = default;
    ~CBilinearInterpolator() = default;

    // Main interface method - hot path
    double interpolate(PartonFlavor flavor, double x, double q2) const;
    void initialize(const IReader<CDefaultLHAPDFFileReader> *reader);
    const IReader<CDefaultLHAPDFFileReader> *getReader() const;
  private:
    const IReader<CDefaultLHAPDFFileReader> *m_reader;
    mutable std::vector<DefaultAllFlavorShape> m_Shape;
    mutable bool m_isInitialized = false;
};
} // namespace PDFxTMD
