#pragma once
#include <algorithm>
#include <array>
#include <cmath>
#include <iostream>
#include <set>
#include <unordered_map>
#include <vector>

#include "Common/PartonUtils.h"

// General function to find the knot below a given value
namespace PDFxTMD
{
inline bool isBlockSeparator(const std::string &line)
{
    return line == "---";
}
inline bool isComment(const std::string &line)
{
    return !line.empty() && line[0] == '#';
}

inline size_t indexbelow(double value, const std::vector<double> &knots)
{
    auto it = std::upper_bound(knots.begin(), knots.end(), value);
    return (it == knots.begin()) ? 0 : (it - knots.begin() - 1);
}
struct DefaultAllFlavorShape
{
    DefaultAllFlavorShape() = default;
    std::vector<double> log_x_vec;
    std::vector<double> log_mu2_vec;
    std::set<double> x_set;
    std::set<double> mu2_set;
    std::vector<double> x_vec;
    std::vector<double> mu2_vec;
    void finalizeXP2()
    {
        for (double mu2 : mu2_set)
        {
            mu2_vec.emplace_back(mu2);
            log_mu2_vec.emplace_back(std::log(mu2));
        }
        for (double x : x_set)
        {
            x_vec.emplace_back(x);
            log_x_vec.emplace_back(std::log(x));
        }
    }

    std::set<PartonFlavor> flavors;
    std::unordered_map<PartonFlavor, std::vector<double>> grids;
};

struct DefaultAllFlavorUPDFShape : DefaultAllFlavorShape
{
    DefaultAllFlavorUPDFShape() = default;
    std::vector<double> log_kt2_vec;
    std::vector<double> kt2_vec;
};
struct FastDefaultAllFlavorShape : DefaultAllFlavorShape
{
    FastDefaultAllFlavorShape() = default;
    std::vector<PartonFlavor> flavors;
    std::vector<double> grids;
    std::vector<size_t> shapes;

    void initializeShape()
    {
        shapes.resize(3);
        shapes[0] = log_x_vec.size();
        shapes[1] = log_mu2_vec.size();
        shapes[2] = flavors.size();
    }
    double xf(int ix, int iq2, int ipid) const
    {
        return grids[ix * shapes[2] * shapes[1] + iq2 * shapes[2] + ipid];
    }
};
} // namespace PDFxTMD
