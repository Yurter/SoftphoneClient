#include "SpClient.h"

#include <QDir>
#include <QGuiApplication>

SpClient::SpClient(QObject *parent) :
    QThread(parent)
{
    DEBUG_LOG("Создан объект класса SpClient.");
    QDir().mkdir(QGuiApplication::applicationDirPath() + "/cache");
    mCheckingPackage.mType = SpPackage::CHECK_FOR_EVENTS;
}

void SpClient::setServerAddress(QHostAddress address)
{
    DEBUG_LOG("Установлен адрес сервера: " + address.toString());
    mServerAddress = address;
}

void SpClient::setServerPort(quint16 port)
{
    DEBUG_LOG("Установлен порт сервера: " + QString::number(port));
    mServerPort = port;
}

void SpClient::signIn(QString login, QString password)
{
    SpPackage package;
    package.mType = SpPackage::SIGN_IN;
    SpPackage::SignInData data(login, password);
    package.mTrunk.append(data.toByteArray());
    sendPackage(package);
}

void SpClient::signUp(SpUser user, QString login, QString password)
{
    SpPackage package;
    package.mType = SpPackage::SIGN_UP;
    SpPackage::SignUpData data(login, password, user.toByteArray());
    package.mTrunk.append(data.toByteArray());
    sendPackage(package);
}

void SpClient::sendMessage(SpMessage message)
{
    message.mDateTime = QDateTime::currentDateTime();

    SpPackage package;
    package.mType = SpPackage::MESSAGE;
    package.mTrunk.append(message.toByteArray());
    sendPackage(package);
}

void SpClient::findUserByName(QString user)
{
    if (!user.isEmpty()) {
        SpPackage package;
        package.mType = SpPackage::FIND_USER_BY_NAME;
        SpPackage::UserSearchData data(user, mCurrentUser.mId);
        package.mTrunk.append(data.toByteArray());
        sendPackage(package);
    }
}

void SpClient::addUserToFiends(SpUser user)
{
    SpPackage package;
    package.mType = SpPackage::ADD_TO_FRIENDS;
    package.mTrunk.append(QByteArray::number(user.mId));
    sendPackage(package);
}

void SpClient::removeUserFromFriends(SpUser user)
{
    SpPackage package;
    package.mType = SpPackage::REMOVE_FROM_FRIENDS;
    package.mTrunk.append(QByteArray::number(user.mId));
    sendPackage(package);
}

void SpClient::blockUser(SpUser user)
{
    SpPackage package;
    package.mType = SpPackage::BLOCK_USER;
    package.mTrunk.append(QByteArray::number(user.mId));
    sendPackage(package);
}

void SpClient::requestFriendList()
{
    SpPackage package;
    package.mType = SpPackage::REQUEST_FRIEND_LIST;
    sendPackage(package);
}

void SpClient::requestConversationList()
{
    SpPackage package;
    package.mType = SpPackage::REQUEST_CONVERSATION_LIST;
    sendPackage(package);
}

SpUser SpClient::currentUser()
{
    return mCurrentUser;
}

QList<SpUser> SpClient::friendList()
{
    return mFriendList;
}

QList<SpConversation> SpClient::conversationList()
{
    return mConversationList;
}

SpConversation SpClient::getConversation(int id)
{
    return SpConversation();
}

void SpClient::startCheckEvents(int interval)
{
    mCheckingTimer = new QTimer(this);
    connect(mCheckingTimer, SIGNAL(timeout()), this, SLOT(onTimeout()));
    mCheckingTimer->setInterval(interval);
    mCheckingTimer->start();
}

void SpClient::setStatus(int status)
{
    SpPackage package;
    package.mSenderId = mCurrentUser.mId;
    package.mType = SpPackage::STATUS_CHANGED;
    package.mTrunk.append(QByteArray::number(status));
    sendPackage(package);
}

