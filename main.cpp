#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "track_data.hpp"
#include "audiomanage.hpp"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<TrackData>("DAW_CPP", 1, 0, "TrackData");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;


    return app.exec();
}
