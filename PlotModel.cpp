#include "PlotModel.h"

PlotModel::PlotModel(QObject *parent)
    : QObject(parent)
{
}

bool PlotModel::isLogarithmicX() const { return m_logarithmicX; }
bool PlotModel::isLogarithmicY() const { return m_logarithmicY; }
qreal PlotModel::minX() const { return m_minX; }
qreal PlotModel::maxX() const { return m_maxX; }
qreal PlotModel::minY() const { return m_minY; }
qreal PlotModel::maxY() const { return m_maxY; }

void PlotModel::setLogarithmicX(bool value)
{
    if (m_logarithmicX != value) {
        m_logarithmicX = value;
        emit logarithmicXChanged();
    }
}

void PlotModel::setLogarithmicY(bool value)
{
    if (m_logarithmicY != value) {
        m_logarithmicY = value;
        emit logarithmicYChanged();
    }
}

void PlotModel::setMinX(qreal value)
{
    if (m_minX != value) {
        m_minX = value;
        emit minXChanged();
    }
}

void PlotModel::setMaxX(qreal value)
{
    if (m_maxX != value) {
        m_maxX = value;
        emit maxXChanged();
    }
}

void PlotModel::setMinY(qreal value)
{
    if (m_minY != value) {
        m_minY = value;
        emit minYChanged();
    }
}

void PlotModel::setMaxY(qreal value)
{
    if (m_maxY != value) {
        m_maxY = value;
        emit maxYChanged();
    }
}
