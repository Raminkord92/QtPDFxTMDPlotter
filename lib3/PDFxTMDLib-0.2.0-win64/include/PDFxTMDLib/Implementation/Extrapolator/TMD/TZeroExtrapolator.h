#pragma once
#include <stdexcept>
#include <string>

#include "Common/Exception.h"
#include "Interface/IExtrapolator.h"
namespace PDFxTMD
{
template <typename Reader>
class TZeroExtrapolator : public ITMDExtrapolator<TZeroExtrapolator<Reader>, Reader>
{
  public:
    double extrapolate(const IReader<Reader> *reader, PartonFlavor flavor, double x, double kt2,
                       double mu2) const
    {
        return 0.0;
    }
};
} // namespace PDFxTMD