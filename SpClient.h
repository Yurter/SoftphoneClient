#ifndef SPCHAT_H
#define SPCHAT_H

#include <QTimer>
#include <QDebug>
#include <QQueue>
#include "SpTcpClientSocket.h"
#include "SpConversation.h"
#include "SpMessage.h"
#include "SpPackage.h"
#include "SpUser.h"

#define SERVER_ID       0
#define SOCKET_INTERVAL 10

class SpClient : public QThread
{
    Q_OBJECT
public:
    explicit SpClient(QObject *parent = nullptr);
    virtual ~SpClient();

    void                    setServerAddress(QHostAddress address);
    void                    setServerPort(quint16 port);

    void                    signIn(QString login, QString password);
    void                    signUp(SpUser user, QString login, QString password);
    void                    startCheckEvents(int interval);

    void                    setStatus(int status);
    void                    sendMessage(SpMessage message);
    void                    findUserByName(QString user);

    void                    addUserToFiends(SpUser user);
    void                    removeUserFromFriends(SpUser user);
    void                    blockUser(SpUser user);

    void                    requestFriendList();
    void                    requestConversationList();

    SpUser                  currentUser();
    QList<SpUser>           friendList();
    QList<SpConversation>   conversationList();
    SpConversation          getConversation(int id);

signals:
    void                    successSignIn();
    void                    failSignIn();
    void                    successSignUp();
    void                    failSignUpBadPassword();
    void                    failSignUpBadLogin();

    void                    searchUserResultReceived(QList<SpUser> friendList);

    void                    friendListUpdated(QList<SpUser> friendList);
    void                    conversationListUpdated(QList<SpConversation> conversationList);
    void                    conversationUpdate(SpConversation conversation);

    void                    dataAvalible(QByteArray data);

public slots:
    void                    onProcessTheData(QByteArray data);
    void                    onTimeout();
    void                    onReadyToSend();
    void                    onServerIsNotResponding();

protected:
    void                    run();

private:
    void                    sendPackage(SpPackage package);
    void                    parseMesages(QList<SpMessage> messages);

private:
    QTimer                 *mCheckingTimer;
    QHostAddress            mServerAddress;
    quint16                 mServerPort;
    SpTcpClientSocket      *mClientSocket;
    SpUser                  mCurrentUser;
    QList<SpUser>           mFriendList;
    QList<SpConversation>   mConversationList;
    SpPackage               mCheckingPackage;
    QQueue<SpPackage>       mPackageQueue;
};

#endif // SPCHAT_H
