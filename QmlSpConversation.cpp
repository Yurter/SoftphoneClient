#include "QmlSpConversation.h"
#include <QGuiApplication>
#include "Logger.h"

QmlSpConversation::QmlSpConversation()
{

}

QmlSpConversation::QmlSpConversation(SpConversation *parent) :
    SpConversation(parent)
{

}

int QmlSpConversation::getId()
{
    return mId;
}

int QmlSpConversation::getCreatorId()
{
    return mCreatorId;
}

QString QmlSpConversation::getTitle()
{
    return mTitle;
}

void QmlSpConversation::setTitle(const QString &t)
{
    mTitle = t;
}

QDateTime QmlSpConversation::getCreatedAt()
{
    return mCreatedAt;
}

QDateTime QmlSpConversation::getUpdatedAt()
{
    return mUpdatedAt;
}

int QmlSpConversation::getType()
{
    return mType;
}

QList<QmlSpUser> QmlSpConversation::getUsers()
{
    QList<QmlSpUser> qmlUsers;
    foreach (auto user, mUsers)
        qmlUsers.append(QmlSpUser(&user));
    return qmlUsers;
}

void QmlSpConversation::setUsers(const QList<QmlSpUser> &u)
{
    mUsers.clear();
    foreach (auto user, u)
        mUsers.append(user);
}

QString QmlSpConversation::getPicture()
{
    QString pathToFile = PATTERN_PICTURE_PATH(mId);
    QFile file(pathToFile);

    if (!file.open(QIODevice::WriteOnly)) {
        ERROR_LOG("Невозможно открыть файл: " + file.fileName());
        return QString();
    }

    file.close();
    if (!mPicture.save(pathToFile)) {
        ERROR_LOG("Невозможно сохранить изображение в файл: " + file.fileName());
        return QString();
    }

    return pathToFile;
}

void QmlSpConversation::setPicture(const QString &p)
{
    //
}

QList<QObject*> QmlSpConversation::getMessages()
{
    QList<QObject*> qmlMessages;
    foreach (auto msg, mMessages) {
        QmlSpMessage *qmlMsg = new QmlSpMessage(&msg);
        qmlMsg->isMine = (userId == msg.mSenderId);

        foreach (auto mate, getUsers()) {
            if (mate.mId == msg.mSenderId) {
                qmlMsg->senderName = mate.mName;
                qmlMsg->senderAvatarUrl = mate.getAvatarUrl();
                break;
            }
        }

        qmlMessages.append(qmlMsg);
    }
    return qmlMessages;
}

void QmlSpConversation::setMessages(const QList<QObject*> &m)
{
    //
}

int QmlSpConversation::getUnreadMessagesCount()
{
    return mUnreadMessagesCount;
}

void QmlSpConversation::setUnreadMessagesCount(const int &u)
{
    mUnreadMessagesCount = u;
}
