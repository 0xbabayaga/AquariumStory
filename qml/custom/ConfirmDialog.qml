import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import "../"

Item
{
    id: confirmDialog
    width: app.width
    height: app.height
    opacity: enabled ? AppTheme.opacityEnabled : AppTheme.opacityDisabled

    signal sigAccept()
    signal sigCancel()

    property var param: 0

    function setParam(p)
    {
        param = p
    }

    function getParam()
    {
        return param
    }

    function showDialog(vis, header, message)
    {
        rectContOpacityAnimation.stop()

        if (vis === true)
        {
            textHeader.text = header
            textMessage.text = message
            rectCont.visible = true
            confirmDialog.visible = true
            rectContOpacityAnimation.from = 0
            rectContOpacityAnimation.to = 1
        }
        else
        {
            rectContOpacityAnimation.from = 1
            rectContOpacityAnimation.to = 0
        }

        rectContOpacityAnimation.start()
    }

    Rectangle
    {
        id: rectCont
        anchors.fill: parent
        parent: Overlay.overlay
        focus: true
        clip: true
        visible: false
        color: "#00000000"

        MouseArea { anchors.fill: parent }

        NumberAnimation
        {
            id: rectContOpacityAnimation
            target: rectCont
            property: "opacity"
            duration: 300
            easing.type: Easing.InOutQuad
            from: 0
            to: 1

            onFinished:
            {
                if (to === 0)
                {
                    confirmDialog.visible = false
                    rectCont.visible = false
                }
            }
        }

        Rectangle
        {
            color: AppTheme.backHideColor
            anchors.fill: parent

            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - AppTheme.margin
                height: 240  - AppTheme.margin
                radius: AppTheme.radius / 2
                color: AppTheme.whiteColor

                Text
                {
                    id: textHeader
                    anchors.top: parent.top
                    anchors.topMargin: AppTheme.padding
                    height: AppTheme.compHeight
                    width: parent.width
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: AppTheme.fontFamily
                    font.pixelSize: AppTheme.fontNormalSize
                    color: AppTheme.blueFontColor
                    text: "TEXT"
                }

                Text
                {
                    id: textMessage
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: - AppTheme.padding
                    height: AppTheme.compHeight
                    width: parent.width - AppTheme.margin  * 2
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: AppTheme.fontFamily
                    font.pixelSize: AppTheme.fontNormalSize
                    color: AppTheme.greyDarkColor
                    text: "TEXT"
                    wrapMode: Text.WordWrap
                }

                IconSimpleButton
                {
                    id: buttonCancel
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: AppTheme.padding
                    anchors.left: parent.left
                    anchors.leftMargin: AppTheme.padding
                    image: "qrc:/resources/img/icon_cancel.png"

                    onSigButtonClicked:
                    {
                        showDialog(false, 0, 0)
                        sigCancel()
                    }
                }

                IconSimpleButton
                {
                    id: buttonAdd
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: AppTheme.padding
                    anchors.right: parent.right
                    anchors.rightMargin: AppTheme.padding
                    image: "qrc:/resources/img/icon_ok.png"

                    onSigButtonClicked:
                    {
                        showDialog(false, 0, 0)
                        sigAccept()
                    }
                }
            }
        }
    }
}
