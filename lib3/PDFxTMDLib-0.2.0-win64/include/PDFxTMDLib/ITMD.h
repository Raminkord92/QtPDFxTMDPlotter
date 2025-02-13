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
class ITMD
{
  public:
    template <typename TMDApproachT>
    explicit ITMD(TMDApproachT tmdApproach)
        : pimpl_(new OwningModel<TMDApproachT>(std::move(tmdApproach)),
                 [](void *tmdfApproachBytes) {
                     using Model = OwningModel<TMDApproachT>;
                     auto *const model = static_cast<Model *>(tmdfApproachBytes);
                     delete model;
                 }),
          tmdOperation_([](void *tmdfApproachBytes, PartonFlavor flavor, double x, double kt2,
                           double mu2) -> double {
              using Model = OwningModel<TMDApproachT>;
              auto *const model = static_cast<Model *>(tmdfApproachBytes);
              return model->tmd(flavor, x, kt2, mu2); // fixed the pdf method call
          }),
          clone_([](void *tmdfApproachBytes) -> void * {
              using Model = OwningModel<TMDApproachT>;
              auto *const model = static_cast<Model *>(tmdfApproachBytes);
              return new Model(*model);
          })
    {
    }

    double tmd(PartonFlavor flavor, double x, double kt2, double mu2) const
    {
        return tmdOperation_(pimpl_.get(), flavor, x, kt2, mu2);
    }

    ITMD(const ITMD &other)
        : pimpl_(other.clone_(other.pimpl_.get()), other.pimpl_.get_deleter()),
          clone_(other.clone_), tmdOperation_(other.tmdOperation_)
    {
    }

    ITMD &operator=(ITMD const &other)
    {
        using std::swap;
        ITMD copy(other);
        swap(pimpl_, copy.pimpl_);
        swap(clone_, copy.clone_);
        swap(tmdOperation_, copy.tmdOperation_);
        return *this;
    }

    ITMD(ITMD &&other) noexcept = default;
    ~ITMD() = default;
    ITMD &operator=(ITMD &&other) = default;

  private:
    template <typename TMDApproachT> struct OwningModel
    {
        OwningModel(TMDApproachT tmdApproach) : m_tmdApproach(std::move(tmdApproach))
        {
        }

        double tmd(PartonFlavor flavor, double x, double kt2, double mu2)
        {
            return m_tmdApproach.tmd(flavor, x, kt2, mu2);
        }

        TMDApproachT m_tmdApproach;
    };

    using DestroyOperation = void(void *);
    using CloneOperation = void *(void *);
    using TMDOperation = double(void *, PartonFlavor, double, double, double);

    std::unique_ptr<void, DestroyOperation *> pimpl_;
    CloneOperation *clone_{nullptr};
    TMDOperation *tmdOperation_{nullptr};
};
} // namespace PDFxTMD
