#pragma once
#include <gsl/gsl_interp.h>

#include <iostream>
#include <memory>
#include <stdexcept>
#include <vector>

class GSLInterp1D
{
  public:
    enum InterpolationType
    {
        Linear,
        Cubic
    };

    // Default constructor
    GSLInterp1D() : x_size(0), m_interpolationType(InterpolationType::Linear)
    {
    }

    // Constructor: Initializes the 1D interpolator with grid and data.
    GSLInterp1D(const std::vector<double> &x, const std::vector<double> &y,
                InterpolationType interpType)
        : x_size(x.size()), x_vals(x), y_vals(y), m_interpolationType(interpType)
    {
        initialize();
    }

    // Copy constructor
    GSLInterp1D(const GSLInterp1D &other)
        : x_size(other.x_size), x_vals(other.x_vals), y_vals(other.y_vals),
          m_interpolationType(other.m_interpolationType)
    {
        accel.reset(gsl_interp_accel_alloc());
        switch (m_interpolationType)
        {
        case InterpolationType::Linear:
            interp.reset(gsl_interp_alloc(gsl_interp_linear, x_size));
            break;
        case InterpolationType::Cubic:
            interp.reset(gsl_interp_alloc(gsl_interp_cspline, x_size));
            break;
        default:
            throw std::runtime_error(
                "[GSLInterp1D] undefined interpolation type for gsl is selected!");
        }
        gsl_interp_init(interp.get(), x_vals.data(), y_vals.data(), x_size);
    }

    // Copy assignment operator
    GSLInterp1D &operator=(const GSLInterp1D &other)
    {
        if (this != &other)
        {
            x_size = other.x_size;
            x_vals = other.x_vals;
            y_vals = other.y_vals;
            m_interpolationType = other.m_interpolationType;
            accel.reset(gsl_interp_accel_alloc());
            switch (m_interpolationType)
            {
            case InterpolationType::Linear:
                interp.reset(gsl_interp_alloc(gsl_interp_linear, x_size));
                break;
            case InterpolationType::Cubic:
                interp.reset(gsl_interp_alloc(gsl_interp_cspline, x_size));
                break;
            default:
                throw std::runtime_error(
                    "[GSLInterp1D] undefined interpolation type for gsl is selected!");
            }
            gsl_interp_init(interp.get(), x_vals.data(), y_vals.data(), x_size);
        }
        return *this;
    }

    // Move constructor
    GSLInterp1D(GSLInterp1D &&other) noexcept
        : x_size(other.x_size), x_vals(std::move(other.x_vals)), y_vals(std::move(other.y_vals)),
          accel(std::move(other.accel)), interp(std::move(other.interp)),
          m_interpolationType(other.m_interpolationType)
    {
        // Reset other object to a valid state
        other.x_size = 0;
    }

    // Move assignment operator
    GSLInterp1D &operator=(GSLInterp1D &&other) noexcept
    {
        if (this != &other)
        {
            x_size = other.x_size;
            x_vals = std::move(other.x_vals);
            y_vals = std::move(other.y_vals);
            accel = std::move(other.accel);
            interp = std::move(other.interp);
            m_interpolationType = other.m_interpolationType;

            // Reset other object to a valid state
            other.x_size = 0;
        }
        return *this;
    }

    // Function to interpolate the value at x
    double interpolate(double x) const
    {
        return gsl_interp_eval(interp.get(), x_vals.data(), y_vals.data(), x, accel.get());
    }

    // Set parameters and initialize the interpolator
    void SetParameters(const std::vector<double> &x, const std::vector<double> &y,
                       InterpolationType interpType)
    {
        x_size = x.size();
        x_vals = x;
        y_vals = y;
        m_interpolationType = interpType;
        initialize();
    }

  private:
    void initialize()
    {
        if (x_vals.size() != y_vals.size())
        {
            throw std::invalid_argument("Mismatch in grid and data sizes");
        }

        // Allocate GSL object with custom deleter
        accel.reset(gsl_interp_accel_alloc());
        switch (m_interpolationType)
        {
        case InterpolationType::Linear:
            interp.reset(gsl_interp_alloc(gsl_interp_linear, x_size));
            break;
        case InterpolationType::Cubic:
            interp.reset(gsl_interp_alloc(gsl_interp_cspline, x_size));
            break;
        default:
            throw std::runtime_error(
                "[GSLInterp1D] undefined interpolation type for gsl is selected!");
        }

        // Initialize the interpolator with grid and data points
        gsl_interp_init(interp.get(), x_vals.data(), y_vals.data(), x_size);
    }

  private:
    size_t x_size{0};
    std::vector<double> x_vals;
    std::vector<double> y_vals;

    // Declare unique pointers with custom deleters for GSL objects
    std::unique_ptr<gsl_interp_accel, decltype(&gsl_interp_accel_free)> accel{
        nullptr, gsl_interp_accel_free};
    std::unique_ptr<gsl_interp, decltype(&gsl_interp_free)> interp{nullptr, gsl_interp_free};
    InterpolationType m_interpolationType{InterpolationType::Linear};
};