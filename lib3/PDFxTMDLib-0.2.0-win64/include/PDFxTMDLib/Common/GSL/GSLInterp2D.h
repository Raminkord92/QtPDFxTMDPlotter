#pragma once
#include <gsl/gsl_interp2d.h>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <vector>

class GSLInterp2D
{
  public:
    enum InterpolationType
    {
        Bilinear,
        Bicubic
    };

    void setParamters(const std::vector<double> &x, const std::vector<double> &y,
                      const std::vector<double> &z, InterpolationType interpType)
    {
        x_size = x.size();
        y_size = y.size();
        x_vals = x;
        y_vals = y;
        z_vals = z;
        m_interpolationType = interpType;
        initialize();
    }
    GSLInterp2D() = default;
    GSLInterp2D(const std::vector<double> &x, const std::vector<double> &y,
                const std::vector<double> &z, InterpolationType interpType)
        : x_size(x.size()), y_size(y.size()), x_vals(x), y_vals(y), z_vals(z),
          m_interpolationType(interpType)
    {
        initialize();
    }
    GSLInterp2D(const GSLInterp2D &other)
    {
        x_size = other.x_size;
        y_size = other.y_size;
        x_vals = other.x_vals;
        y_vals = other.y_vals;
        z_vals = other.z_vals;
        m_interpolationType = other.m_interpolationType;
        accel_x.reset(gsl_interp_accel_alloc());
        accel_y.reset(gsl_interp_accel_alloc());
        switch (m_interpolationType)
        {
        case InterpolationType::Bilinear:
            interp.reset(gsl_interp2d_alloc(gsl_interp2d_bilinear, x_size, y_size));
            break;
        case InterpolationType::Bicubic:
            interp.reset(gsl_interp2d_alloc(gsl_interp2d_bicubic, x_size, y_size));
            break;
        default:
            throw std::runtime_error(
                "[GSLInterp2D] undefined interpolation type for gsl is selected!");
        }
        gsl_interp2d_init(interp.get(), x_vals.data(), y_vals.data(), z_vals.data(), x_size,
                          y_size);
    }
    GSLInterp2D &operator=(const GSLInterp2D &other)
    {
        if (this != &other)
        {
            x_size = other.x_size;
            y_size = other.y_size;
            x_vals = other.x_vals;
            y_vals = other.y_vals;
            z_vals = other.z_vals;
            m_interpolationType = other.m_interpolationType;
            accel_x.reset(gsl_interp_accel_alloc());
            accel_y.reset(gsl_interp_accel_alloc());
            switch (m_interpolationType)
            {
            case InterpolationType::Bilinear:
                interp.reset(gsl_interp2d_alloc(gsl_interp2d_bilinear, x_size, y_size));
                break;
            case InterpolationType::Bicubic:
                interp.reset(gsl_interp2d_alloc(gsl_interp2d_bicubic, x_size, y_size));
                break;
            default:
                throw std::runtime_error(
                    "[GSLInterp2D] undefined interpolation type for gsl is selected!");
            }
            gsl_interp2d_init(interp.get(), x_vals.data(), y_vals.data(), z_vals.data(), x_size,
                              y_size);
        }
        return *this;
    }
    // Function to interpolate the value at (x, y)
    double interpolate(double x, double y) const
    {
        return gsl_interp2d_eval(interp.get(), x_vals.data(), y_vals.data(), z_vals.data(), x, y,
                                 accel_x.get(), accel_y.get());
    }

    GSLInterp2D(GSLInterp2D &&other) noexcept
        : x_size(other.x_size), y_size(other.y_size), x_vals(std::move(other.x_vals)),
          y_vals(std::move(other.y_vals)), z_vals(std::move(other.z_vals)),
          accel_x(std::move(other.accel_x)), accel_y(std::move(other.accel_y)),
          interp(std::move(other.interp)), m_interpolationType(other.m_interpolationType)
    {
        // Reset other object to a valid state
        other.x_size = 0;
        other.y_size = 0;
    }

    // Move assignment operator
    GSLInterp2D &operator=(GSLInterp2D &&other) noexcept
    {
        if (this != &other)
        {
            x_size = other.x_size;
            y_size = other.y_size;
            x_vals = std::move(other.x_vals);
            y_vals = std::move(other.y_vals);
            z_vals = std::move(other.z_vals);
            accel_x = std::move(other.accel_x);
            accel_y = std::move(other.accel_y);
            interp = std::move(other.interp);

            // Reset other object to a valid state
            other.x_size = 0;
            other.y_size = 0;
        }
        return *this;
    }

  private:
    void initialize()
    {
        if (x_vals.size() * y_vals.size() != z_vals.size())
        {
            throw std::invalid_argument("Mismatch in grid and data sizes");
        }
        // Allocate GSL objects with custom deleters
        accel_x.reset(gsl_interp_accel_alloc());
        accel_y.reset(gsl_interp_accel_alloc());
        switch (m_interpolationType)
        {
        case InterpolationType::Bilinear:
            interp.reset(gsl_interp2d_alloc(gsl_interp2d_bilinear, x_size, y_size));
            break;
        case InterpolationType::Bicubic:
            interp.reset(gsl_interp2d_alloc(gsl_interp2d_bicubic, x_size, y_size));
            break;
        default:
            throw std::runtime_error(
                "[GSLInterp2D] undefined interpolation type for gsl is selected!");
        }
        // Initialize the interpolator with grid and data points
        gsl_interp2d_init(interp.get(), x_vals.data(), y_vals.data(), z_vals.data(), x_size,
                          y_size);
    }

  private:
    size_t x_size, y_size;
    std::vector<double> x_vals;
    std::vector<double> y_vals;
    mutable std::vector<double> z_vals;
    InterpolationType m_interpolationType;

    // Declare unique pointers with custom deleters for GSL
    // objects
    std::unique_ptr<gsl_interp_accel, decltype(&gsl_interp_accel_free)> accel_x{
        nullptr, gsl_interp_accel_free};
    std::unique_ptr<gsl_interp_accel, decltype(&gsl_interp_accel_free)> accel_y{
        nullptr, gsl_interp_accel_free};
    std::unique_ptr<gsl_interp2d, decltype(&gsl_interp2d_free)> interp{nullptr, gsl_interp2d_free};
};
