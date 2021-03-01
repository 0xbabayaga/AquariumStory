import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import "../"

Item
{
    id: exportDialog
    width: app.width
    height: app.height
    opacity: enabled ? AppTheme.opacityEnabled : AppTheme.opacityDisabled

    property bool inProgress: false
    property bool isImport: false
    property alias message: textMessage.text

    signal sigAccept()
    signal sigCancel()

    function showDialog(vis, message)
    {
        rectContOpacityAnimation.stop()

        if (vis === true)
        {
            textMessage.text = message
            exportDialog.inProgress = true
            rectCont.visible = true
            exportDialog.visible = true
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
                    rectCont.visible = false
                    exportDialog.visible = false
                }
            }
        }

        Rectangle
        {
            color: AppTheme.backHideColor
            anchors.fill: parent

            Rectangle
            {
                id: rectWindow
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - AppTheme.margin
                height: 240  - AppTheme.margin
                radius: AppTheme.radius / 2
                color: AppTheme.whiteColor

                Behavior on height
                {
                    NumberAnimation { duration: 200 }
                }

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
                    text: (isImport === true) ? qsTr("Importing") : qsTr("Exporting")
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

                    onContentHeightChanged:
                    {
                        rectWindow.height = 240  - AppTheme.margin  + textMessage.contentHeight
                    }
                }

                IconSimpleButton
                {
                    id: buttonCancel
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: AppTheme.padding
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.leftMargin: AppTheme.padding
                    image: "qrc:/resources/img/icon_ok.png"
                    opacity: (inProgress === true) ? 0 : 1
                    enabled: (inProgress === false)

                    onSigButtonClicked: showDialog(false, 0)
                }
            }
        }
    }
}
