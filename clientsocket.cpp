#include "clientsocket.h"
#include <QTcpSocket>
#include <QTimer>
#include <QDataStream>

clientSocket::clientSocket() : QObject(), m_nNextBlockSize(0) {
    status = false;
    socket = new QTcpSocket();

    host = "127.0.0.1";
    port = 1337;

    timeoutTimer = new QTimer();
    timeoutTimer->setSingleShot(true);

    connect(timeoutTimer, &QTimer::timeout, this, &clientSocket::connectionTimeout);

    connect(socket, &QTcpSocket::disconnected, this, &clientSocket::closeConnection);
}

void clientSocket::connectSocket() {
    timeoutTimer->start(3000);

    socket->connectToHost(host, port);
    connect(socket, &QTcpSocket::connected, this, &clientSocket::connected);
    connect(socket, &QTcpSocket::readyRead, this, &clientSocket::readyRead);
}

void clientSocket::connectionTimeout() {
    //qDebug() << tcpSocket->state();
    if(socket->state() == QAbstractSocket::ConnectingState) {
        socket->abort();
        emit socket->error(QAbstractSocket::SocketTimeoutError);
    }
}
void clientSocket::connected() {
    status = true;
    emit statusChanged(status);
}
bool clientSocket::getStatus() {return status;}

void clientSocket::readyRead() {
    QByteArray ba = socket->readAll();
    emit hasReadSome(ba);
    /*
    QDataStream in(socket);
    //in.setVersion(QDataStream::Qt_5_10);
    for (;;) {
        if (!m_nNextBlockSize) {
            if (socket->bytesAvailable() < sizeof(quint16)) { break; }
            in >> m_nNextBlockSize;
        }

        if (socket->bytesAvailable() < m_nNextBlockSize) { break; }

        QString str; in >> str;

        if (str == "0") {
            str = "Connection closed";
            closeConnection();
        }

        emit hasReadSome(str);
        m_nNextBlockSize = 0;
    }*/
}

void clientSocket::closeConnection()
{
    timeoutTimer->stop();

    //qDebug() << tcpSocket->state();
    disconnect(socket, &QTcpSocket::connected, 0, 0);
    disconnect(socket, &QTcpSocket::readyRead, 0, 0);

    bool shouldEmit = false;
    switch (socket->state()) {
        case 0:
            socket->disconnectFromHost();
            shouldEmit = true;
            break;
        case 2:
            socket->abort();
            shouldEmit = true;
            break;
        default:
            socket->abort();
    }

    if (shouldEmit) {
        status = false;
        emit statusChanged(status);
    }
}




