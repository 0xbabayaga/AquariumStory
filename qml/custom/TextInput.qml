import QtQuick 2.0
import QtQuick.Controls 2.12
import "../"

Item
{
    id: textInput
    width: 150
    height: AppTheme.compHeight
    opacity: enabled ? AppTheme.opacityEnabled : AppTheme.opacityDisabled

    property alias text: textArea.text
    property alias echoMode: textArea.echoMode
    property string placeholderText: "sometext"
    property alias maximumLength: textArea.maximumLength
    property alias validator: textArea.validator
    property alias inputMethod: textArea.inputMethodHints

    onFocusChanged:
    {
        if (focus === true)
        {
            textArea.forceActiveFocus()
            rectUnderLine.color = AppTheme.blueColor
        }
    }

    function setError()
    {
        rectUnderLine.color = AppTheme.redColor
    }

    function clearError()
    {
        rectUnderLine.color = AppTheme.blueColor
    }

    TextInput
    {
        id: textArea
        width: textInput.width
        height: textInput.height
        font.family: AppTheme.fontFamily
        font.pixelSize: AppTheme.fontNormalSize
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        color: enabled ? AppTheme.blueFontColor : AppTheme.hideColor
        wrapMode: Text.WordWrap
        clip: true

        onTextChanged: clearError()

        Text
        {
            text: textInput.placeholderText
            verticalAlignment: Text.AlignVCenter
            font.family: AppTheme.fontFamily
            font.pixelSize: AppTheme.fontNormalSize
            color: AppTheme.greyColor
            height: parent.height
            visible: !(textArea.text.length > 0 || textArea.displayText.length > 0)
        }

        onContentHeightChanged:
        {
            if (textArea.contentHeight > AppTheme.compHeight )
                textInput.height = textArea.contentHeight
            else
                textInput.height = AppTheme.compHeight
        }

        onFocusChanged: focus ? rectUnderLine.color = AppTheme.blueColor : rectUnderLine.color = AppTheme.hideColor
    }

    Rectangle
    {
        id: rectUnderLine
        anchors.top: textInput.bottom
        anchors.left: textArea.left
        anchors.right: textArea.right
        height: 1
        color: AppTheme.hideColor
        opacity: textInput.opacity
    }
}
