#pragma once
#include "Common/InterfaceUtils.h"
#include "Common/PartonUtils.h"
#include "Interface/IReader.h"

namespace PDFxTMD
{
template <typename Derived, typename Reader, typename... InterpolateArgs>
class IInterpolator : public CRTPBase<Derived>
{
  public:
    void initialize(const IReader<Reader> *reader)
    {
        this->derived().initialize(reader);
    }

    double interpolate(InterpolateArgs... args) const
    {
        return this->derived().interpolate(args...);
    }
};
template <typename Reader, typename Derived>
class IcPDFInterpolator : public IInterpolator<Derived, Reader, PartonFlavor, X_T, MU_T>
{
};

template <typename Reader, typename Derived>
class ITMDInterpolator : public IInterpolator<Derived, Reader, PartonFlavor, X_T, KT_T, MU_T>
{
};
} // namespace PDFxTMD