#ifndef PLOTEXPORTER_H
#define PLOTEXPORTER_H

#include <QObject>
#include <QChart>

class PlotExporter : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE void exportToPDF(const QVariant &imageVariant, const QString &filePath);
};
#endif