void SpClient::onProcessTheData(QByteArray data)
{
    SpPackage package(data);

    if (!package.isValide()) {
        ERROR_LOG("[Клиент] Получен невалидный пакет с типом " + QString::number(package.mType));
        return;
    }

    if (!package.isThisForMe(mCurrentUser.mId)) {
        ERROR_LOG("[Клиент] Сервер ошибочно прислал пакет другого пользователя.");
        return;
    }

    switch (package.mType) {
    case SpPackage::SUCCESS_SIGN_IN: {
        mCurrentUser = SpUser(package.mTrunk.at(0));
        if (!mCurrentUser.isValid()) {
            ERROR_LOG("[Клиент] После попытки входа от сервера пришла невалидная информация о пользователе.");
            emit failSignIn();
        } else {
            emit successSignIn();
        }
    }
        break;
    case SpPackage::FAIL_SIGN_IN: {
        emit failSignIn();
    }
        break;
    case SpPackage::SUCCESS_SIGN_UP: {
        emit successSignUp();
    }
        break;
    case SpPackage::FAIL_SIGN_UP_BAD_LOGIN: {
        emit failSignUpBadLogin();
    }
        break;
    case SpPackage::FAIL_SIGN_UP_BAD_PASSWORD: {
        emit failSignUpBadPassword();
    }
        break;
    case SpPackage::NEW_MESSAGE_LIST: {
        qInfo() << "NEW_MESSAGE_LIST";
        if (package.mTrunk.isEmpty()) {
            ERROR_LOG("[Клиент] От сервера пришел пустой список новых сообщений.");
        } else {
            QList<SpMessage> messageList;
            foreach (auto msg, package.mTrunk)
                messageList.append(SpMessage(msg));
            parseMesages(messageList);
        }
    }
        break;
    case SpPackage::USER_SEARCH_RESULT: {
        QList<SpUser> userList;
        foreach (auto user, package.mTrunk)
            userList.append(SpUser(user));
        emit searchUserResultReceived(userList);
    }
        break;
    case SpPackage::FRIEND_LIST: {
        QList<SpUser> friendList;
        foreach (auto mate, package.mTrunk)
            friendList.append(SpUser(mate));
        mFriendList = friendList;
        emit friendListUpdated(mFriendList);
    }
        break;
    case SpPackage::CONVERSATION_LIST: {
        QList<SpConversation> conversationList;
        foreach (auto chat, package.mTrunk)
            conversationList.append(SpConversation(chat));
        mConversationList = conversationList;
        emit conversationListUpdated(mConversationList);
    }
        break;
    case SpPackage::EMPTY:
        break;
    default:
        ERROR_LOG("[Клиент] Получен пакет с неизвестным типом " + QString::number(package.mType));
        break;
    }
}

SpClient::~SpClient()
{
    mCheckingTimer->deleteLater();
    setStatus(SpUser::Offline);
    QThread::msleep(50);
    mClientSocket->deleteLater();
    DEBUG_LOG("Уничтожен объект класса SpClient.");
    Logger::getInstance().closeLogFile();
}

void SpClient::onTimeout()
{
    sendPackage(mCheckingPackage);
}

void SpClient::onReadyToSend()
{
    while (mPackageQueue.isEmpty())
        QThread::msleep(SOCKET_INTERVAL);

    emit dataAvalible(mPackageQueue.dequeue().toByteArray());
}

void SpClient::onServerIsNotResponding()
{

}

void SpClient::run()
{
    mClientSocket = new SpTcpClientSocket(mServerAddress, mServerPort);
    connect(this, SIGNAL(dataAvalible(QByteArray)), mClientSocket, SLOT(onDataAvalible(QByteArray)));
    connect(mClientSocket, SIGNAL(readyToSend()), this, SLOT(onReadyToSend()), Qt::DirectConnection);
    connect(mClientSocket, SIGNAL(processTheData(QByteArray)), this, SLOT(onProcessTheData(QByteArray)));
    mClientSocket->start();
    exec();
}

void SpClient::sendPackage(SpPackage package)
{
    package.mSenderId = mCurrentUser.mId;
    package.mReceiverId = SERVER_ID;

    if (package.isValide())
        mPackageQueue.enqueue(package);
    else
        ERROR_LOG("[Клиент] Попытка отправки невалидного пакета с типом " + QString::number(package.mType));
}

void SpClient::parseMesages(QList<SpMessage> messages)
{
    foreach (auto msg, messages) {
        for (int i = 0; i < mConversationList.size(); ++i) {
            if (msg.mConversationId == mConversationList.at(i).mId) {
                mConversationList[i].addMessage(msg);
                emit conversationUpdate(mConversationList.at(i));
                break;
            }
        }
    }
}
