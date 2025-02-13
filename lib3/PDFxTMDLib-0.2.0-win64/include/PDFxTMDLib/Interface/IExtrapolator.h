#pragma once
#include "IInterpolator.h"
#include "IReader.h"
namespace PDFxTMD
{
template <typename Derived, typename Reader, typename... ExtrapolateArgs>
class IExtrapolator : public CRTPBase<Derived>
{
  public:
    double extrapolate(const IReader<Reader> *reader, ExtrapolateArgs... args) const
    {
        return this->derived().extrapolate(reader, args...);
    }
};

template <typename Derived, typename Reader, typename Interpolator, typename... ExtrapolateArgs>
class IAdvancedExtrapolator : public IExtrapolator<Derived, Reader, ExtrapolateArgs...>
{
  public:
    void setInterpolator(const Interpolator *interpolator)
    {
        m_interpolator = interpolator;
    }

  protected:
    const Interpolator *m_interpolator{nullptr};
};

template <typename Derived, typename Reader>
class IcPDFExtrapolator : public IExtrapolator<Derived, Reader, PartonFlavor, X_T, MU_T>
{
};

template <typename Derived, typename Reader, typename Interpolator>
class IcAdvancedPDFExtrapolator
    : public IAdvancedExtrapolator<Derived, Reader, Interpolator, PartonFlavor, X_T, MU_T>
{
};

template <typename Derived, typename Reader>
class ITMDExtrapolator : public IExtrapolator<Derived, Reader, PartonFlavor, X_T, KT_T, MU_T>
{
};

template <typename Derived, typename Reader, typename Interpolator>
class IcAdvancedTMDExtrapolator
    : public IAdvancedExtrapolator<Derived, Reader, Interpolator, PartonFlavor, X_T, KT_T, MU_T>
{
};

} // namespace PDFxTMD