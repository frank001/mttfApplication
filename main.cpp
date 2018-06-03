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
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    //clientSocket *socket = new clientSocket();
    //socket->connectSocket();

    return app.exec();

    //This should be on git.
}
