#ifndef FILEWRITER_H
#define FILEWRITER_H

#include <QObject>
#include <QObject>
#include <QFile>
#include <QTextStream>

class FileWriter : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE void writeToFile(const QString &filePath, const QString &content);
};
#endif // FILEWRITER_H
