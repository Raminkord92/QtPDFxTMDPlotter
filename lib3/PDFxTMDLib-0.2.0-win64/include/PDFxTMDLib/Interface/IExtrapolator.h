#pragma once
#include "IInterpolator.h"
#include "IReader.h"
namespace PDFxTMD
{
template <typename Derived, typename... ExtrapolateArgs>
class IExtrapolator : public CRTPBase<Derived>
{
  public:
    double extrapolate(ExtrapolateArgs... args) const
    {
        return this->derived().extrapolate(args...);
    }
};

template <typename Derived, typename Interpolator, typename... ExtrapolateArgs>
class IAdvancedExtrapolator : public IExtrapolator<Derived, ExtrapolateArgs...>
{
  public:
    void setInterpolator(const Interpolator *interpolator)
    {
        this->derived().setInterpolator(interpolator);
    }
};

template <typename Derived>
class IcPDFExtrapolator : public IExtrapolator<Derived, PartonFlavor, X_T, MU_T>
{
};

template <typename Derived, typename Interpolator>
class IcAdvancedPDFExtrapolator
    : public IAdvancedExtrapolator< Interpolator, PartonFlavor, X_T, MU_T>
{
};

template <typename Derived>
class ITMDExtrapolator : public IExtrapolator<Derived, PartonFlavor, X_T, KT_T, MU_T>
{
};

template <typename Derived, typename Interpolator>
class IcAdvancedTMDExtrapolator
    : public IAdvancedExtrapolator<Derived, Interpolator, PartonFlavor, X_T, KT_T, MU_T>
{
};

} // namespace PDFxTMD