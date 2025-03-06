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

struct DefaultAllFlavorShape
{
    DefaultAllFlavorShape() = default;
    std::vector<double> log_x_vec;
    std::vector<double> log_mu2_vec;
    std::vector<double> x_vec;
    std::vector<double> mu2_vec;
    void finalizeXP2()
    {
        for (double mu2 : mu2_vec)
        {
            log_mu2_vec.emplace_back(std::log(mu2));
        }
        for (double x : x_vec)
        {
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
inline double xf(const DefaultAllFlavorShape &shape, int ix, int iq2, PartonFlavor flavor)
{
    double test = shape.grids.at(flavor).at(ix * shape.mu2_vec.size() + iq2);
    return test;
}

} // namespace PDFxTMD
