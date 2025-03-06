// This file is based on the LHAPDF code

#pragma once
#include <stdexcept>
#include <string>

#include "Common/Exception.h"
#include "Interface/IExtrapolator.h"
namespace PDFxTMD
{
class CErrExtrapolator : public IcPDFExtrapolator<CErrExtrapolator>
{
  public:
    double extrapolate(PartonFlavor flavor, double x, double mu) const
    {
        double q2 = mu * mu;
        throw std::runtime_error("Point x=" + std::to_string(x) + ", Q2=" + std::to_string(q2) +
                                 " is outside the PDF grid boundaries");
    }
};
} // namespace PDFxTMD