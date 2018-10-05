#ifndef SPTCPCLIENTSOCKET_H
#define SPTCPCLIENTSOCKET_H

#include <QTimer>
#include "SpThreadTcpSocket.h"
#include "Logger.h"

#define DEFAULT_WAITING_TIME 2000

class SpTcpClientSocket : public SpThreadTcpSocket
{
    Q_OBJECT
public:
    explicit SpTcpClientSocket(QHostAddress address, quint16 port, QObject *parent = nullptr);
    virtual ~SpTcpClientSocket();

signals:
    void            readyToSend();
    void            serverIsNotResponding();

protected:
    void            run();

public slots:
    void            onDataAvalible(QByteArray data);
    void            onConnected();
    void            onDisconnected();

private slots:
    void            onServerIsNotResponding();

private:
    QHostAddress    mReceiverIp;
    quint16         mReceiverPort;
    bool            mDataIsReady;
    QTimer          mConnectionTimer;
};

#endif // SPTCPCLIENTSOCKET_H
