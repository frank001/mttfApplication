#ifndef CLIENTSOCKET_H
#define CLIENTSOCKET_H
#include <QTimer>
#include <QTcpSocket>


class clientSocket : public QObject
{
    Q_OBJECT

private:

    QTimer *timeoutTimer;

    QString host = "127.0.0.1";
    int port = 1337;
    bool status = false;
    quint16 m_nNextBlockSize;

private slots:
    void readyRead();
    void connected();
    void connectionTimeout();

public slots:
    void connectSocket();
    void closeConnection();

signals:
    void statusChanged(bool);
    void hasReadSome(QString msg);

public:
    QTcpSocket *socket;
    clientSocket();
    bool getStatus();

};


#endif // CLIENTSOCKET_H
