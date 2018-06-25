#ifndef BACKEND_H
#define BACKEND_H
#include <QObject>
#include <QMetaEnum>
#include <QJsonDocument>
#include <QJsonObject>
#include "clientsocket.h"

class BackEnd : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool currentStatus READ getStatus NOTIFY statusChanged)
    Q_ENUMS(eResponse)

private:
    bool bInitialization = true;
    clientSocket *client;
    QJsonDocument jdConfig;
    QJsonDocument jdState;
    QJsonDocument jdPorts;

private slots:
    void Configuration();

public:
    explicit BackEnd(QObject *parent = nullptr);
    bool getStatus();
    enum eResponse { config, state, ports };
    QJsonObject joPorts;

signals:
    void statusChanged(QString newStatus);
    void someError(QString err);
    void someMessage(QByteArray msg);
    void stateChange(QByteArray data);
    void configChange(QByteArray data);
    void portInfo(QByteArray data);

public slots:
    void setStatus(bool newStatus);
    void receivedSomething(QByteArray msg);
    void gotError(QAbstractSocket::SocketError err);
    void sendClicked(QString raw);
    void sendClicked(QString command, QString value);
    void connectClicked();
    void disconnectClicked();



};

#endif // BACKEND_H
