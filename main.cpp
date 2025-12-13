#include <QGuiApplication>
// #include <QHBoxLayout>
#include <QQmlApplicationEngine>
#include <QQuickStyle> // <--- 1. THÊM DÒNG NÀY

int main(int argc, char *argv[])
{
    QQuickStyle::setStyle("Basic");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Đăng ký tên module để import trong QML (tự động nhờ CMake, nhưng khai báo cho rõ)
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    // Load file Main.qml từ module NeonUI
    engine.loadFromModule("NeonUI", "Main");

    return app.exec();
}
