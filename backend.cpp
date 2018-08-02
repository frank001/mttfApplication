#include "backend.h"
#include <QDataStream>
#include <QJsonDocument>
#include <QJsonObject>
#include <QMetaEnum>

BackEnd::BackEnd(QObject *parent): QObject(parent) {
    client = new clientSocket();
    //socket->connectSocket();

    connect(client, &clientSocket::hasReadSome, this, &BackEnd::receivedSomething);
    connect(client, &clientSocket::statusChanged, this, &BackEnd::setStatus);
        // FIXME change this connection to the new syntax
    connect(client->socket, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(gotError(QAbstractSocket::SocketError)));
    //connect(client->socket, &QTcpSocket::error, this, &BackEnd::gotError);

    //client->connectSocket();

}

bool BackEnd::getStatus() {
    return client->getStatus();
}

void BackEnd::setStatus(bool newStatus) {
    //qDebug() << "new status is:" << newStatus;
    if (newStatus) { emit statusChanged("CONNECTED"); }
    else { emit statusChanged("DISCONNECTED"); bInitialization=true; }
}

void BackEnd::receivedSomething(QByteArray msg) {
    QMetaObject MetaObject = this->staticMetaObject;
    QMetaEnum MetaEnum = MetaObject.enumerator(MetaObject.indexOfEnumerator("eResponse"));

    QJsonDocument jdData;
    jdData = QJsonDocument::fromBinaryData(msg);
    QString sData = jdData.toJson();

    QJsonObject joData = jdData.object();
    QString test = jdData.toJson();

    if (joData.keys().length()==0) {
        QJsonObject error;
        error.insert("error", QJsonValue::fromVariant(msg));
        error.insert("message", QJsonValue::fromVariant("No valid data received."));
        QJsonDocument jdError(error);
        jdData = jdError;
    } else {
        QString key = joData.keys().at(0);

        //QString cmd = request.value("command").toString();

        switch (MetaEnum.keysToValue(key.toLatin1())) {
        case state:
            jdState = jdData;
            emit stateChange(jdState.toJson());
            if (bInitialization)
                sendClicked("getConfig", "");
            break;
        case config:
            jdConfig = jdData;
            emit configChange(jdConfig.toJson());
            if (bInitialization)
                sendClicked("getPorts", "");
            break;
        case ports:
            jdPorts = jdData;
            emit portInfo(jdPorts.toJson());
            if (bInitialization)
                sendClicked("getCycle", "");
            break;
        case cycle:
            jdCycle = jdData;
            emit cycleInfo(jdCycle.toJson());
            if (bInitialization)
                bInitialization=false;
            break;
        default:
            emit someMessage(jdData.toJson());
            break;
        }

    }
}

void BackEnd::gotError(QAbstractSocket::SocketError err) {
    //qDebug() << "got error";
    QString strError = "unknown";
    switch (err) {
        case 0:
            strError = "Connection was refused";
            break;
        case 1:
            strError = "Remote host closed the connection";
            break;
        case 2:
            strError = "Host address was not found";
            break;
        case 5:
            strError = "Connection timed out";
            break;
        default:
            strError = "Unknown error";
    }

    emit someError(strError);
}

void BackEnd::connectClicked() {
    client->connectSocket();
}


void BackEnd::sendClicked(QString command, QString value) {
    QString msg="{ \"command\": \"" +command + "\", \"value\" : \""+value+"\" }";
    /*QByteArray arrBlock;
    QDataStream out(&arrBlock, QIODevice::WriteOnly);
    //out.setVersion(QDataStream::Qt_5_10);
    out << quint16(0) << msg;

    out.device()->seek(0);
    out << quint16(arrBlock.size() - sizeof(quint16));
    */

    QByteArray ba = msg.toUtf8();

    client->socket->write(ba);

}

void BackEnd::sendClicked(QString raw) {
    QByteArray arrBlock;
    QDataStream out(&arrBlock, QIODevice::WriteOnly);
    out << quint16(0) << raw;

    out.device()->seek(0);
    out << quint16(arrBlock.size() - sizeof(quint16));
    QByteArray ba = raw.toUtf8();
    client->socket->write(ba);

}

void BackEnd::disconnectClicked() {
    client->closeConnection();
}

void BackEnd::Configuration() {
    int i =0;
}
