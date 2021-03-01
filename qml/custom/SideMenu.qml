import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import AppDefs 1.0
import "../"

Item
{
    id: sideMenu

    signal sigMenuSelected(int id)

    property bool en: false
    property bool isOpened: false
    property alias accountName: textAccountName.text
    property alias accountImage: imgAccount.source

    function showMenu(vis)
    {
        showAnimation.stop()
        hideAnimation.stop()

        if (vis === true)
        {
            showAnimation.start()
            isOpened = true
        }
        else
        {
            hideAnimation.start()
            isOpened = false
        }
    }

    ListModel
    {
        id: menuListModel

        ListElement {   name: qsTr("ACCOUNT");      index: AppDefs.Menu_Account;    en: true    }
        ListElement {   name: qsTr("TANKS");        index: AppDefs.Menu_TankInfo;   en: true    }
        ListElement {   name: qsTr("SETTINGS");     index: AppDefs.Menu_Settings;   en: true    }
        ListElement {   name: qsTr("ABOUT");        index: AppDefs.Menu_About;      en: true    }
    }

    SequentialAnimation
    {
        id: showAnimation

        onStarted:
        {
            shadowEffect.visible = true
            rectShadow.visible = true
        }

        NumberAnimation
        {
            target: rectShadow
            property: "opacity"
            from: 0
            to: 1
            duration: 200
        }

        NumberAnimation
        {
            target: rectShadow
            property: "anchors.leftMargin"
            from: -AppTheme.rowHeightMin
            to: -AppTheme.rightWidth
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    SequentialAnimation
    {
        id: hideAnimation

        onFinished:
        {
           shadowEffect.visible = false
           rectShadow.visible = false
        }

        NumberAnimation
        {
            target: rectShadow
            property: "anchors.leftMargin"
            from: -AppTheme.rightWidth
            to: -AppTheme.rowHeightMin
            duration: 200
            easing.type: Easing.InQuad
        }

        NumberAnimation
        {
            target: rectShadow
            property: "opacity"
            from: 1
            to: 0
            duration: 200
        }
    }

    Rectangle
    {
        id: rectBackground
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: rectShadow.left
        height: parent.height
        opacity: rectShadow.opacity
        visible: rectShadow.visible
        color: AppTheme.backLightBlueColor

        MouseArea
        {
            anchors.fill: parent
            onClicked: showMenu(false)
        }
    }

    Rectangle
    {
        id: rectShadow
        anchors.top: parent.top
        anchors.left: parent.right
        anchors.leftMargin: -AppTheme.rowHeightMin
        width: AppTheme.rightWidth
        height: parent.height
        color: AppTheme.whiteColor
        visible: false
    }

    DropShadow
    {
        id: shadowEffect
        anchors.fill: rectShadow
        horizontalOffset: -4
        verticalOffset: 0
        radius: AppTheme.shadowSize
        samples: AppTheme.shadowSamples
        color: AppTheme.shadowColor
        source: rectShadow
        opacity: rectShadow.opacity
        visible: false
    }

    Rectangle
    {
        anchors.fill: rectShadow
        color: AppTheme.whiteColor
        visible: rectShadow.visible
        opacity: rectShadow.opacity

        Rectangle
        {
            id: rectHeader
            anchors.top: parent.top
            anchors.left: parent.left
            height: parent.width
            width: parent.width

            Rectangle
            {
                id: rectAccountPhoto
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -AppTheme.padding
                width: AppTheme.margin * 3
                height: width
                radius: width / 2
                border.width: 2
                border.color: AppTheme.blueColor
                color: AppTheme.backLightBlueColor

                Image
                {
                    id: imgAccount
                    anchors.fill: parent
                    anchors.margins: 2
                    source: ""
                    mipmap: true
                    layer.enabled: true
                    layer.effect: OpacityMask
                    {
                        maskSource: imgTankMask
                    }
                }

                Rectangle
                {
                    id: imgTankMask
                    anchors.fill: parent
                    radius: height/2
                    visible: false
                }
            }

            Text
            {
                id: textAccountName
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: rectAccountPhoto.bottom
                anchors.topMargin: AppTheme.padding / 2
                height: AppTheme.compHeight
                verticalAlignment: Text.AlignBottom
                font.family: AppTheme.fontFamily
                font.pixelSize: AppTheme.fontNormalSize
                color: AppTheme.blueFontColor
                text: ""
            }

            Text
            {
                id: textLocation
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: (AppTheme.padding + AppTheme.padding / 4)  / 2
                anchors.top: textAccountName.bottom
                anchors.topMargin: AppTheme.padding/2
                height: AppTheme.compHeight / 2
                verticalAlignment: Text.AlignVCenter
                font.family: AppTheme.fontFamily
                font.pixelSize: AppTheme.fontSmallSize
                color: AppTheme.greyColor
                text: app.global_USERCOUNTRY + ", " + app.global_USERCITY
            }

            Image
            {
                id: imgLoc
                anchors.right: textLocation.left
                anchors.rightMargin: AppTheme.padding / 4
                anchors.verticalCenter: textLocation.verticalCenter
                width: AppTheme.padding
                height: width
                source: "qrc:/resources/img/icon_loc.png"
                mipmap: true
            }

            ColorOverlay
            {
                anchors.fill: imgLoc
                source: imgLoc
                color: AppTheme.blueColor
            }

            Rectangle
            {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                width: parent.width
                height: 2
                color: AppTheme.backLightBlueColor
            }
        }

        Rectangle
        {
            anchors.top: rectHeader.bottom
            anchors.topMargin: AppTheme.margin
            anchors.bottom: parent.bottom
            width: parent.width
            height: menuListModel.count * AppTheme.rowHeightMin

            ListView
            {
                anchors.fill: parent
                spacing: 0
                interactive: false
                model: menuListModel

                delegate: Rectangle
                {
                    id: rectCeil
                    width: parent.width
                    height: AppTheme.rowHeightMin
                    color: AppTheme.whiteColor

                    Behavior on color { ColorAnimation { duration: 200 }    }

                    Text
                    {
                        id: textMenu
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: AppTheme.padding * 5
                        anchors.right: parent.right
                        height: AppTheme.rowHeightMin
                        verticalAlignment: Text.AlignVCenter
                        font.family: AppTheme.fontFamily
                        font.pixelSize: AppTheme.fontNormalSize
                        color: AppTheme.blueFontColor
                        text: name
                    }

                    Image
                    {
                        id: buttonImage
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: textMenu.left
                        anchors.rightMargin: AppTheme.padding / 2
                        width: AppTheme.compHeight / 2
                        height: width
                        source: "qrc:/resources/img/icon_menu.png"
                        mipmap: true
                    }

                    ColorOverlay
                    {
                        anchors.fill: buttonImage
                        source: buttonImage
                        color: AppTheme.blueColor
                    }

                    SequentialAnimation
                    {
                        id: rectCeilAnimation

                        ScaleAnimator
                        {
                            target: rectCeil
                            from: 1
                            to: 0.95
                            easing.type: Easing.OutBack
                            duration: 100
                        }

                        ScaleAnimator
                        {
                            target: rectCeil
                            from: 0.95
                            to: 1
                            easing.type: Easing.OutBack
                            duration: 500
                        }
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onPressed:
                        {
                            rectCeilAnimation.start()
                            color = AppTheme.lightBlueColor
                        }
                        onReleased:
                        {
                            showMenu(false)
                            sigMenuSelected(index)
                            color = AppTheme.whiteColor
                        }
                    }
                }
            }
        }
    }

    Image
    {
        id: imgAppIcon
        anchors.left: rectShadow.left
        anchors.leftMargin: 12
        anchors.top: parent.top
        anchors.topMargin: 12
        fillMode: Image.PreserveAspectFit
        width: 24
        height: 24
        source: "qrc:/resources/img/icon_app.png"
        mipmap: true

        SequentialAnimation
        {
            id: imgAppAnimation

            ScaleAnimator
            {
                target: imgAppIcon
                from: 1
                to: 0.95
                easing.type: Easing.OutBack
                duration: 100
            }

            ScaleAnimator
            {
                target: imgAppIcon
                from: 0.95
                to: 1
                easing.type: Easing.OutBack
                duration: 500
            }
        }

        MouseArea
        {
            anchors.fill: parent
            enabled: sideMenu.en
            onPressed: imgAppAnimation.start()
            onReleased: showMenu(!isOpened)
        }
    }
}
