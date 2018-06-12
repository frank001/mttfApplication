#ifndef BACKEND_H
#define BACKEND_H
#include <QObject>
#include <QMetaEnum>
#include <QJsonDocument>
#include "clientsocket.h"

class BackEnd : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool currentStatus READ getStatus NOTIFY statusChanged)
    Q_ENUMS(eResponse)

public:
    explicit BackEnd(QObject *parent = nullptr);
    bool getStatus();
    enum eResponse { config, state };

signals:
    void statusChanged(QString newStatus);
    void someError(QString err);
    void someMessage(QByteArray msg);
    void stateChange(QByteArray data);
    void configChange(QByteArray data);

public slots:
    void setStatus(bool newStatus);
    void receivedSomething(QByteArray msg);
    void gotError(QAbstractSocket::SocketError err);
    void sendClicked(QString raw);
    void sendClicked(QString command, QString value);
    void connectClicked();
    void disconnectClicked();

private:
    clientSocket *client;
    QJsonDocument jdConfig;
    QJsonDocument jdState;

};

#endif // BACKEND_H
