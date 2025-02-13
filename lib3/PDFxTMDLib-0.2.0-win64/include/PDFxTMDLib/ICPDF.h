#pragma once
#include "Common/PartonUtils.h"
#include "Common/TypeErasureUtils.h"
#include <array>
#include <cstddef>
#include <cstdlib>
#include <memory>
#include <type_traits>
#include <utility>

namespace PDFxTMD
{
class ICPDF
{
  public:
    template <typename CPDFApproachT>
    explicit ICPDF(CPDFApproachT pdfApproach)
        : pimpl_(new OwningModel<CPDFApproachT>(std::move(pdfApproach)),
                 [](void *pdfApproachBytes) {
                     using Model = OwningModel<CPDFApproachT>;
                     auto *const model = static_cast<Model *>(pdfApproachBytes);
                     delete model;
                 }),
          pdfOperation_(
              [](void *pdfApproachBytes, PartonFlavor flavor, double x, double mu2) -> double {
                  using Model = OwningModel<CPDFApproachT>;
                  auto *const model = static_cast<Model *>(pdfApproachBytes);
                  return model->pdf(flavor, x, mu2); // fixed the pdf method call
              }),
          clone_([](void *pdfApproachBytes) -> void * {
              using Model = OwningModel<CPDFApproachT>;
              auto *const model = static_cast<Model *>(pdfApproachBytes);
              return new Model(*model);
          })
    {
    }

    double pdf(PartonFlavor parton, double x, double mu2) const
    {
        return pdfOperation_(pimpl_.get(), parton, x, mu2);
    }

    ICPDF(const ICPDF &other)
        : pimpl_(other.clone_(other.pimpl_.get()), other.pimpl_.get_deleter()),
          clone_(other.clone_), pdfOperation_(other.pdfOperation_)
    {
    }

    ICPDF &operator=(ICPDF const &other)
    {
        using std::swap;
        ICPDF copy(other);
        swap(pimpl_, copy.pimpl_);
        swap(clone_, copy.clone_);
        swap(pdfOperation_, copy.pdfOperation_);
        return *this;
    }

    ICPDF(ICPDF &&other) noexcept = default;
    ~ICPDF() = default;
    ICPDF &operator=(ICPDF &&other) = default;

  private:
    template <typename CPDFApproachT> struct OwningModel
    {
        OwningModel(CPDFApproachT pdfApproach) : pdfApproach_(std::move(pdfApproach))
        {
        }

        double pdf(PartonFlavor flavor, double x, double mu2)
        {
            return pdfApproach_.pdf(flavor, x, mu2); // fixed the pdf method signature
        }

        CPDFApproachT pdfApproach_;
    };

    using DestroyOperation = void(void *);
    using CloneOperation = void *(void *);
    using CPDFOperation = double(void *, PartonFlavor, double, double);

    std::unique_ptr<void, DestroyOperation *> pimpl_;
    CloneOperation *clone_{nullptr};
    CPDFOperation *pdfOperation_{nullptr};
};
} // namespace PDFxTMD
