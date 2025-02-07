#include <QApplication> // Change this line
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "DragDropModel.h"
#include "PlotModel.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Instantiate models
    DragDropModel dragDropModel;
    PlotModel plotModel;
    // Expose models to QML
    engine.rootContext()->setContextProperty("dragDropModel", &dragDropModel);
    engine.rootContext()->setContextProperty("plotModel", &plotModel);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(QUrl(QStringLiteral("qrc:/Main.qml")));

    return app.exec();
}
