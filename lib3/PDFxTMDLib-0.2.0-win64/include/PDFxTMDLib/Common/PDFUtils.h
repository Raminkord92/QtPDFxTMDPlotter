#pragma once
#include "Interface/IReader.h"

namespace PDFxTMD
{
template <typename Reader> bool isInRangeX(const Reader &reader, double x)
{
    return x >= reader.getBoundaryValues(PhaseSpaceComponent::X).first &&
           x <= reader.getBoundaryValues(PhaseSpaceComponent::X).second;
}
template <typename Reader> bool isInRangeQ2(const Reader &reader, double q2)
{
    return q2 >= reader.getBoundaryValues(PhaseSpaceComponent::Q2).first &&
           q2 <= reader.getBoundaryValues(PhaseSpaceComponent::Q2).second;
}
template <typename Reader> bool isInRangeKt2(const Reader &reader, double kt2)
{
    return kt2 >= reader.getBoundaryValues(PhaseSpaceComponent::Kt2).first &&
           kt2 <= reader.getBoundaryValues(PhaseSpaceComponent::Kt2).second;
}
// Check if the point (x, mu) is within the range of the PDF
// set
template <typename Reader> bool isInRange(const Reader &reader, double x, double mu2)
{
    return isInRangeX<Reader>(reader, x) && isInRangeQ2<Reader>(reader, mu2);
}
template <typename Reader> bool isInRange(const Reader &reader, double x, double kt2, double mu2)
{
    return isInRange<Reader>(reader, x, mu2) && isInRangeKt2<Reader>(reader, kt2);
}
} // namespace PDFxTMD