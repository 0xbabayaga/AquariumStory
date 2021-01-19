#include "AppDefs.h"
#include "cloudmanager.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonParseError>
#include <QCryptographicHash>
#include "security/md7.h"
#include "security/security.h"

CloudManager::CloudManager(QString id, QObject *parent) : QObject(parent)
{
    security = new Security(AppDef::MAN_ID_LENGTH, APP_KEY_SEED, APP_KEY_LENGTH);

    manId = id;
    man = new QNetworkAccessManager();
    tmt = new QTimer();
    tmt->stop();
    tmt->setSingleShot(true);
    tmt->setInterval(CLOUDMAN_RESPONSE_TMT);

    cloudUrl = QUrl(CLOUD_SERVICE_URL);

    connect(man, SIGNAL(finished(QNetworkReply*)), this, SLOT(onReplyReceived(QNetworkReply*)));
    connect(tmt, &QTimer::timeout, this, &CloudManager::onTimeout);
}

CloudManager::~CloudManager()
{
    if (man != nullptr)
        delete man;

    if (security != nullptr)
        delete security;
}

void CloudManager::request_getAppUpdates()
{
    man->get(QNetworkRequest(QUrl(CLOUD_SERVICE_VER_URL)));
    //tmt->start();
}

void CloudManager::request_registerApp(UserObj *user)
{
    QString md5;

    md5 = QString(security->getCloudKey(user->man_id.toStdString(), QString::number(user->date_create).toStdString()).c_str());

    QString jsonString = "{"
                         "\"method\": \"register\","
                         "\"uname\": \"" + user->uname + "\","
                         "\"email\": \"" + user->email + "\","
                         "\"upass\": \"" + user->upass + "\","
                         "\"manid\": \"" + user->man_id + "\","
                         "\"phone\": \"" + user->phone + "\","
                         "\"country\": \"" + user->country + "\","
                         "\"city\": \"" + user->city + "\","
                         "\"coor_lat\": " + QString::number(user->coor_lat) + ","
                         "\"coor_long\": " + QString::number(user->coor_long) + ","
                         "\"date_create\": " + QString::number(user->date_create) + ","
                         "\"date_edit\": " + QString::number(user->date_edit) + ","
                         "\"key\": \"" + md5 + "\""
                         "}";

    QByteArray json = jsonString.toLocal8Bit();
    QByteArray postDataSize = QByteArray::number(json.size());
    QNetworkRequest request(cloudUrl);

    qDebug() << "REQUEST: " << jsonString;

    request.setRawHeader("User-Agent", APP_ORG);
    request.setRawHeader("X-Custom-User-Agent", APP_NAME);
    request.setRawHeader("Content-Type", "application/json");
    request.setRawHeader("Content-Length", postDataSize);

    man->post(request, json);
    tmt->start();
}

void CloudManager::onReplyReceived(QNetworkReply *reply)
{
    QString md5 = "";
    QByteArray rsp;

    tmt->stop();

    if (reply->error() == QNetworkReply::NetworkError::NoError)
    {
        rsp = reply->readAll();

        QJsonParseError error;
        QJsonDocument jsonDoc = QJsonDocument::fromJson(QString(rsp).toUtf8(), &error);
        QJsonObject obj = jsonDoc.object();

        if (error.error != QJsonParseError::NoError)
        {
            qDebug() << "";
            qDebug() << rsp;
            qDebug().noquote() << "JSON ERROR = " << error.errorString() << "on char" << error.offset;
        }

        //qDebug() << rsp;

        if (obj["method"].isNull() == false)
        {
            if (obj["method"].toString() == "register")
            {
                if (obj["manid"].isNull() == false &&
                    obj["result"].isNull() == false &&
                    obj["key"].isNull() == false &&
                    obj["errortext"].isNull() == false)
                {
                    if (obj["result"].toInt() == CloudManager::ReponseError::NoError)
                    {
                        if (obj["manid"].toString() == manId &&
                            security->isKeyValid(obj["key"].toString().toLocal8Bit().data(), manId.toStdString()) == true)
                        {
                            emit response_registerApp(obj["result"].toInt(), obj["errortext"].toString(), manId, obj["key"].toString());
                        }
                        else
                            emit response_registerApp(CloudManager::ReponseError::Error_VerificationFailed, obj["errortext"].toString(), "", "");
                    }
                    else
                        emit response_registerApp(obj["result"].toInt(), obj["errortext"].toString(), "", "");
                }
                else
                    emit response_registerApp(CloudManager::ReponseError::Error_ProtocolError, obj["errortext"].toString(), "", "");
            }
            else if (obj["method"].toString() == "version")
            {
                if (obj["version"].isNull() == false &&
                    obj["releasedate"].isNull() == false)
                {
                    emit response_appUpdates(obj["version"].toInt(), obj["releasedate"].toInt());
                }
            }
            else
                emit response_registerApp(CloudManager::ReponseError::Error_ProtocolError, "", "", "");
        }
        else
            emit response_registerApp(CloudManager::ReponseError::Error_ProtocolError, "", "", "");
    }
    else
    {
        qDebug() << "REPLY ERROR = " << reply->errorString();
        emit response_registerApp(CloudManager::ReponseError::Error_CommunicationError, "", "", "");
    }


    //reply->deleteLater();
}

void CloudManager::onTimeout()
{
    tmt->stop();
    emit response_error((int)CloudManager::ReponseError::Error_Timeout, "");
}
