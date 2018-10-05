#ifndef QMLSPCONVERSATION_H
#define QMLSPCONVERSATION_H

#include "SpConversation.h"
#include "QmlSpUser.h"
#include "QmlSpMessage.h"

#define PATTERN_PICTURE_PATH(id) (QGuiApplication::applicationDirPath() + "/cache/picture_" + QString::number(id) + ".png")

class QmlSpConversation : public SpConversation
{
    Q_OBJECT
public:
    explicit QmlSpConversation();
    explicit QmlSpConversation(SpConversation *parent);

    Q_PROPERTY(int                  id                      READ getId)
    Q_PROPERTY(int                  creatorId               READ getCreatorId)
    Q_PROPERTY(QString              title                   READ getTitle                   WRITE setTitle                  NOTIFY titleChanged)
    Q_PROPERTY(QDateTime            createdAt               READ getCreatedAt)
    Q_PROPERTY(QDateTime            updatedAt               READ getUpdatedAt)
    Q_PROPERTY(int                  type                    READ getType)
    Q_PROPERTY(QList<QmlSpUser>     users                   READ getUsers                   WRITE setUsers                  NOTIFY usersChanged)
    Q_PROPERTY(QString              picture                 READ getPicture                 WRITE setPicture                NOTIFY pictureChanged)
    Q_PROPERTY(QList<QObject*>      messages                READ getMessages                WRITE setMessages               NOTIFY messagesChanged)
    Q_PROPERTY(int                  unreadMessagesCount     READ getUnreadMessagesCount     WRITE setUnreadMessagesCount    NOTIFY unreadMessagesCountChanged)

    int                     userId;

    int                     getId();

    int                     getCreatorId();

    QString                 getTitle();
    void                    setTitle(const QString &t);

    QDateTime               getCreatedAt();

    QDateTime               getUpdatedAt();

    int                     getType();

    QList<QmlSpUser>        getUsers();
    void                    setUsers(const QList<QmlSpUser> &u);

    QString                 getPicture();
    void                    setPicture(const QString &p);

    QList<QObject*>         getMessages();
    void                    setMessages(const QList<QObject*> &m);

    int                     getUnreadMessagesCount();
    void                    setUnreadMessagesCount(const int &u);

signals:
    void                    titleChanged();
    void                    usersChanged();
    void                    pictureChanged();
    void                    messagesChanged();
    void                    unreadMessagesCountChanged();
};

Q_DECLARE_METATYPE(QmlSpConversation)

#endif // QMLSPCONVERSATION_H
