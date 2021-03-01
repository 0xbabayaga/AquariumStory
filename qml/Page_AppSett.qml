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
    id: page_AppSett

    signal sigClosing()
    signal sigClosed()

    function showPage(vis)
    {
        showPageAnimation.stop()

        if (vis === true)
            showPageAnimation.to = 0
        else
            showPageAnimation.to = page_AppSett.height

        showPageAnimation.start()
    }

    function setCurrentImage(img)
    {
        imgTankAvatar.addBase64ImageToList(img)
    }

    NumberAnimation
    {
        id: showPageAnimation
        target: rectContainerShadow
        property: "anchors.topMargin"
        duration: 200
        easing.type: Easing.OutCubic
        onStarted: page_AppSett.visible = true
        onFinished:
        {
            if (rectContainerShadow.anchors.topMargin > 0 && page_AppSett.visible === true)
            {
                page_AppSett.visible = false
                sigClosed()
            }
        }
    }

    Rectangle
    {
        id: rectContainerShadow
        anchors.top: parent.top
        anchors.topMargin: page_AppSett.height
        anchors.left: parent.left
        anchors.right: parent.right
        height: page_AppSett.height
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
                text: qsTr("SETTINGS")
            }


            Flickable
            {
                id: flickView
                anchors.top: parent.top
                anchors.topMargin: AppTheme.margin * 3
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: AppTheme.padding
                anchors.rightMargin: AppTheme.padding
                contentWidth: width
                contentHeight: height * 2
                flickableDirection: Flickable.VerticalFlick
                interactive: false
                clip: true

                NumberAnimation on contentY
                {
                    id: animationToPage
                    from: 0
                    to: 0
                    duration: 1000
                    easing.type: Easing.OutExpo
                    running: false
                }

                Rectangle
                {
                    id: rectSettings
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: parent.height / 2
                    color: "#00000000"

                    Column
                    {
                        id: columnContainer
                        width: parent.width
                        anchors.top: parent.top
                        anchors.topMargin: AppTheme.padding

                        Text
                        {
                            height: AppTheme.compHeight
                            verticalAlignment: Text.AlignVCenter
                            font.family: AppTheme.fontFamily
                            font.pixelSize: AppTheme.fontSmallSize
                            color: AppTheme.greyColor
                            text: qsTr("Language")
                        }

                        ComboListQuick
                        {
                            id: comboLang
                            objectName: "comboLang"
                            propertyName: qsTr("Language");
                            width: parent.width
                            model: langsModel
                            //KeyNavigation.tab: textFileName

                            ListModel
                            {
                                id: langsModel

                                ListElement {  name: "English"      }
                                ListElement {  name: "Беларускi"    }
                                ListElement {  name: "Русский"      }
                            }

                            onCurrentIndexChanged: app.sigLanguageChanged(currentIndex)
                        }

                        Item { height: AppTheme.padding ; width: 1;}

                        Text
                        {
                            height: AppTheme.compHeight
                            verticalAlignment: Text.AlignVCenter
                            font.family: AppTheme.fontFamily
                            font.pixelSize: AppTheme.fontSmallSize
                            color: AppTheme.greyColor
                            text: qsTr("Dimension units")
                        }

                        ComboListQuick
                        {
                            id: comboDimensions
                            objectName: "comboDimensions"
                            propertyName: qsTr("Dimension units");
                            width: parent.width
                            model: dimensionsModel
                            //KeyNavigation.tab: textFileName

                            ListModel
                            {
                                id: dimensionsModel

                                ListElement { name: qsTr("Santimeters")}
                                ListElement { name: qsTr("Inches")}
                            }

                            onCurrentIndexChanged: app.sigDimensionUnitsChanged(currentIndex)
                        }

                        Item { height: AppTheme.padding ; width: 1;}

                        Text
                        {
                            height: AppTheme.compHeight
                            verticalAlignment: Text.AlignVCenter
                            font.family: AppTheme.fontFamily
                            font.pixelSize: AppTheme.fontSmallSize
                            color: AppTheme.greyColor
                            text: qsTr("Volume units")
                        }

                        ComboListQuick
                        {
                            id: comboVolumeUnits
                            objectName: "comboVolumeUnits"
                            propertyName: qsTr("Volume units");
                            width: parent.width
                            model: volumeModel
                            //KeyNavigation.tab: textFileName

                            ListModel
                            {
                                id: volumeModel

                                ListElement { name: qsTr("Liters")}
                                ListElement { name: qsTr("Gallon US")}
                                ListElement { name: qsTr("Gallon UK")}
                            }

                            onCurrentIndexChanged: app.sigVolumeUnitsChanged(currentIndex)
                        }

                        Item { height: AppTheme.padding ; width: 1;}

                        Text
                        {
                            height: AppTheme.compHeight
                            verticalAlignment: Text.AlignVCenter
                            font.family: AppTheme.fontFamily
                            font.pixelSize: AppTheme.fontSmallSize
                            color: AppTheme.greyColor
                            text: qsTr("Date format")
                        }

                        ComboListQuick
                        {
                            id: comboDateFormat
                            objectName: "comboDateFormat"
                            propertyName: qsTr("Date format");
                            width: parent.width
                            model: dateFormatModel
                            //KeyNavigation.tab: textFileName

                            ListModel
                            {
                                id: dateFormatModel

                                ListElement { name: qsTr("MM/DD/YYYY")}
                                ListElement { name: qsTr("DD.MM.YYYY")}
                                ListElement { name: qsTr("YYYY-MM-DD")}
                            }

                            onCurrentIndexChanged: app.sigDateFormatChanged(currentIndex)
                        }

                    }
                }
            }
        }
    }
}
