#ifndef PLOTMODEL_H
#define PLOTMODEL_H

#include <QObject>
#include <QMap>
#include <QDebug>

class PlotModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isLogarithmicX READ isLogarithmicX WRITE setLogarithmicX NOTIFY logarithmicXChanged)
    Q_PROPERTY(bool isLogarithmicY READ isLogarithmicY WRITE setLogarithmicY NOTIFY logarithmicYChanged)
    Q_PROPERTY(qreal minX READ minX WRITE setMinX NOTIFY minXChanged)
    Q_PROPERTY(qreal maxX READ maxX WRITE setMaxX NOTIFY maxXChanged)
    Q_PROPERTY(qreal minY READ minY WRITE setMinY NOTIFY minYChanged)
    Q_PROPERTY(qreal maxY READ maxY WRITE setMaxY NOTIFY maxYChanged)

public:
    explicit PlotModel(QObject *parent = nullptr);

    bool isLogarithmicX() const;
    bool isLogarithmicY() const;
    qreal minX() const;
    qreal maxX() const;
    qreal minY() const;
    qreal maxY() const;
    Q_INVOKABLE void testCallObject();
    void setLogarithmicX(bool value);
    void setLogarithmicY(bool value);
    void setMinX(qreal value);
    void setMaxX(qreal value);
    void setMinY(qreal value);
    void setMaxY(qreal value);

signals:
    void logarithmicXChanged();
    void logarithmicYChanged();
    void minXChanged();
    void maxXChanged();
    void minYChanged();
    void maxYChanged();

private:
    bool m_logarithmicX = false;
    bool m_logarithmicY = false;
    qreal m_minX = 0.0;
    qreal m_maxX = 10.0;
    qreal m_minY = 0.0;
    qreal m_maxY = 10.0;
};

inline void PlotModel::testCallObject()
{
    qDebug() <<  "[RAMIN] testCallObject";
}

#endif // PLOTMODEL_H
