#pragma once
#include <stdexcept>
#include <string>

#include "Common/Exception.h"
#include "Interface/IExtrapolator.h"
namespace PDFxTMD
{
class TZeroExtrapolator : public ITMDExtrapolator<TZeroExtrapolator>
{
  public:
    double extrapolate(PartonFlavor flavor, double x, double kt2,
                       double mu2) const
    {
        return 0.0;
    }
};
} // namespace PDFxTMD