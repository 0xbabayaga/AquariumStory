#ifndef CLOUDMANAGER_H
#define CLOUDMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QTimer>
#include "dbobjects.h"
#include "security/security.h"

#define CLOUDMAN_RESPONSE_TMT   10000
#define CLOUD_SERVICE_URL       "https://aquariumstory.tikava.by/reg.php"
#define CLOUD_SERVICE_VER_URL   "https://aquariumstory.tikava.by/ver.php"

class CloudManager : public QObject
{
    Q_OBJECT
public:
    explicit CloudManager(QString id, QObject *parent = nullptr);
    ~CloudManager();

    friend class AppManager;

    enum ReponseError
    {
        NoError = 0,
        Error_Timeout = 1,
        Error_CommunicationError = 2,
        Error_ProtocolError = 3,
        Error_VerificationFailed = 4,
        Error_Specific = 5,
        Error_AlreadyRegistered = 6,
        Error_InternalServer = 7,
        Error_Undefined = 0xff
    };

public:
    void setUserId(QString id)  {  manId = id; }
    void request_registerApp(UserObj *user);
    void request_getAppUpdates();

signals:
    void response_registerApp(int error, QString errorText,  QString manId, QString key);
    void response_appUpdates(int version, int releasedate);
    void response_error(int error, QString errorText);

private slots:
    void onReplyReceived(QNetworkReply *reply);
    void onTimeout();

protected:
    Security              *security = nullptr;
    QNetworkAccessManager *man = nullptr;
    QUrl                  cloudUrl;
    QTimer                *tmt = nullptr;
    QString               manId;
};

#endif // CLOUDMANAGER_H
