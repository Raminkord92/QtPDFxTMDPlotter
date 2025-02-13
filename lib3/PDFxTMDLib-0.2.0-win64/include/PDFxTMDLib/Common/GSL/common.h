#pragma once
#include <map>
#include <vector>

#include "Common/AllFlavorsShape.h"
#include "Common/PartonUtils.h"

// convert defaultshapeGrid to Gsl interpolation compatible
// grids
PDFxTMD::DefaultAllFlavorShape ConvertDefaultShapeGrids(
    const PDFxTMD::DefaultAllFlavorShape &defaultshape);
