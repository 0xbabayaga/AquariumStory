import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import "../../js/datetimeutility.js" as DateTimeUtils
import "../"

Item
{
    id: currentParamsTable

    property alias model: curValuesListView.model
    property alias noteViewVisible: noteViewDialog.isOpened

    function closeNoteViewDialog()
    {
        noteViewDialog.showDetails(false)
    }

    function realModelLength()
    {
        var size = 0

        if (curValuesListView.model)
            for (var i = 0; i < curValuesListView.model.length; i++)
            {
                if (model[i].en === true)
                    size++
            }

        return size
    }

    function formattedValue(val)
    {
        var str = ""

        if (val !== -1)
        {
            if (val > 50)
                str += Math.round(val)
            else
                str += Math.round(val * 100) / 100
        }
        else
            str = "-"

        return str
    }

    function formattedDiffValue(val_prev, val_curr)
    {
        var str = ""

        if (val_curr !== -1 && val_prev !== -1)
        {
            if (val_curr > val_prev)
                str = "+"

            str += Math.round((val_curr - val_prev) * 100) / 100
        }
        else
            str = "-"

        return str
    }

    function formattedColor(paramId, val)
    {
        var min = app.getParamById(paramId).min
        var max = app.getParamById(paramId).max

        if (val >= min && val <= max)
            return AppTheme.positiveChangesColor
        else
            return AppTheme.negativeChangesColor
    }

    function paramProgressState(paramId, val, prevVal)
    {
        var min = app.getParamById(paramId).min
        var max = app.getParamById(paramId).max
        var color = ""
        var sign = ""

        if (val !== -1 && prevVal !== -1)
        {
            if (val > prevVal)
            {
                sign = "\u25B2"

                if (val > 0.75 * (max - min) + min)
                    color = AppTheme.negativeChangesColor
                else if (val < 0.25 * (max - min) + min)
                    color = AppTheme.negativeChangesColor
                else
                    color = AppTheme.positiveChangesColor
            }
            else if (val < prevVal)
            {
                sign = "\u25BC"

                if (val > 0.25 * (max - min) + min)
                    color = AppTheme.positiveChangesColor
                else
                    color = AppTheme.negativeChangesColor
            }
            else
            {
                sign = "-"
                color = AppTheme.greyColor
            }

            return [sign, color]
        }
        else
            return ["-", AppTheme.greyColor]
    }

    Rectangle
    {
        anchors.fill: parent
        color: "#00000000"

        ListView
        {
            id: curValuesListView
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: AppTheme.compHeight
            spacing: 0
            interactive: (realModelLength() * AppTheme.compHeight  > height)

            onModelChanged:
            {
                height = realModelLength() * AppTheme.compHeight

                if (height > AppTheme.compHeight * 8 )
                    height = AppTheme.compHeight * 8

                if (curValuesListView.model.length > 0)
                    noteViewDialog.update(curValuesListView.model[0].note,
                                          curValuesListView.model[0].imgLink)
                else
                    noteViewDialog.update("", "")
            }

            delegate: Rectangle
            {
                width: parent.width
                height: en ? AppTheme.compHeight  : 0
                visible: en
                color: (index%2 === 0) ? AppTheme.backLightBlueColor : "#00000000"

                Rectangle
                {
                    anchors.fill: parent
                    anchors.leftMargin: AppTheme.padding
                    anchors.rightMargin: AppTheme.padding
                    color: "#00000000"

                    Text
                    {
                        id: textValueNow
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        height: AppTheme.compHeight
                        width: 70
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: AppTheme.fontFamily
                        font.pixelSize: AppTheme.fontNormalSize
                        color: formattedColor(paramId, valueNow)
                        text: formattedValue(valueNow)

                        Rectangle
                        {
                            anchors.left: parent.left
                            width: 1
                            height: parent.height
                            color: AppTheme.blueColor
                        }

                        Rectangle
                        {
                            anchors.right: parent.right
                            width: 1
                            height: parent.height
                            color: AppTheme.blueColor
                        }

                        Rectangle
                        {
                            anchors.bottom: parent.bottom
                            height: 1
                            width: parent.width
                            color: AppTheme.blueColor
                            visible: (index === currentParamsTable.realModelLength() - 1)
                        }
                    }

                    Text
                    {
                        anchors.top: parent.top
                        anchors.right: textValueNow.left
                        height: AppTheme.compHeight
                        verticalAlignment: Text.AlignVCenter
                        width: 120
                        font.family: AppTheme.fontFamily
                        font.pixelSize: AppTheme.fontNormalSize
                        color: AppTheme.blueFontColor
                        text: app.getParamById(paramId).fullName
                    }

                    Text
                    {
                        id: textDiffValue
                        anchors.top: parent.top
                        anchors.left: textValueNow.right
                        height: AppTheme.compHeight
                        width: 60
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: AppTheme.fontFamily
                        font.pixelSize: AppTheme.fontNormalSize
                        color: AppTheme.greyColor
                        text: formattedDiffValue(valuePrev, valueNow)
                    }

                    Text
                    {
                        id: textProgressSign
                        anchors.top: parent.top
                        anchors.left: textDiffValue.right
                        height: AppTheme.compHeight
                        width: 20
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family: AppTheme.fontFamily
                        font.pixelSize: AppTheme.fontSmallSize
                        font.bold: true
                        color: paramProgressState(paramId, valueNow, valuePrev)[1]
                        text: paramProgressState(paramId, valueNow, valuePrev)[0]
                    }

                    Text
                    {
                        anchors.top: parent.top
                        anchors.left: textProgressSign.right
                        height: AppTheme.compHeight
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        width: 46
                        font.family: AppTheme.fontFamily
                        font.pixelSize: AppTheme.fontSmallSize
                        color: AppTheme.greyColor
                        text: app.getParamById(paramId).unitName
                    }
                }
            }

            ScrollBar.vertical: ScrollBar
            {
                policy: ScrollBar.AlwaysOn
                parent: curValuesListView.parent
                anchors.top: curValuesListView.top
                anchors.topMargin: AppTheme.padding
                anchors.left: curValuesListView.right
                anchors.leftMargin: AppTheme.padding / 4
                anchors.bottom: curValuesListView.bottom
                anchors.bottomMargin: AppTheme.padding
                visible: (realModelLength() * AppTheme.compHeight  > height)

                contentItem: Rectangle
                {
                    implicitWidth: 2
                    implicitHeight: AppTheme.rowHeight
                    radius: width / 2
                    color: AppTheme.hideColor
                }
            }
        }

        NoteViewDialog
        {
            id: noteViewDialog
            anchors.top: curValuesListView.bottom
            anchors.topMargin: AppTheme.margin
            anchors.left: parent.left
            anchors.right: parent.right
            height: (AppTheme.rowHeight + AppTheme.compHeight)

            noteDate: (curValuesListView.model.length > 0) ? (new DateTimeUtils.DateTimeUtil()).printShortDate(curValuesListView.model[0].dtNow) : ""
            noteText: (curValuesListView.model.length > 0) ? curValuesListView.model[0].note : ""
            noteImages: (curValuesListView.model.length > 0 && curValuesListView.model[0].imgLink.length > 0) ? curValuesListView.model[0].imgLink : ""
        }
    }
}
