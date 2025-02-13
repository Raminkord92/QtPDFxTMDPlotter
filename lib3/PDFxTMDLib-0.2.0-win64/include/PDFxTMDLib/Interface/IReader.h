#pragma once
#include <string>
#include <vector>

#include "Common/InterfaceUtils.h"
#include "Common/PartonUtils.h"

namespace PDFxTMD
{
template <typename Derived> class IReader : public CRTPBase<Derived>
{
  public:
    void read(const std::string &pdfName, int setNumber)
    {
        this->derived().read(pdfName, setNumber);
    }

    auto getData() const
    {
        return this->derived().getData();
    }

    std::vector<double> getValues(PhaseSpaceComponent comp) const
    {
        return this->derived().getValues(comp);
    }

    std::pair<double, double> getBoundaryValues(PhaseSpaceComponent comp) const
    {
        return this->derived().getBoundaryValues(comp);
    }
};
} // namespace PDFxTMD
