#include "SpTcpClientSocket.h"
#include "SpPackage.h"

SpTcpClientSocket::SpTcpClientSocket(QHostAddress address, quint16 port, QObject *parent) :
    SpThreadTcpSocket(parent),
    mReceiverIp(address),
    mReceiverPort(port),
    mDataIsReady(false)
{
    DEBUG_LOG("Создан объект класса SpTcpClientSocket.");
    DEBUG_LOG("Значения address и port: " + address.toString() + " " + QString::number(port) + ".");
    mConnectionTimer.setSingleShot(true);
    connect(&mConnectionTimer, SIGNAL(timeout()), this, SLOT(onServerIsNotResponding()));
}

SpTcpClientSocket::~SpTcpClientSocket()
{
    DEBUG_LOG("Уничтожен объект класса SpTcpClientSocket.");
    quit();
}

void SpTcpClientSocket::run()
{
    DEBUG_LOG("[Сокет] Сокет запущен и готов к отправке данных.");
    emit readyToSend();
    exec();
}

void SpTcpClientSocket::onDataAvalible(QByteArray data)
{
    QString log;
    mData = data;
    mTcpSocket = new QTcpSocket();
    mTcpSocket->connectToHost(mReceiverIp, mReceiverPort);
    connect(mTcpSocket, SIGNAL(connected()), this, SLOT(onConnected()), Qt::DirectConnection);
    connect(mTcpSocket, SIGNAL(disconnected()), this, SLOT(onDisconnected()));
    mConnectionTimer.start(DEFAULT_WAITING_TIME);
}

void SpTcpClientSocket::onConnected()
{
    mConnectionTimer.stop();
    DEBUG_LOG("[Сокет] Соединение установлено. Для отправки подготовленно " + QString::number(mData.size()) + " байт.");
    qint64 byteCount = mTcpSocket->write(mData);
    DEBUG_LOG("[Сокет] В сокет записано байт: " + QString::number(byteCount));
    bool bytesWritten = mTcpSocket->waitForBytesWritten(DEFAULT_WAITING_TIME);
    if (!bytesWritten) {
        ERROR_LOG("[Сокет] Истекло время на запись данных в сокет.");
        ERROR_LOG("[Сокет] Разрыв соединения.");
        mTcpSocket->close();
        ERROR_LOG("[Сокет] Отброс пакета и ожидание нового.");
        mData.clear();
        emit readyToSend();
    } else {
        mData.clear();
        while (mTcpSocket->waitForReadyRead(DEFAULT_WAITING_TIME))
            while(mTcpSocket->bytesAvailable() > 0)
                mData.append(mTcpSocket->readAll());
        DEBUG_LOG("[Сокет] Из сокета прочитано байт: " + QString::number(mData.size()));
    }
}

void SpTcpClientSocket::onDisconnected()
{
    DEBUG_LOG("[Сокет] Соединение разорвано.");
    mTcpSocket->deleteLater();
    emit processTheData(mData);
    emit readyToSend();
}

void SpTcpClientSocket::onServerIsNotResponding()
{
    ERROR_LOG("[Сокет] Сервер недоступен.");
    ERROR_LOG("[Сокет] Отброс пакета и ожидание нового.");
    mData.clear();
    emit serverIsNotResponding();
    emit readyToSend();
}
