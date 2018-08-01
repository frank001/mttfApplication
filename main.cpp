#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "clientsocket.h"
#include "backend.h"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<BackEnd>("io.qt.BackEnd", 1, 0, "BackEnd");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/Main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;



    return app.exec();

}
