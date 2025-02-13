#pragma once
#include <optional>
#include <unordered_map>
#include <vector>

#include "Common/AllFlavorsShape.h"
#include "Common/GSL/GSLInterp2D.h"
#include "Implementation/Reader/Collinear/CDefaultLHAPDFFileReader.h"
#include "Interface/IInterpolator.h"
namespace PDFxTMD
{
class CGSLBicubicInterpolator
    : public IcPDFInterpolator<CGSLBicubicInterpolator, CDefaultLHAPDFFileReader>
{
  public:
    CGSLBicubicInterpolator() = default;
    ~CGSLBicubicInterpolator() = default;

    // Main interface method - hot path
    double interpolate(PartonFlavor flavor, double x, double q) const;
    void initialize(const IReader<CDefaultLHAPDFFileReader> *reader);

  private:
    mutable std::unordered_map<PartonFlavor, GSLInterp2D> gsl2dObj;
    const IReader<CDefaultLHAPDFFileReader> *m_reader;
    mutable bool m_isInitialized = false;
};
} // namespace PDFxTMD