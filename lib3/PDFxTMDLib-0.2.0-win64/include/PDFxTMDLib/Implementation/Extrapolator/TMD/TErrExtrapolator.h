#pragma once
#include <stdexcept>
#include <string>

#include "Common/Exception.h"
#include "Interface/IExtrapolator.h"
namespace PDFxTMD
{
template <typename Reader>
class TErrExtrapolator : public ITMDExtrapolator<TErrExtrapolator<Reader>, Reader>
{
  public:
    double extrapolate(const IReader<Reader> *reader, PartonFlavor flavor, double x, double kt2,
                       double mu2) const
    {
        throw std::runtime_error("Requested data is outside the PDF grid boundaries");
    }
};
} // namespace PDFxTMD