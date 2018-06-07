#include "backend.h"
#include <QDataStream>

BackEnd::BackEnd(QObject *parent): QObject(parent) {
    client = new clientSocket();
    //socket->connectSocket();

    connect(client, &clientSocket::hasReadSome, this, &BackEnd::receivedSomething);
    connect(client, &clientSocket::statusChanged, this, &BackEnd::setStatus);
        // FIXME change this connection to the new syntax
    connect(client->socket, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(gotError(QAbstractSocket::SocketError)));
}

bool BackEnd::getStatus() {
    return client->getStatus();
}

void BackEnd::setStatus(bool newStatus) {
    //qDebug() << "new status is:" << newStatus;
    if (newStatus) { emit statusChanged("CONNECTED"); }
    else { emit statusChanged("DISCONNECTED"); }
}

void BackEnd::receivedSomething(QString msg) {
    emit someMessage(msg);
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
    QByteArray arrBlock;
    QDataStream out(&arrBlock, QIODevice::WriteOnly);
    //out.setVersion(QDataStream::Qt_5_10);
    out << quint16(0) << msg;

    out.device()->seek(0);
    out << quint16(arrBlock.size() - sizeof(quint16));
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


