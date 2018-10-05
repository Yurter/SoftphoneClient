#include "QmlSpMessage.h"
#include "Logger.h"
#include <QGuiApplication>

QmlSpMessage::QmlSpMessage()
{

}

QmlSpMessage::QmlSpMessage(SpMessage *message) :
    SpMessage(message)
{

}

int QmlSpMessage::getSenderId()
{
    return mSenderId;
}

void QmlSpMessage::setSenderId(const int &i)
{
    mSenderId = i;
}

int QmlSpMessage::getConversationId()
{
    return mConversationId;
}

void QmlSpMessage::setConversationId(const int &i)
{
    mConversationId = i;
}

QDateTime QmlSpMessage::getDateTime()
{
    return mDateTime;
}

void QmlSpMessage::setDateTime(const QDateTime &d)
{
    mDateTime = d;
    emit dateTimeChanged();
}

QString QmlSpMessage::getTime()
{
    return mDateTime.time().toString();
}

void QmlSpMessage::setTime(const QString &t)
{

}

QString QmlSpMessage::getTextMessage()
{
    return mPayload.mTextMessage;
}

void QmlSpMessage::setTextMessage(const QString &p)
{
    mPayload.mTextMessage = p;
    emit textMessageChanged();
}

QList<QString> QmlSpMessage::getImagesUrl()
{
    QList<QString> list;
    int index = 0;

    foreach (auto img, mPayload.mPictures) {
        QString pathToFile = PATTERN_IMAGE_PATH(mDateTime.toTime_t(), index);
        QFile file(pathToFile);
        if (!file.open(QIODevice::WriteOnly)) {
            ERROR_LOG("Невозможно открыть файл: " + file.fileName());
            return list;
        }

        file.close();
        if (!img.save(pathToFile)) {
            ERROR_LOG("Невозможно сохранить изображение в файл: " + file.fileName());
            return list;
        }

        list.append(pathToFile);
        index++;
    }

    return list;
}

void QmlSpMessage::setImagesUrl(const QList<QString> &u)
{
    //
}

bool QmlSpMessage::getIsMine()
{
    return isMine;
}

void QmlSpMessage::setIsMinel(const bool &i)
{
    isMine = i;
    emit isMineChanged();
}

QString QmlSpMessage::getSenderName()
{
    return senderName;
}

void QmlSpMessage::setSenderName(const QString &s)
{
    senderName = s;
}

QString QmlSpMessage::getSenderAvatar()
{
    return senderAvatarUrl;
}

void QmlSpMessage::setSenderAvatar(const QString &a)
{
    //
}
