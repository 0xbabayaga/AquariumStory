import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import Qt.labs.calendar 1.0
import "../../js/datetimeutility.js" as DateTimeUtils
import "../"
import AppDefs 1.0

Item
{
    id: datePicker
    width: 150
    height: AppTheme.compHeight
    opacity: enabled ? AppTheme.opacityEnabled : AppTheme.opacityDisabled

    property alias title: textHeader.text
    property double cellSize: AppTheme.compHeight
    property int fontSizePx: AppTheme.fontSmallSize
    property var date: new Date(calendar.currentYear, calendar.currentMonth, calendar.currentDay)
    property int yOffset: 200
    property bool isOpened: (rectCalendar.visible === true)

    signal sigOk()
    signal sigCancel()

    function getLocale()
    {
        if (app.global_APP_LANG === AppDefs.Lang_English)
            return Qt.locale("en_US")
        else
            return Qt.locale("ru_RU")
    }

    function getLinuxDate()
    {
        var dd = "0" + calendar.currentDay
        var mm = "0" + (calendar.currentMonth + 1)

        return calendar.currentYear + "/" + mm.substr(-2) + "/" + dd.substr(-2)
    }

    function setLinuxDate(tm)
    {
        var date = new Date(tm * 1000)
        var day = "0" + date.getDate()
        datePicker.date = date
        textDateTime.text = day.substr(-2) + " " + months[date.getMonth()]+ " " + date.getFullYear()
    }


    function setCurrentDate()
    {
        var dd = "0" + calendar.currentDay
        datePicker.date = new Date(calendar.currentYear, calendar.currentMonth, calendar.currentDay)
        textDateTime.text = dd.substr(-2) + " " + months[calendar.currentMonth]+ " " + calendar.currentYear
    }

    function showList(vis)
    {
        rectCalendarOpacityAnimation.stop()

        if (vis === true)
        {
            rectCalendar.visible = true
            rectCalendarOpacityAnimation.from = 0
            rectCalendarOpacityAnimation.to = 1
        }
        else
        {
            rectCalendarOpacityAnimation.from = 1
            rectCalendarOpacityAnimation.to = 0
        }

        rectCalendarOpacityAnimation.start()
    }

    Text
    {
        id: textDateTime
        text: "JAN 10 2002"
        width: datePicker.width
        height: AppTheme.compHeight
        font.family: AppTheme.fontFamily
        font.pixelSize: AppTheme.fontNormalSize
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: enabled ? AppTheme.blueFontColor : AppTheme.hideColor
        onFocusChanged: focus ? rectUnderLine.color = AppTheme.blueColor : rectUnderLine.color = AppTheme.hideColor

        MouseArea
        {
            anchors.fill: parent
            onClicked: textDateTime.forceActiveFocus()
        }
    }

    Rectangle
    {
        id: rectUnderLine
        anchors.top: textDateTime.bottom
        anchors.left: textDateTime.left
        anchors.right: textDateTime.right
        height: 1
        color: AppTheme.hideColor
        opacity: datePicker.opacity
    }

    Image
    {
        id: img
        anchors.right: parent.right
        anchors.top: parent.top
        width: 27
        height: 27
        source: "qrc:/resources/img/icon_listdown.png"
        mipmap: true

        MouseArea
        {
            anchors.fill: parent

            onClicked:
            {
                datePicker.forceActiveFocus()
                showList(true)
            }
        }
    }

    ColorOverlay
    {
        anchors.fill: img
        source: img
        color: AppTheme.blueColor
    }

    Rectangle
    {
        id: rectCalendar
        parent: Overlay.overlay
        width: app.width
        height: app.height
        focus: true
        clip: true
        visible: false
        color: "#00000000"

        NumberAnimation
        {
            id: rectCalendarOpacityAnimation
            target: rectCalendar
            property: "opacity"
            duration: 300
            easing.type: Easing.InOutQuad
            from: 0
            to: 1

            onFinished: if (to === 0) rectCalendar.visible = false
        }

        MouseArea { anchors.fill: parent }

        Rectangle
        {
            anchors.fill: parent
            color: AppTheme.backHideColor

            Rectangle
            {
                anchors.fill: parent
                anchors.topMargin: yOffset

                Rectangle
                {
                    id: rectHeaderShadow
                    anchors.fill: parent
                    color: AppTheme.whiteColor
                }

                DropShadow
                {
                    anchors.fill: rectHeaderShadow
                    horizontalOffset: 0
                    verticalOffset: -AppTheme.shadowOffset
                    radius: AppTheme.shadowSize
                    samples: AppTheme.shadowSamples
                    color: AppTheme.shadowColor
                    source: rectHeaderShadow
                }

                Rectangle
                {
                    anchors.fill: rectHeaderShadow
                    anchors.leftMargin: AppTheme.margin
                    anchors.rightMargin: AppTheme.margin
                    anchors.topMargin: AppTheme.margin
                    color: "#00000000"

                    Text
                    {
                        id: textHeader
                        anchors.top: parent.top
                        anchors.left: parent.left
                        verticalAlignment: Text.AlignVCenter
                        height: AppTheme.compHeight
                        width: 100
                        font.family: AppTheme.fontFamily
                        font.pixelSize: AppTheme.fontNormalSize
                        color: AppTheme.greyColor
                        text: qsTr("Select a date") + ":"
                    }

                    ListView
                    {
                        id: calendar
                        anchors.top: textHeader.bottom
                        anchors.topMargin: AppTheme.padding
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: AppTheme.compHeight  * 8
                        visible: true

                        snapMode: ListView.SnapToItem
                        orientation: ListView.Horizontal
                        spacing: datePicker.cellSize
                        model: CalendarModel
                        {
                            id: calendarModel
                            from: new Date(new Date().getFullYear(), 0, 1)
                            to: new Date(new Date().getFullYear() + 5, 11, 31)

                            function  setYear(newYear)
                            {
                                if (calendarModel.from.getFullYear() > newYear)
                                {
                                    calendarModel.from = new Date(newYear, 0, 1)
                                    calendarModel.to = new Date(newYear, 11, 31)
                                }
                                else
                                {
                                    calendarModel.to = new Date(newYear, 11, 31)
                                    calendarModel.from = new Date(newYear, 0, 1)
                                }

                                calendar.currentYear = newYear
                                calendar.goToLastPickedDate()
                                datePicker.setCurrentDate()
                            }
                        }

                        property int currentDay: new Date().getDate()
                        property int currentMonth: new Date().getMonth()
                        property int currentYear: new Date().getFullYear()
                        property int week: new Date().getDay()

                        delegate: Rectangle
                        {
                            height: AppTheme.compHeight
                            width: calendar.width

                            Rectangle
                            {
                                id: monthYearTitle
                                anchors.top: parent.top
                                height: AppTheme.compHeight
                                width: parent.width

                                Text
                                {
                                    anchors.centerIn: parent
                                    font.family: AppTheme.fontFamily
                                    font.pixelSize: AppTheme.fontBigSize
                                    color: AppTheme.blueColor
                                    text: (new DateTimeUtils.DateTimeUtil()).getMonthString(model.month) + " " + model.year;
                                }
                            }

                            DayOfWeekRow
                            {
                                id: weekTitles
                                anchors.top: monthYearTitle.bottom
                                height: AppTheme.compHeight
                                width: parent.width
                                locale: getLocale()

                                delegate: Text
                                {
                                    text: getLocale().dayName(model.day, Locale.ShortFormat)
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.family: AppTheme.fontFamily
                                    font.pixelSize: AppTheme.fontNormalSize
                                    color: AppTheme.greyColor
                                }
                            }

                            MonthGrid
                            {
                                id: monthGrid
                                month: model.month
                                year: model.year
                                spacing: 0
                                anchors.top: weekTitles.bottom
                                width: calendar.width
                                height: datePicker.cellSize * 6
                                locale: getLocale()

                                delegate: Rectangle
                                {
                                    height: datePicker.cellSize
                                    width: 30//datePicker.cellSize

                                    property bool highlighted: enabled && model.day === calendar.currentDay && model.month === calendar.currentMonth

                                    enabled: model.month === monthGrid.month
                                    color: enabled && highlighted ? AppTheme.blueColor : AppTheme.whiteColor

                                    Text
                                    {
                                        anchors.centerIn: parent
                                        text: model.day
                                        font.family: AppTheme.fontFamily
                                        font.pixelSize: AppTheme.fontNormalSize
                                        scale: highlighted ? 1.25 : 1
                                        visible: parent.enabled
                                        color: parent.highlighted ? AppTheme.whiteColor : AppTheme.blueColor

                                        Behavior on scale
                                        {
                                            NumberAnimation { duration: 150 }
                                        }
                                    }

                                    MouseArea
                                    {
                                        anchors.fill: parent
                                        onClicked:
                                        {
                                            calendar.currentDay = model.date.getDate()
                                            calendar.currentMonth = model.date.getMonth()
                                            calendar.week = model.date.getDay()
                                            calendar.currentYear = model.date.getFullYear()
                                            datePicker.setCurrentDate()
                                        }
                                    }
                                }
                            }
                        }

                        Component.onCompleted: goToLastPickedDate()

                        function goToLastPickedDate()
                        {
                            positionViewAtIndex(calendar.currentMonth, ListView.SnapToItem)
                        }
                    }

                    IconSimpleButton
                    {
                        id: buttonCancel
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: AppTheme.margin
                        anchors.left: parent.left
                        image: "qrc:/resources/img/icon_cancel.png"

                        onSigButtonClicked:
                        {
                            sigCancel()
                            showList(false)
                        }
                    }

                    IconSimpleButton
                    {
                        id: buttonOk
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: AppTheme.margin
                        anchors.right: parent.right
                        image: "qrc:/resources/img/icon_ok.png"

                        onSigButtonClicked:
                        {
                            sigOk()
                            showList(false)
                        }
                    }
                }
            }
        }
    }
}
