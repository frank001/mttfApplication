#ifndef BACKEND_H
#define BACKEND_H
#include <QObject>
#include "clientsocket.h"

class BackEnd : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool currentStatus READ getStatus NOTIFY statusChanged)

public:
    explicit BackEnd(QObject *parent = nullptr);
    bool getStatus();

signals:
    void statusChanged(QString newStatus);
    void someError(QString err);
    void someMessage(QString msg);

public slots:
    void setStatus(bool newStatus);
    void receivedSomething(QString msg);
    void gotError(QAbstractSocket::SocketError err);
    void sendClicked(QString raw);
    void sendClicked(QString command, QString value);
    void connectClicked();
    void disconnectClicked();

private:
    clientSocket *client;

};

#endif // BACKEND_H
