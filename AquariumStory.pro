QT += qml
QT += quick
QT += sql
QT += core
QT += multimedia
QT += concurrent
android: QT += androidextras

CONFIG += c++11

DEFINES = QT_NO_DEBUG_OUTPUT
#DEFINES += APP_FILE_LOG_EN
#DEFINES += FULL_FEATURES_ENABLED

contains(DEFINES, FULL_FEATURES_ENABLED){
    version_p.commands = ..\AquariumStory\version_inc.bat
    version_p.depends = FORCE
    message("FULL_FEATURES_ENABLED")
}

!contains(DEFINES, FULL_FEATURES_ENABLED){
    version_p.commands = ..\AquariumStory\version_inc_limited.bat
    version_p.depends = FORCE
    message("LIMITED")
}

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

RESOURCES += qml.qrc

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml \
    qml/qmldir \

contains(DEFINES, FULL_FEATURES_ENABLED){
DISTFILES += \
    android/src/org/tikava/AquariumStory/AquariumStory.java \
    android/src/org/tikava/AquariumStory/AquariumStoryNotification.java \
    android/src/org/tikava/AquariumStory/Background.java
}

!contains(DEFINES, FULL_FEATURES_ENABLED){
DISTFILES += \
    android/src/org/tikava/AquariumStoryLimited/AquariumStory.java \
    android/src/org/tikava/AquariumStoryLimited/AquariumStoryNotification.java \
    android/src/org/tikava/AquariumStoryLimited/Background.java
}

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

android {
ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

HEADERS += \
    c++/androidnotification.h \

contains(ANDROID_ABIS, "armeabi-v7a") {
    message("Building ARMEABI-V7A")

    DESTDIR=../build/release-armeabi-v7a
    OBJECTS_DIR = ../build/release-armeabi-v7a.obj
    MOC_DIR = ../build/release-armeabi-v7a.moc
    RCC_DIR = ../build/release-armeabi-v7a.rcc
    UI_DIR = ../build/release-armeabi-v7a.ui


    ANDROID_EXTRA_LIBS = \
        #$$PWD/../../../Dev/android_openssl-master/Qt-5.12.4_5.13.0/arm/libcrypto.so \
        #$$PWD/../../../Dev/android_openssl-master/Qt-5.12.4_5.13.0/arm/libssl.so
        $$PWD/../../../Dev/android_openssl-master/latest/arm/libcrypto_1_1.so \
        $$PWD/../../../Dev/android_openssl-master/latest/arm/libssl_1_1.so
    }

contains(ANDROID_ABIS, "arm64-v8a") {
    message("Building ARM64-V8A")

    DESTDIR=../build/release-arm64-v8a

    ANDROID_EXTRA_LIBS = \
        #$$PWD/../../../Dev/android_openssl-master/Qt-5.15.2/arm64/libcrypto.so \
        #$$PWD/../../../Dev/android_openssl-master/Qt-5.15.2/arm64/libssl.so
        $$PWD/../../../Dev/android_openssl-master/latest/arm64/libcrypto_1_1.so \
        $$PWD/../../../Dev/android_openssl-master/latest/arm64/libssl_1_1.so
    }
}

TRANSLATIONS += \
    resources/langs/lang_en.ts \
    resources/langs/lang_ru.ts \
    resources/langs/lang_be.ts
