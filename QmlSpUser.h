#ifndef QMLSPUSER_H
#define QMLSPUSER_H

#include "SpUser.h"

#define PATTERN_AVATAR_PATH(id) (QGuiApplication::applicationDirPath() + "/cache/avatar_" + QString::number(id) + ".png")

class QmlSpUser : public SpUser
{
    Q_OBJECT
public:
    explicit QmlSpUser();
    explicit QmlSpUser(SpUser *user);

    Q_PROPERTY(int          id           READ getId)
    Q_PROPERTY(QString      name         READ getName         WRITE setName         NOTIFY nameChanged)
    Q_PROPERTY(QString      email        READ getEmail        WRITE setEmail        NOTIFY emailChanged)
    Q_PROPERTY(int          status       READ getStatus       WRITE setStatus       NOTIFY statusChanged)
    Q_PROPERTY(QString      avatarUrl    READ getAvatarUrl    WRITE setAvatarUrl    NOTIFY avatarUrlChanged)
    Q_PROPERTY(QVariantMap  relationship READ getRelationship WRITE setRelationship NOTIFY relatonshipChanged)

    int             getId();

    QString         getName();
    void            setName(const QString &n);

    QString         getEmail();
    void            setEmail(const QString &e);

    int             getStatus();
    void            setStatus(const int &s);

    QString         getAvatarUrl();
    void            setAvatarUrl(const QString &u);

    QVariantMap     getRelationship();
    void            setRelationship(const QVariantMap &r);

signals:
    void            nameChanged();
    void            emailChanged();
    void            statusChanged();
    void            avatarUrlChanged();
    void            relatonshipChanged();
};

Q_DECLARE_METATYPE(QmlSpUser)

#endif // QMLSPUSER_H
