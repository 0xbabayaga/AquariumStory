import QtQuick 2.12
import QtQuick.Controls 2.12
import "../"

Item
{
    id: switchButton
    width: 50
    height: 22
    property alias checked: control.checked
    property string turnOnText: "Turn On"
    property string turnOffText: "Turn Off"

    Switch
    {
        id: control
        text: "None"
        opacity: enabled ? AppTheme.opacityEnabled : AppTheme.opacityDisabled
        width: switchButton.width
        height: switchButton.height

        onFocusChanged: switchButton.forceActiveFocus()

        indicator: Rectangle
        {
            id: rectIndi
            y: switchButton.height / 2
            implicitWidth: parent.width
            implicitHeight: 4
            radius: height / 2
            color: enabled ? (control.checked ? AppTheme.blueColor : AppTheme.hideColor) : (control.checked ? AppTheme.hideColor : AppTheme.hideColor)

            Rectangle
            {
                y: - switchButton.height / 2 + rectIndi.height/2
                x: control.checked ? parent.width - width : 0
                width: switchButton.height
                height: switchButton.height
                radius: height/2
                color: control.enabled ? AppTheme.whiteColor : AppTheme.hideColor
                border.color: enabled  ? AppTheme.blueColor : AppTheme.hideColor

                Behavior on x
                {
                    NumberAnimation { duration: 100 }
                }
            }
        }

        contentItem: Text
        {
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            text: checked ? switchButton.turnOnText : switchButton.turnOffText
            font.family: AppTheme.fontFamily
            font.pixelSize: AppTheme.fontNormalSize
            color: enabled ? AppTheme.whiteColor : AppTheme.hideColor
            verticalAlignment: Text.AlignVCenter
            leftPadding: control.indicator.width + control.spacing + 10
        }
    }
}
