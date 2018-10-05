#include "SpThreadTcpSocket.h"

SpThreadTcpSocket::SpThreadTcpSocket(QObject *parent) :
    QThread(parent)
{

}

SpThreadTcpSocket::~SpThreadTcpSocket()
{
    mTcpSocket->deleteLater();
}

void SpThreadTcpSocket::onDisconnected()
{
    quit();
}
