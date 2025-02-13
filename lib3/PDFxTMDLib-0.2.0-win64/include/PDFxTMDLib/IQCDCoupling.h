#pragma once
#include "Common/TypeErasureUtils.h"
#include <array>
#include <cstddef>
#include <cstdlib>
#include <memory>
#include <type_traits>
#include <utility>
// AlphaQCDMu2
namespace PDFxTMD
{
// Interface for QCD Coupling
class IQCDCoupling
{
  public:
    template <typename AlphaQCOperation_T>
    explicit IQCDCoupling(AlphaQCOperation_T alphaQCDApproach)
        : pimpl_(new OwningModel<AlphaQCOperation_T>(std::move(alphaQCDApproach)),
                 [](void *alphaQCDApproachBytes) {
                     using Model = OwningModel<AlphaQCOperation_T>;
                     auto *const model = static_cast<Model *>(alphaQCDApproachBytes);
                     delete model;
                 }),
          alphaQCOperation_([](void *alphaQCDApproachBytes, double mu2) -> double {
              using Model = OwningModel<AlphaQCOperation_T>;
              auto *const model = static_cast<Model *>(alphaQCDApproachBytes);
              return model->AlphaQCDMu2(mu2); // fixed the pdf method call
          }),
          clone_([](void *alphaQCDApproachBytes) -> void * {
              using Model = OwningModel<AlphaQCOperation_T>;
              auto *const model = static_cast<Model *>(alphaQCDApproachBytes);
              return new Model(*model);
          })
    {
    }

    double AlphaQCDMu2(double mu2) const
    {
        return alphaQCOperation_(pimpl_.get(), mu2);
    }

    IQCDCoupling(const IQCDCoupling &other)
        : pimpl_(other.clone_(other.pimpl_.get()), other.pimpl_.get_deleter()),
          clone_(other.clone_), alphaQCOperation_(other.alphaQCOperation_)
    {
    }

    IQCDCoupling &operator=(IQCDCoupling const &other)
    {
        using std::swap;
        IQCDCoupling copy(other);
        swap(pimpl_, copy.pimpl_);
        swap(clone_, copy.clone_);
        swap(alphaQCOperation_, copy.alphaQCOperation_);
        return *this;
    }

    IQCDCoupling(IQCDCoupling &&other) noexcept = default;
    ~IQCDCoupling() = default;
    IQCDCoupling &operator=(IQCDCoupling &&other) = default;

  private:
    template <typename AlphaQCOperation_T> struct OwningModel
    {
        OwningModel(AlphaQCOperation_T alphaQCDApproach) : alphaQCO_(std::move(alphaQCDApproach))
        {
        }

        double AlphaQCDMu2(double mu2)
        {
            return alphaQCO_.AlphaQCDMu2(mu2); // fixed the pdf method signature
        }

        AlphaQCOperation_T alphaQCO_;
    };

    using DestroyOperation = void(void *);
    using CloneOperation = void *(void *);
    using AlphaQCDOperation = double(void *, double);

    std::unique_ptr<void, DestroyOperation *> pimpl_;
    CloneOperation *clone_{nullptr};
    AlphaQCDOperation *alphaQCOperation_{nullptr};
};
} // namespace PDFxTMD
