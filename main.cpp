#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle> // <--- [1] THÊM DÒNG NÀY
#include "src/filescanner.h"
#include "src/vehicledata.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Basic");

    // Đăng ký Singleton VehicleData vào QML
    // Tên module: "NeonBackend", tên class: "VehicleData"
    qmlRegisterSingletonInstance("NeonBackend", 1, 0, "VehicleData", VehicleData::instance());

    qmlRegisterType<FileScanner>("NeonBackend", 1, 0, "FileScanner");

    QQmlApplicationEngine engine;

    // 1. Load màn hình chính (NeonOS)
    const QUrl url(u"qrc:/qt/qml/NeonUI/content/Main.qml"_qs);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    // 2. Load màn hình điều khiển (Sim Controller) - QUAN TRỌNG
    const QUrl controllerUrl(u"qrc:/qt/qml/NeonUI/content/ControllerWindow.qml"_qs);
    engine.load(controllerUrl);

    return app.exec();
}
