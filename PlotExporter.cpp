#include "PlotExporter.h"

#include <QObject>
#include <QChart>
#include <QPrinter>
#include <QPainter>
#include <QImage>
 #include <QPdfWriter>

void PlotExporter::exportToPDF(const QVariant &imageVariant, const QString &filePath) {
    QImage image = imageVariant.value<QImage>();
    if (image.isNull()) {
        qWarning() << "Failed to retrieve valid image for PDF export";
        return;
    }
    QPdfWriter writer(filePath);
    writer.setPageSize(QPageSize(QPageSize::A4));
    QPainter painter(&writer);
    painter.drawImage(0, 0, image); // Draw image at top-left; adjust as needed
    painter.end();
}
