QT += qml
QT += quick
QT += sql
QT += core
QT += multimedia
QT += concurrent
android: QT += androidextras

CONFIG += c++11

DEFINES += QT_NO_DEBUG_OUTPUT

version_p.commands = ..\AquariumStory\version_inc.bat
version_p.depends = FORCE
QMAKE_EXTRA_TARGETS += version_p
PRE_TARGETDEPS += version_p

TARGET = AquariumStory
TEMPLATE = app

SOURCES += \
        c++/actionlist.cpp \
        c++/appmanager.cpp \
        c++/cloudmanager.cpp \
        c++/db_importexport.cpp \
        c++/dbmanager.cpp \
        c++/filemanager.cpp \
        c++/position.cpp \
        c++/security/md7.cpp \
        c++/security/security.cpp \
        main.cpp

android {
SOURCES += \
        c++/androidnotification.cpp \
        c++/backmanager.cpp
}

DEFINES += FULL_FEATURES_ENABLED

RESOURCES += qml.qrc

CONFIG += mobility

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml \
    android/src/org/tikava/AquariumStory/AquariumStory.java \
    android/src/org/tikava/AquariumStory/AquariumStoryNotification.java \
    android/src/org/tikava/AquariumStory/Background.java
    qml/qmldir \

HEADERS += \
    c++/AppDefs.h \
    c++/actionlist.h \
    c++/appmanager.h \
    c++/cloudmanager.h \
    c++/dbmanager.h \
    c++/dbobjects.h \
    c++/filemanager.h \
    c++/galleryobjects.h \
    c++/position.h \
    c++/security/md7.h \
    c++/security/security.h \
    c++/version.h

ANDROID_ABIS = armeabi-v7a
ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

android {
HEADERS += \
    c++/androidnotification.h \

ANDROID_EXTRA_LIBS = \
    $$PWD/../../../Dev/android_openssl-master/Qt-5.12.4_5.13.0/arm/libcrypto.so \
    $$PWD/../../../Dev/android_openssl-master/Qt-5.12.4_5.13.0/arm/libssl.so
}

TRANSLATIONS += \
    resources/langs/lang_en.ts \
    resources/langs/lang_ru.ts \
    resources/langs/lang_be.ts
