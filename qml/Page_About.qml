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
        verticalOffset: -AppTheme.shadowOffset * app.scale
        radius: AppTheme.shadowSize * app.scale
        samples: AppTheme.shadowSamples * app.scale
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
            anchors.topMargin: AppTheme.padding * app.scale
            width: parent.width
            height: width * 0.75
            source: "qrc:/resources/img/back_waves.png"
            opacity: 0.3
        }

        Rectangle
        {
            id: rectTankInfo
            anchors.fill: parent
            anchors.leftMargin: AppTheme.padding * app.scale
            anchors.rightMargin: AppTheme.padding * app.scale
            color: "#00000000"

            IconSimpleButton
            {
                id: imgArrowBack
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: AppTheme.padding * app.scale
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
                font.pixelSize: AppTheme.fontBigSize * app.scale
                color: AppTheme.blueColor
                text: qsTr("ABOUT")
            }

            Image
            {
                anchors.top: parent.top
                anchors.topMargin: AppTheme.rowHeight * app.scale
                anchors.horizontalCenter: parent.horizontalCenter
                width: AppTheme.rowHeight * 2 * app.scale
                height: width
                source: "qrc:/resources/img/icon.png"
                mipmap: true
            }

            Column
            {
                anchors.top: parent.top
                anchors.topMargin: AppTheme.rowHeight * 3 * app.scale
                anchors.left: parent.left
                anchors.right: parent.right

                Text
                {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignBottom
                    width: parent.width
                    height: AppTheme.rowHeightMin/2 * app.scale
                    font.family: AppTheme.fontFamily
                    font.pixelSize: AppTheme.fontNormalSize * app.scale
                    color: AppTheme.blueColor
                    text: app.global_APP_NAME
                }

                Text
                {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignBottom
                    width: parent.width
                    height: AppTheme.rowHeightMin/2 * app.scale
                    font.family: AppTheme.fontFamily
                    font.pixelSize: AppTheme.fontSmallSize * app.scale
                    color: AppTheme.blueColor
                    wrapMode: Text.WordWrap
                    text: "www.aquariumstory.tikava.by"

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: Qt.openUrlExternally("https://aquariumstory.tikava.by")
                    }
                }

                Text
                {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignBottom
                    width: parent.width
                    height: AppTheme.rowHeightMin/2 * app.scale
                    font.family: AppTheme.fontFamily
                    font.pixelSize: AppTheme.fontSmallSize * app.scale
                    color: AppTheme.greyColor
                    wrapMode: Text.WordWrap
                    text: qsTr("Application version") + ":" + " " + getAppVersion(app.global_APP_VERSION)
                }

                Text
                {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignBottom
                    width: parent.width
                    height: AppTheme.rowHeightMin/2 * app.scale
                    font.family: AppTheme.fontFamily
                    font.pixelSize: AppTheme.fontSmallSize * app.scale
                    color: AppTheme.greyColor
                    wrapMode: Text.WordWrap
                    text: qsTr("Application type") + ":" + " " + getAppType() + " (<font color='"+AppTheme.blueFontColor+"'>" + qsTr("see limitations") + "</font>)"

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: limitationDialog.showDialog(true)
                    }
                }

                Text
                {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignBottom
                    width: parent.width
                    height: AppTheme.rowHeightMin/2 * app.scale
                    font.family: AppTheme.fontFamily
                    font.pixelSize: AppTheme.fontSmallSize * app.scale
                    color: AppTheme.greyColor
                    wrapMode: Text.WordWrap
                    text: qsTr("Follow us in Telegram") + ":" + " (<font color='"+AppTheme.blueFontColor+"'>t.me/aquariumstory</font>)"

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: Qt.openUrlExternally("http://t.me/aquariumstory")
                    }
                }
            }


            Rectangle
            {
                anchors.top: parent.top
                anchors.topMargin: AppTheme.rowHeight * 2 * app.scale
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: AppTheme.margin * app.scale
                color: "#00000000"
                opacity: (app.isFullFunctionality() === true) ? 0 : 1
                visible: !(opacity === 0)

                Text
                {
                    id: textWarning1
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: AppTheme.fontFamily
                    font.pixelSize: AppTheme.fontSmallSize * app.scale
                    color: AppTheme.greyColor
                    wrapMode: Text.WordWrap
                    text: qsTr("This is a limited version of application.<br> To get a full version please install") + "<br>" + "<font color='"+AppTheme.blueFontColor+"'><u>" + "Aquarium Story PRO" + "</u></font><br><br>"

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: Qt.openUrlExternally("https://play.google.com/store/apps/details?id=org.tikava.AquariumStory")
                    }
                }

                Text
                {
                    id: textWarning2
                    anchors.top: textWarning1.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: AppTheme.fontFamily
                    font.pixelSize: AppTheme.fontSmallSize * app.scale
                    color: AppTheme.greyColor
                    wrapMode: Text.WordWrap
                    text: qsTr("Also you can") + "<font color='" + AppTheme.blueFontColor + "'> <u>" + qsTr("register") + "</u></font> " + qsTr("this application to remove limitations (available registration count is limited)") +"."

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
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
