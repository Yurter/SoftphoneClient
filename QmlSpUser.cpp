#include "QmlSpUser.h"
#include <QPair>
#include <QGuiApplication>
#include "Logger.h"

QmlSpUser::QmlSpUser()
{

}

QmlSpUser::QmlSpUser(SpUser *user) :
    SpUser(user)
{

}

int QmlSpUser::getId()
{
    return mId;
}

QString QmlSpUser::getName()
{
    return mName;
}

void QmlSpUser::setName(const QString &n)
{
    mName = n;
    emit nameChanged();
}

QString QmlSpUser::getEmail()
{
    return mEmail;
}

void QmlSpUser::setEmail(const QString &e)
{
    mEmail = e;
    emit emailChanged();
}

int QmlSpUser::getStatus()
{
    return mStatus;
}

void QmlSpUser::setStatus(const int &s)
{
    mStatus = s;
    emit statusChanged();
}

QString QmlSpUser::getAvatarUrl()
{
    QString pathToFile = PATTERN_AVATAR_PATH(mId);
    QFile file(pathToFile);

    if (!file.open(QIODevice::WriteOnly)) {
        ERROR_LOG("Невозможно открыть файл: " + file.fileName());
        return QString();
    }

    file.close();
    if (!mAvatar.save(pathToFile)) {
        ERROR_LOG("Невозможно сохранить изображение в файл: " + file.fileName());
        return QString();
    }

    return pathToFile;
}

void QmlSpUser::setAvatarUrl(const QString &u)
{
    QString path = u;
    path.remove("qrc");
    mAvatar = QImage(path).scaled(128, 128);
    emit avatarUrlChanged();
}

QVariantMap QmlSpUser::getRelationship()
{
    QVariantMap pair;
    pair.insert("first",  mRelatonship.first);
    pair.insert("second", mRelatonship.second);
    return pair;
}

void QmlSpUser::setRelationship(const QVariantMap &r)
{
    mRelatonship = QPair<int,int>(r.value("first").toInt(), r.value("second").toInt());
    emit relatonshipChanged();
}
