// This file is based on the LHAPDF code

#pragma once

#include "Common/PDFUtils.h"
#include "Interface/IExtrapolator.h"
#include <cmath>

namespace PDFxTMD
{
// Return the value in the given list that best matches the
// target value
inline double _findClosestMatch(const std::vector<double> &cands, double target)
{
    auto it = std::lower_bound(cands.begin(), cands.end(), target);
    const double upper = *it;
    const double lower =
        (it == cands.begin()) ? upper : *(--it); //< Avoid decrementing the first entry
    /// @todo Closeness in linear or log space? Hmm...
    if (std::fabs(target - upper) < std::fabs(target - lower))
        return upper;
    return lower;
}

template <typename Reader, typename Interpolator>
class CNearestPointExtrapolator
    : public IcAdvancedPDFExtrapolator<CNearestPointExtrapolator<Reader, Interpolator>, Reader,
                                       Interpolator>
{
  public:
    double extrapolate(const IReader<Reader> *reader, PartonFlavor flavor, double x,
                       double mu) const
    {
        double q2 = mu * mu;
        /// Find the closest valid x and Q2 points, either on- or
        /// off-grid, and use the current interpolator
        /// @todo raise error for x > 1 ?
        auto xVals = reader->getValues(PhaseSpaceComponent::X);
        auto q2Vals = reader->getValues(PhaseSpaceComponent::Q2);

        const double closestX = (isInRangeX(*reader, x)) ? x : _findClosestMatch(xVals, x);
        const double closestQ2 = (isInRangeQ2(*reader, q2)) ? q2 : _findClosestMatch(q2Vals, q2);
        return this->m_interpolator->interpolate(flavor, closestX, closestQ2);
    }
};
} // namespace PDFxTMD