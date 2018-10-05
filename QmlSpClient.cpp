#include "QmlSpClient.h"

QmlSpClient::QmlSpClient()
{
    init();
}

QmlSpClient::QmlSpClient(QObject *parent) :
    SpClient(parent)
{
    init();
}

QmlSpClient::QmlSpClient(const QmlSpClient &obj)
{
    init();
}

void QmlSpClient::init()
{
    connect(this, SIGNAL(conversationListUpdated(QList<SpConversation>)), this, SLOT(onConversationListUpdated(QList<SpConversation>)));
    connect(this, SIGNAL(searchUserResultReceived(QList<SpUser>)), this, SLOT(onSearchUserResultReceived(QList<SpUser>)));
    connect(this, SIGNAL(conversationUpdate(SpConversation)), this, SLOT(onConversationUpdate(SpConversation)));
    connect(this, SIGNAL(friendListUpdated(QList<SpUser>)), this, SLOT(onFriendListUpdated(QList<SpUser>)));
}

void QmlSpClient::setServerAddress(QString address)
{
    SpClient::setServerAddress(QHostAddress(address));
}

void QmlSpClient::setServerPort(quint16 port)
{
    SpClient::setServerPort(port);
}

void QmlSpClient::signIn(QString login, QString password)
{
    SpClient::signIn(login, password);
}

void QmlSpClient::signUp(QmlSpUser* user, QString login, QString password)
{
    SpClient::signUp(SpUser(user), login, password);
}

void QmlSpClient::startCheckEvents(int interval)
{
    SpClient::startCheckEvents(interval);
}

void QmlSpClient::setStatus(int status)
{
    SpClient::setStatus(status);
}

void QmlSpClient::sendMessage(SpMessage *message)
{
    SpClient::sendMessage(*message);
}

void QmlSpClient::findUserByName(QString user)
{
    SpClient::findUserByName(user);
}

void QmlSpClient::addUserToFiends(QmlSpUser *user)
{
    SpClient::addUserToFiends(*user);
}

void QmlSpClient::removeUserFromFriends(QmlSpUser *user)
{
    SpClient::removeUserFromFriends(*user);
}

void QmlSpClient::blockUser(QmlSpUser *user)
{
    SpClient::blockUser(*user);
}

void QmlSpClient::requestFriendList()
{
    SpClient::requestFriendList();
}

void QmlSpClient::requestConversationList()
{
    SpClient::requestConversationList();
}

QmlSpUser* QmlSpClient::currentUser()
{
    return (new QmlSpUser(new SpUser(SpClient::currentUser())));
}

QList<QmlSpUser*> QmlSpClient::friendList()
{
    QList<QmlSpUser*> qmlFriendList;
    foreach (auto user, SpClient::friendList())
        qmlFriendList.append(new QmlSpUser(&user));
    return qmlFriendList;
}

QList<SpConversation> QmlSpClient::conversationList()
{
    return SpClient::conversationList();
}

SpConversation QmlSpClient::getConversation(int id)
{
    return SpClient::getConversation(id);
}

void QmlSpClient::infoLog(QString text)
{
    INFO_LOG("[QML] " + text);
}

void QmlSpClient::debugLog(QString text)
{
    DEBUG_LOG("[QML] " + text);
}

void QmlSpClient::errorLog(QString text)
{
    ERROR_LOG("[QML] " + text);
}

void QmlSpClient::onFriendListUpdated(QList<SpUser> friendList)
{
    QList<QObject*> qmlFriendList;
    foreach (auto user, friendList)
        qmlFriendList.append(new QmlSpUser(&user));
    emit qmlFriedListUpdated(qmlFriendList);
}

void QmlSpClient::onSearchUserResultReceived(QList<SpUser> friendList)
{
    QList<QObject*> qmlUserList;
    foreach (auto user, friendList)
        qmlUserList.append(new QmlSpUser(&user));
    emit qmlSearchUserResultReceived(qmlUserList);
}

void QmlSpClient::onConversationListUpdated(QList<SpConversation> conversationList)
{
    QList<QObject*> qmlConversationList;
    foreach (auto conv, conversationList) {
        if (conv.mType == SpConversation::Dialog) {
            if (conv.mUsers.size() == 2) {
                const SpUser &userOne = conv.mUsers.at(0);
                const SpUser &userTwo = conv.mUsers.at(1);
                if (SpClient::currentUser().mName == userOne.mName) {
                    conv.mTitle = userTwo.mName;
                    conv.mPicture = userTwo.mAvatar;
                } else {
                    conv.mTitle = userOne.mName;
                    conv.mPicture = userOne.mAvatar;
                }
            }
        }
        QmlSpConversation *qmlConv = new QmlSpConversation(&conv);
        qmlConv->userId = SpClient::currentUser().mId;
        qmlConversationList.append(qmlConv);
    }
    emit qmlConversationListUpdated(qmlConversationList);
}

void QmlSpClient::onConversationUpdate(SpConversation conversation)
{
    if (conversation.mType == SpConversation::Dialog) {
        if (conversation.mUsers.size() == 2) {
            const SpUser &userOne = conversation.mUsers.at(0);
            const SpUser &userTwo = conversation.mUsers.at(1);
            if (SpClient::currentUser().mName == userOne.mName) {
                conversation.mTitle = userTwo.mName;
                conversation.mPicture = userTwo.mAvatar;
            } else {
                conversation.mTitle = userOne.mName;
                conversation.mPicture = userOne.mAvatar;
            }
        }
    }
    QmlSpConversation *qmlConv = new QmlSpConversation(&conversation);
    qmlConv->userId = SpClient::currentUser().mId;

    emit qmlConversationUpdate(qmlConv);
}
