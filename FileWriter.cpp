#include "FileWriter.h"
#include <QDebug>


void FileWriter::writeToFile(const QString &filePath, const QString &content) {
    QFile file(filePath);
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream stream(&file);
        stream << content;
        file.close();
    } else {
        qWarning() << "Failed to write to" << filePath;
    }
}
