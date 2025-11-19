#include <QGuiApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

int main(int argc, char *argv[])
{
    // Enable high DPI scaling
    QGuiApplication::setHighDpiScaleFactorRoundingPolicy(
        Qt::HighDpiScaleFactorRoundingPolicy::PassThrough);

    QGuiApplication app(argc, argv);

    // Set application info
    QGuiApplication::setApplicationName("Car Screen UI");
    QGuiApplication::setApplicationVersion("1.0.0");
    QGuiApplication::setOrganizationName("CarScreenUI");
    QGuiApplication::setOrganizationDomain("carscreen.ui");

    // Set Material style for better look
    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;

    // Load QML
    const QUrl url(QStringLiteral("C:/Users/ADMIN/Desktop/CRANES/1st_yr/Qt/CarScreenUI/Main.qml"));

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() {
            qCritical() << "Failed to create QML object";
            QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl) {
                qCritical() << "Failed to load main QML file";
                QCoreApplication::exit(-1);
            }
        },
        Qt::QueuedConnection);

    engine.load(url);

    if (engine.rootObjects().isEmpty()) {
        qCritical() << "No root objects found";
        return -1;
    }

    return app.exec();
}
