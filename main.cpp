#include <QApplication> // Change this line
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "PDFSetProvider.h"
#include "PlotModel.h"
#include "PDFInfoModel.h"
#include <QIcon>
#include "PDFDataProvider.h"
#include "DownloadManager.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    app.setWindowIcon(QIcon(":/images/images/PDFxTMD.png"));

    // Instantiate models
    PlotModel plotModel;
    // Expose models to QML
    engine.rootContext()->setContextProperty("plotModel", &plotModel);
    qmlRegisterType<DownloadManager>("QtPDFxTMDPlotter", 1, 0, "DownloadManager");
    qmlRegisterType<PDFInfoModel>("QtPDFxTMDPlotter", 1, 0, "PDFInfoModel");
    PDFDataProvider::registerTypes();
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(QUrl(QStringLiteral("qrc:/Main.qml")));

    return app.exec();
}
