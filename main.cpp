#include <QtGlobal>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSslSocket>
#include <QLocale>
#include <QDebug>
#include <QFile>
#include <QTextStream>

#include "c++/appmanager.h"
#include "c++/AppDefs.h"
#include "c++/version.h"

#ifdef Q_OS_ANDROID
#include <QAndroidService>
#include "c++/androidnotification.h"
#endif

#ifdef APP_FILE_LOG_EN
void myMessageHandler(QtMsgType type, const QMessageLogContext &ctx, const QString &msg)
{
    QString txt;

    if (type == QtDebugMsg)
    {
        switch (type)
        {
            case QtDebugMsg:    txt = QString("Debug: %1").arg(msg);    break;
            case QtWarningMsg:  txt = QString("Warning: %1").arg(msg);  break;
            case QtCriticalMsg: txt = QString("Critical: %1").arg(msg); break;
            case QtFatalMsg:	txt = QString("Fatal: %1").arg(msg);    break;
        }

#ifdef Q_OS_ANDROID
        QFile outFile(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/aquariumstory.log");
#else
        QFile outFile("aquariumstory.log");
#endif

        outFile.open(QIODevice::WriteOnly | QIODevice::Append);

        QTextStream ts(&outFile);
        ts << txt << endl;

        outFile.close();
    }
}
#endif



int main(int argc, char *argv[])
{
#ifdef QT_NO_DEBUG_OUTPUT
    qputenv("QT_LOGGING_RULES", "qml=false");
#endif

#ifdef APP_FILE_LOG_EN
    qInstallMessageHandler(myMessageHandler);
#endif

    QGuiApplication app(argc, argv);
    QStringList args = QCoreApplication::arguments();



    qDebug() << "App version = " << APP_VERSION;
    qDebug() << "Device supports OpenSSL: " << QSslSocket::supportsSsl();
    qDebug() << "Locale = " << QLocale::system().name().section(' ', 0, 0);

    if ((args.count() > 1) == false)
    {
        AppDef::declareQML();

        app.setOrganizationName(APP_ORG);
        app.setOrganizationDomain(APP_DOMAIN);
        app.setApplicationName(APP_NAME);

        QQmlApplicationEngine engine;
        const QUrl url(QStringLiteral("qrc:/main.qml"));
        QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                         &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);

        AppManager *appMan = new AppManager(&engine);

        Q_UNUSED(appMan)

        engine.load(url);

        return app.exec();
    }
    else
    {
        return app.exec();
    }
}
