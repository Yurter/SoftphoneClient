#ifndef QMLSPCLIENT_H
#define QMLSPCLIENT_H

#include "SpClient.h"
#include "QmlSpUser.h"
#include "QmlSpConversation.h"

class QmlSpClient : public SpClient
{
    Q_OBJECT
public:
    explicit QmlSpClient();
    explicit QmlSpClient(QObject *parent);
    QmlSpClient(const QmlSpClient &obj);

    void    init();

    Q_INVOKABLE void                    setServerAddress(QString address);
    Q_INVOKABLE void                    setServerPort(quint16 port);

    Q_INVOKABLE void                    signIn(QString login, QString password);
    Q_INVOKABLE void                    signUp(QmlSpUser* user, QString login, QString password);
    Q_INVOKABLE void                    startCheckEvents(int interval);

    Q_INVOKABLE void                    setStatus(int status);
    Q_INVOKABLE void                    sendMessage(SpMessage *message);
    Q_INVOKABLE void                    findUserByName(QString user);

    Q_INVOKABLE void                    addUserToFiends(QmlSpUser *user);
    Q_INVOKABLE void                    removeUserFromFriends(QmlSpUser *user);
    Q_INVOKABLE void                    blockUser(QmlSpUser *user);

    Q_INVOKABLE void                    requestFriendList();
    Q_INVOKABLE void                    requestConversationList();

    Q_INVOKABLE QmlSpUser*              currentUser();
    Q_INVOKABLE QList<QmlSpUser*>       friendList();
    Q_INVOKABLE QList<SpConversation>   conversationList();
    Q_INVOKABLE SpConversation          getConversation(int id);

    Q_INVOKABLE void                    infoLog(QString text);
    Q_INVOKABLE void                    debugLog(QString text);
    Q_INVOKABLE void                    errorLog(QString text);

signals:
    void    qmlFriedListUpdated(QList<QObject*> friendList);
    void    qmlSearchUserResultReceived(QList<QObject*> userList);
    void    qmlConversationListUpdated(QList<QObject*> conversationList);
    void    qmlConversationUpdate(QObject* conversation);

public slots:
    void    onFriendListUpdated(QList<SpUser> friendList);
    void    onSearchUserResultReceived(QList<SpUser> userList);
    void    onConversationListUpdated(QList<SpConversation> conversationList);
    void    onConversationUpdate(SpConversation conversation);
};

Q_DECLARE_METATYPE(QmlSpClient)

#endif // QMLSPCLIENT_H
