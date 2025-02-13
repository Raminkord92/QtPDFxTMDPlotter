#pragma once
#include "Common/GSL/GSLInterp1D.h"
#include "Interface/ICoupling.h"
#include <memory>

namespace PDFxTMD
{
class YamlCouplingInterp : public ICoupling<YamlCouplingInterp>
{
  public:
    YamlCouplingInterp() = default;
    void SetParamters(const std::vector<double> &mu2_vec, const std::vector<double> &alsphasVec)
    {
        m_mu2_vec = mu2_vec;
        m_alsphasVec_vec = alsphasVec;
        initialize();
    }
    YamlCouplingInterp(std::vector<double> mu2_vec, std::vector<double> alphasVec);
    double AlphaQCDMu2(double mu2);
    // Move constructor
    YamlCouplingInterp(const YamlCouplingInterp &other) = default;
    YamlCouplingInterp &operator=(const YamlCouplingInterp &other) = default;

  private:
    void initialize();

  private:
    GSLInterp1D m_gslInterp1D;
    double m_mu2Min = 0;
    double m_mu2Max = 0;
    std::vector<double> m_mu2_vec;
    std::vector<double> m_alsphasVec_vec;
};
} // namespace PDFxTMD
