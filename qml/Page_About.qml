import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.0
import QtQuick.Window 2.12
import QtGraphicalEffects 1.12
import "custom"
import AppDefs 1.0
import "../js/datetimeutility.js" as DateTimeUtils

Item
{
    id: page_About

    signal sigClosing()
    signal sigClosed()

    function handleBackKeyEvent()
    {
        if (limitationDialog.visible === true)
        {
            limitationDialog.showDialog(false)

            return true
        }
        else if (cloudCommWaitDialog.visible === true)
        {
            cloudCommWaitDialog.showDialog(false, "", '')

            return true
        }
        else
            return false
    }

    function showPage(vis)
    {
        showPageAnimation.stop()

        if (vis === true)
            showPageAnimation.to = 0
        else
            showPageAnimation.to = page_About.height

        showPageAnimation.start()
    }

    function getAppType()
    {
        if (app.global_APP_TYPE === AppDefs.UStatus_Enabled && app.global_FULLFEATURES === true)
            return qsTr("Registered")
        else if (app.global_APP_TYPE === AppDefs.UStatus_Enabled)
            return qsTr("Limited")
        else if (app.global_APP_TYPE === AppDefs.UStatus_EnabledPro)
            return qsTr("Pro")
        else
            return qsTr("Blocked")
    }

    NumberAnimation
    {
        id: showPageAnimation
        target: rectContainerShadow
        property: "anchors.topMargin"
        duration: 200
        easing.type: Easing.OutCubic
        onStarted: page_About.visible = true
        onFinished:
        {
            if (rectContainerShadow.anchors.topMargin > 0 && page_About.visible === true)
            {
                page_About.visible = false
                sigClosed()
            }
        }
    }

    Rectangle
    {
        id: rectContainerShadow
        anchors.top: parent.top
        anchors.topMargin: page_About.height
        anchors.left: parent.left
        anchors.right: parent.right
        height: page_About.height
        color: AppTheme.whiteColor
    }

    DropShadow
    {
        anchors.fill: rectContainerShadow
        horizontalOffset: 0
        verticalOffset: -AppTheme.shadowOffset
        radius: AppTheme.shadowSize
        samples: AppTheme.shadowSamples
        color: AppTheme.shadowColor
        source: rectContainerShadow
    }

    Rectangle
    {
        id: rectContainer
        anchors.fill: rectContainerShadow
        color: AppTheme.whiteColor

        MouseArea { anchors.fill: parent }

        Image
        {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: AppTheme.padding
            width: parent.width
            height: width * 0.75
            source: "qrc:/resources/img/back_waves.png"
            opacity: 0.3
        }

        Rectangle
        {
            id: rectTankInfo
            anchors.fill: parent
            anchors.leftMargin: AppTheme.padding
            anchors.rightMargin: AppTheme.padding
            color: "#00000000"

            IconSimpleButton
            {
                id: imgArrowBack
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: AppTheme.padding
                image: "qrc:/resources/img/icon_arrow_left.png"

                onSigButtonClicked:
                {
                    showPage(false)
                    sigClosing()
                }
            }

            Text
            {
                id: textHeader
                anchors.verticalCenter: imgArrowBack.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignBottom
                font.family: AppTheme.fontFamily
                font.pixelSize: AppTheme.fontBigSize
                color: AppTheme.blueColor
                text: qsTr("ABOUT")
            }

            Image
            {
                anchors.top: parent.top
                anchors.topMargin: AppTheme.rowHeight
                anchors.horizontalCenter: parent.horizontalCenter
                width: AppTheme.rowHeight * 2
                height: width
                source: "qrc:/resources/img/icon.png"
                mipmap: true
            }

            Column
            {
                anchors.top: parent.top
                anchors.topMargin: AppTheme.rowHeight * 3
                anchors.left: parent.left
                anchors.right: parent.right

                Text
                {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignBottom
                    width: parent.width
                    height: AppTheme.rowHeightMin/2
                    font.family: AppTheme.fontFamily
                    font.pixelSize: AppTheme.fontNormalSize
                    color: AppTheme.blueColor
                    text: app.global_APP_NAME
                }

                Text
                {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignBottom
                    width: parent.width
                    height: AppTheme.rowHeightMin/2
                    font.family: AppTheme.fontFamily
                    font.pixelSize: AppTheme.fontSmallSize
                    color: AppTheme.blueColor
                    wrapMode: Text.WordWrap
                    text: app.global_APP_DOMAIN
                }

                Text
                {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignBottom
                    width: parent.width
                    height: AppTheme.rowHeightMin/2
                    font.family: AppTheme.fontFamily
                    font.pixelSize: AppTheme.fontSmallSize
                    color: AppTheme.greyColor
                    wrapMode: Text.WordWrap
                    text: qsTr("Application version") + ":" + " " + getAppVersion(app.global_APP_VERSION)
                }

                Text
                {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignBottom
                    width: parent.width
                    height: AppTheme.rowHeightMin/2
                    font.family: AppTheme.fontFamily
                    font.pixelSize: AppTheme.fontSmallSize
                    color: AppTheme.greyColor
                    wrapMode: Text.WordWrap
                    text: qsTr("Application type") + ":" + " " + getAppType()
                }

                Rectangle
                {
                    width: 1
                    height: AppTheme.rowSpacing
                }

                Text
                {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignBottom
                    width: parent.width
                    height: AppTheme.rowHeightMin/2
                    font.family: AppTheme.fontFamily
                    font.pixelSize: AppTheme.fontSmallSize
                    font.underline: true
                    color: AppTheme.blueFontColor
                    wrapMode: Text.WordWrap
                    text: qsTr("Visit our website")

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: Qt.openUrlExternally("https://aquariumstory.tikava.by")
                    }
                }
            }


            Rectangle
            {
                anchors.top: parent.top
                anchors.topMargin: AppTheme.rowHeight * 2
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: AppTheme.margin
                color: "#00000000"
                opacity: (app.isFullFunctionality() === true) ? 0 : 1
                visible: !(opacity === 0)

                Text
                {
                    id: textWarning
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: AppTheme.compHeight / 2
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: AppTheme.fontFamily
                    font.pixelSize: AppTheme.fontSmallSize
                    color: AppTheme.greyColor
                    wrapMode: Text.WordWrap
                    text: qsTr("This is a limited version of application.<br> To get a full version of application please buy <b>Aquarium Story Pro</b> or register (by pressing button below).")
                }

                Text
                {
                    anchors.top: textWarning.bottom
                    anchors.topMargin: AppTheme.rowHeightMin
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    height: AppTheme.compHeight / 2
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: AppTheme.fontFamily
                    font.pixelSize: AppTheme.fontSmallSize
                    font.underline: true
                    color: AppTheme.blueColor
                    wrapMode: Text.WordWrap
                    text: qsTr("See limitations")

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: limitationDialog.showDialog(true)
                    }
                }

                IconSimpleButton
                {
                    id: registerApp
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    image: "qrc:/resources/img/icon_app_reg.png"

                    onSigButtonClicked:
                    {
                        cloudCommWaitDialog.showDialog(true,
                                              qsTr("Communicating with cloud"),
                                              qsTr("Please wait ... "))
                        app.sigRegisterApp()
                    }
                }
            }
        }
    }

    WaitDialog
    {
        id: cloudCommWaitDialog
        objectName: "cloudCommWaitDialog"
        visible: false
    }

    LimitationDialog
    {
        id: limitationDialog
        visible: false
    }
}
