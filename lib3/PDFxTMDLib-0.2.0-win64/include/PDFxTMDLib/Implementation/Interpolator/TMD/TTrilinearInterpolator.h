#pragma once

#include <string>
#include <vector>

#include "Common/AllFlavorsShape.h"
#include "Implementation/Reader/TMD/TDefaultAllFlavorReader.h"
#include "Interface/IInterpolator.h"
#include "Interface/IReader.h"

namespace PDFxTMD
{
class TTrilinearInterpolator
    : public ITMDInterpolator<TTrilinearInterpolator, TDefaultAllFlavorReader>
{
  public:
    explicit TTrilinearInterpolator() = default;
    void initialize(const IReader<TDefaultAllFlavorReader> *reader);
    double interpolate(PartonFlavor flavor, double x, double kt, double mu) const;

  private:
    const IReader<TDefaultAllFlavorReader> *m_reader;
    bool m_isInitialized = false;
    std::array<int, 3> m_dimensions;
    mutable DefaultAllFlavorUPDFShape m_updfShape;
};

} // namespace PDFxTMD
