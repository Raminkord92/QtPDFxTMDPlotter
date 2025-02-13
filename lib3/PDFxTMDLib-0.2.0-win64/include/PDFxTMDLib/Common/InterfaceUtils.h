#pragma once

#define KT_T double
#define X_T double
#define MU_T double

namespace PDFxTMD
{
// Base CRTP helper
template <typename Derived> class CRTPBase
{
  public:
    constexpr Derived &derived() noexcept
    {
        return static_cast<Derived &>(*this);
    }

    constexpr const Derived &derived() const noexcept
    {
        return static_cast<const Derived &>(*this);
    }
};
} // namespace PDFxTMD
