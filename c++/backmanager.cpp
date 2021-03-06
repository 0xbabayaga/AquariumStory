#include <QObject>
#include <QtSql>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QDateTime>
#include <QSqlError>
#include <QAndroidJniObject>
#include <QAndroidJniEnvironment>
#include <QtAndroid>
#include <QDebug>
#include "androidnotification.h"
#include "dbmanager.h"
#include <jni.h>

static void debugOut(QString message);
static void sendNotification(QString title, QString message);

#ifdef __cplusplus
extern "C" {
#endif

JNIEXPORT void JNICALL
#ifdef FULL_FEATURES_ENABLED
Java_org_tikava_AquariumStory_Background_callbackOnTimer(JNIEnv *env, jobject obj, jint cnt)
#else
Java_org_tikava_AquariumStoryLimited_Background_callbackOnTimer(JNIEnv *env, jobject obj, jint cnt)
#endif
{
    int i = 0;
    int n = 0;
    bool background = true;

    DBManager *dbMan = new DBManager(true);

    if (dbMan->openDB() == true)
    {
        if (dbMan->getCurrentUser(false) == true)
        {
            if (dbMan->currentSelectedObjs()->user != nullptr)
            {
                if (dbMan->getUserTanksList() == true)
                {
                    for (i = 0; i < dbMan->currentSelectedObjs()->listOfUserTanks.size(); i++)
                    {
                        QString tankId = ((TankObj*)(dbMan->currentSelectedObjs()->listOfUserTanks.at(i)))->tankId();
                        quint64 now = QDateTime::currentDateTime().toSecsSinceEpoch();

                        dbMan->getActionCalendar(tankId, background);

                        qDebug() << "size = " << QString::number(dbMan->currentActionList()->getData()->size());

                        for (n = 0; n < dbMan->currentActionList()->getData()->size(); n++)
                        {
                            ActionObj *act = (ActionObj*)(dbMan->currentActionList()->getData()->at(n));

                            if (act != 0)
                            {
                                if (act->startDT() >= (now - 30) && act->startDT() < (now + 30) )
                                {
                                    sendNotification(QObject::tr("Reminder"),
                                                     "\n" +
                                                     QObject::tr("Aquarium") + ": " + ((TankObj*)(dbMan->currentSelectedObjs()->listOfUserTanks.at(i)))->name() + "\n" +
                                                     QObject::tr("Time") + ": " + QDateTime::fromSecsSinceEpoch(act->startDT()).toString("dd-MMMM-yyyy hh:mm") + "\n" +
                                                     QObject::tr("Action") + ": " + act->name() + "\n" +
                                                     QObject::tr("Description") + ": " + act->desc()
                                                     );

                                }
                            }
                        }
                    }
                }
            }
        }
    }
    else
        qDebug() << "Cannot open DB from back";


    dbMan->closeDB();

    delete dbMan;
}

#ifdef __cplusplus
}
#endif


static void sendNotification(QString title, QString message)
{
    AndroidNotification *notify = new AndroidNotification();
    notify->setTitle(title);
    notify->setMessage(message);
    notify->updateAndroidNotification();
}


static void debugOut(QString message)
{
    AndroidNotification *notify = new AndroidNotification();
    notify->setTitle("DEBUG");
    notify->setMessage(message);
    notify->updateAndroidNotification();
}

