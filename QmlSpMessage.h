#ifndef QMLSPMESSAGE_H
#define QMLSPMESSAGE_H

#include "SpMessage.h"

#define PATTERN_IMAGE_PATH(msgId,imgId) (QGuiApplication::applicationDirPath() + \
                                         "/cache/msg_" + QString::number(msgId) + \
                                         "_img_" + QString::number(imgId) + ".png")

class QmlSpMessage : public SpMessage
{
    Q_OBJECT
public:
    explicit QmlSpMessage();
    explicit QmlSpMessage(SpMessage *message);

    Q_PROPERTY(int              senderId            READ getSenderId            WRITE setSenderId           NOTIFY senderIdChanged)
    Q_PROPERTY(int              conversationId      READ getConversationId      WRITE setConversationId     NOTIFY conversationIdChanged)
    Q_PROPERTY(QDateTime        dateTime            READ getDateTime            WRITE setDateTime           NOTIFY dateTimeChanged)
    Q_PROPERTY(QString          time                READ getTime                WRITE setTime               NOTIFY timeChanged)
    Q_PROPERTY(QString          textMessage         READ getTextMessage         WRITE setTextMessage        NOTIFY textMessageChanged)
    Q_PROPERTY(QList<QString>   imagesUrl           READ getImagesUrl           WRITE setImagesUrl          NOTIFY imagesUrlChanged)
    Q_PROPERTY(bool             isMine              READ getIsMine              WRITE setIsMinel            NOTIFY isMineChanged)
    Q_PROPERTY(QString          senderName          READ getSenderName          WRITE setSenderName         NOTIFY senderNameChanged)
    Q_PROPERTY(QString          senderAvatar        READ getSenderAvatar        WRITE setSenderAvatar       NOTIFY senderAvatarChanged)

    bool isMine;
    QString senderName;
    QString senderAvatarUrl;

    int                     getSenderId();
    void                    setSenderId(const int &i);

    int                     getConversationId();
    void                    setConversationId(const int &i);

    QDateTime               getDateTime();
    void                    setDateTime(const QDateTime &d);

    QString                 getTime();
    void                    setTime(const QString &t);

    QString                 getTextMessage();
    void                    setTextMessage(const QString &p);

    QList<QString>          getImagesUrl();
    void                    setImagesUrl(const QList<QString> &u);

    bool                    getIsMine();
    void                    setIsMinel(const bool &i);

    QString                 getSenderName();
    void                    setSenderName(const QString &s);

    QString                 getSenderAvatar();
    void                    setSenderAvatar(const QString &a);

signals:
    void                    senderIdChanged();
    void                    conversationIdChanged();
    void                    dateTimeChanged();
    void                    timeChanged();
    void                    textMessageChanged();
    void                    imagesUrlChanged();
    void                    isMineChanged();
    void                    senderNameChanged();
    void                    senderAvatarChanged();
};

Q_DECLARE_METATYPE(QmlSpMessage)

#endif // QMLSPMESSAGE_H
