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
    id: page_TankSett

    property bool isEdit: true

    signal sigClosing()
    signal sigClosed()
    signal sigTankDeleting()

    function handleBackKeyEvent()
    {
        if (animationToPage.from === 0)
        {
            moveToEdit(false)

            return true
        }
        else if (confirmDialog.visible === true)
        {
            confirmDialog.showDialog(false, "", "")

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
        {
            moveToEdit(false)
            showPageAnimation.to = page_TankSett.height
        }

        showPageAnimation.start()
    }

    function setCurrentImage(img)
    {
        imgTankEditAvatar.addBase64ImageToList(img)
    }

    function moveToEdit(val)
    {
        animationToPage.stop()

        isEdit = true

        if (val === true)
        {
            animationToPage.from = 0
            animationToPage.to = flickView.height
            textHeader.text = qsTr("AQUARIUMS") + "\n" + qsTr("EDIT")
        }
        else
        {
            animationToPage.from = flickView.height
            animationToPage.to = 0
            textHeader.text = qsTr("AQUARIUMS")
        }

        animationToPage.start()
    }

    function moveToAddNewTank(val)
    {
        if (app.isFullFunctionality() === true ||
            tanksListModel.length < AppDefs.TANKS_COUNT_LIMIT)
        {
            if (tanksListModel.length < AppDefs.TANKS_COUNT_FULL_LIMIT)
            {
                animationToPage.stop()

                isEdit = false

                if (val === true)
                {
                    animationToPage.from = 0
                    animationToPage.to = flickView.height

                    textTankName.text = ""
                    textTankDesc.text = ""
                    textTankL.text = ""
                    textTankH.text = ""
                    textTankW.text = ""
                    imgTankEditAvatar.reset()

                    textHeader.text = qsTr("AQUARIUMS") + "\n" + qsTr("ADD NEW")
                }
                else
                {
                    animationToPage.from = flickView.height
                    animationToPage.to = 0
                    textHeader.text = qsTr("AQUARIUMS")
                }

                animationToPage.start()
            }
            else
            {
                tip.tipText = qsTr("You can only add") + " " + AppDefs.TANKS_COUNT_FULL_LIMIT + " " + qsTr("aquariums.")
                tip.show(true)
            }
        }
        else
        {
            tip.tipText = qsTr("You cannot add more than") + " " + AppDefs.TANKS_COUNT_LIMIT + " " + qsTr("aquariums.") + "\n" + qsTr("Limitation of non-registered version.")
            tip.show(true)
        }
    }

    function checkAndCreate()
    {
        var imgLink = ""

        if (imgTankEditAvatar.selectedImagesList.count > 0)
        {
            if (imgTankEditAvatar.selectedImagesList.get(0).fileLink !== "")
                imgLink = imgTankEditAvatar.selectedImagesList.get(0).fileLink
            else
                imgLink = imgTankEditAvatar.selectedImagesList.get(0).base64data
        }

        if (textTankName.text.length > 0 &&
            textTankH.text.length > 0 &&
            textTankL.text.length > 0 &&
            textTankW.text.length > 0 &&
            imgTankEditAvatar.selectedImagesList.count > 0)
        {
            if (page_TankSett.isEdit === true)
            {
                app.sigEditTank(tanksListModel[tanksList.currentIndex].tankId,
                                textTankName.text,
                                textTankDesc.text,
                                comboTankType.currentIndex,
                                app.deconvertDimension(parseInt(textTankL.text)),
                                app.deconvertDimension(parseInt(textTankW.text)),
                                app.deconvertDimension(parseInt(textTankH.text)),
                                imgLink)
            }
            else
            {
                app.sigCreateTank(textTankName.text,
                                  textTankDesc.text,
                                  comboTankType.currentIndex,
                                  app.deconvertDimension(parseInt(textTankL.text)),
                                  app.deconvertDimension(parseInt(textTankW.text)),
                                  app.deconvertDimension(parseInt(textTankH.text)),
                                  imgLink)
            }

            moveToEdit(false)
        }
    }

    onVisibleChanged:
    {
        if (visible === true)
            imgTankEditAvatar.addBase64ImageToList(tanksListModel[tanksList.currentIndex].img)
    }

    NumberAnimation
    {
        id: showPageAnimation
        target: rectContainerShadow
        property: "anchors.topMargin"
        duration: 200
        easing.type: Easing.OutCubic
        onStarted: page_TankSett.visible = true
        onFinished:
        {
            if (rectContainerShadow.anchors.topMargin > 0 && page_TankSett.visible === true)
            {
                page_TankSett.visible = false
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
        id: rectRealContainer
        anchors.fill: rectContainerShadow
        color: "#00000000"

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
                horizontalAlignment: Text.AlignHCenter
                font.family: AppTheme.fontFamily
                font.pixelSize: AppTheme.fontBigSize
                color: AppTheme.blueColor
                text: qsTr("AQUARIUMS")
            }


            TanksList
            {
                id: tanksList
                anchors.top: parent.top
                anchors.topMargin: AppTheme.rowHeightMin
                anchors.horizontalCenter: parent.horizontalCenter
                model: tanksListModel
                visible: isEdit === true

                onSigCurrentIndexChanged:
                {
                    imgTankEditAvatar.reset()
                    imgTankEditAvatar.addBase64ImageToList(tanksListModel[tanksList.currentIndex].img)
                }
            }

            Flickable
            {
                id: flickView
                anchors.top: parent.top
                anchors.topMargin: AppTheme.margin * 7
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
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
                    id: rectTankData
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

                        Row
                        {
                            width: parent.width
                            height: AppTheme.compHeight

                            Text
                            {
                                id: txtTankName
                                verticalAlignment: Text.AlignBottom
                                horizontalAlignment: Text.AlignHCenter
                                width: parent.width
                                font.family: AppTheme.fontFamily
                                font.pixelSize: AppTheme.fontBigSize
                                color: AppTheme.blueColor
                                text: (tanksListModel.length > 0) ? tanksListModel[tanksList.currentIndex].name : ""
                                visible: isEdit === true
                            }
                        }

                        Row
                        {
                            width: parent.width
                            height: AppTheme.compHeight

                            Text
                            {
                                id: txtTankDesc
                                verticalAlignment: Text.AlignBottom
                                horizontalAlignment: Text.AlignHCenter
                                width: parent.width
                                font.family: AppTheme.fontFamily
                                font.pixelSize: AppTheme.fontSmallSize
                                color: AppTheme.greyColor
                                text: (tanksListModel.length > 0) ? "(" + tanksListModel[tanksList.currentIndex].desc + ")" : "()" + qsTr("No desciption") + ")"
                                wrapMode: Text.WordWrap
                                visible: isEdit === true
                            }
                        }

                        Item { height: AppTheme.padding ; width: 1;}

                        Row
                        {
                            width: parent.width
                            height: AppTheme.compHeight

                            Text
                            {
                                width: parent.width / 2
                                height: parent.height
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                font.family: AppTheme.fontFamily
                                font.pixelSize: AppTheme.fontNormalSize
                                color: AppTheme.greyColor
                                text: qsTr("Aquarium type") + ":" + " "
                            }

                            Text
                            {
                                width: parent.width / 2
                                height: parent.height
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                font.family: AppTheme.fontFamily
                                font.pixelSize: AppTheme.fontNormalSize
                                color: AppTheme.greyColor
                                text: (tanksListModel.length > 0) ? tanksListModel[tanksList.currentIndex].typeName : ""
                            }
                        }

                        Row
                        {
                            width: parent.width
                            height: AppTheme.compHeight

                            Text
                            {
                                width: parent.width / 2
                                height: parent.height
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                font.family: AppTheme.fontFamily
                                font.pixelSize: AppTheme.fontNormalSize
                                color: AppTheme.greyColor
                                text: qsTr("Date create") + ":" + " "
                            }

                            Text
                            {
                                width: parent.width / 2
                                height: parent.height
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                font.family: AppTheme.fontFamily
                                font.pixelSize: AppTheme.fontNormalSize
                                color: AppTheme.greyColor
                                text: (tanksListModel.length > 0) ? (new DateTimeUtils.DateTimeUtil()).printFullDate(tanksListModel[tanksList.currentIndex].dtCreate) : ""
                            }
                        }


                        Row
                        {
                            width: parent.width
                            height: AppTheme.compHeight

                            Text
                            {
                                width: parent.width / 2
                                height: parent.height
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                font.family: AppTheme.fontFamily
                                font.pixelSize: AppTheme.fontNormalSize
                                color: AppTheme.greyColor
                                text: qsTr("Length") + ":" + " "
                            }

                            Text
                            {
                                width: parent.width / 2
                                height: parent.height
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                font.family: AppTheme.fontFamily
                                font.pixelSize: AppTheme.fontNormalSize
                                color: AppTheme.greyColor
                                text: (tanksListModel.length > 0) ? app.convertDimension(tanksListModel[tanksList.currentIndex].l) + " " + app.currentDimensionUnits() : ""
                            }
                        }

                        Row
                        {
                            width: parent.width
                            height: AppTheme.compHeight

                            Text
                            {
                                width: parent.width / 2
                                height: parent.height
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                font.family: AppTheme.fontFamily
                                font.pixelSize: AppTheme.fontNormalSize
                                color: AppTheme.greyColor
                                text: qsTr("Height") + ":" + " "
                            }

                            Text
                            {
                                width: parent.width / 2
                                height: parent.height
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                font.family: AppTheme.fontFamily
                                font.pixelSize: AppTheme.fontNormalSize
                                color: AppTheme.greyColor
                                text: (tanksListModel.length > 0) ? app.convertDimension(tanksListModel[tanksList.currentIndex].h) + " " + app.currentDimensionUnits() : ""
                            }
                        }

                        Row
                        {
                            width: parent.width
                            height: AppTheme.compHeight

                            Text
                            {
                                width: parent.width / 2
                                height: parent.height
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                font.family: AppTheme.fontFamily
                                font.pixelSize: AppTheme.fontNormalSize
                                color: AppTheme.greyColor
                                text: qsTr("Width") + ":" + " "
                            }

                            Text
                            {
                                width: parent.width / 2
                                height: parent.height
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                font.family: AppTheme.fontFamily
                                font.pixelSize: AppTheme.fontNormalSize
                                color: AppTheme.greyColor
                                text: (tanksListModel.length > 0) ? app.convertDimension(tanksListModel[tanksList.currentIndex].w) + " " + app.currentDimensionUnits() : ""
                            }
                        }

                        Row
                        {
                            width: parent.width
                            height: AppTheme.compHeight

                            Text
                            {
                                width: parent.width / 2
                                height: parent.height
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                font.family: AppTheme.fontFamily
                                font.pixelSize: AppTheme.fontNormalSize
                                color: AppTheme.greyColor
                                text: qsTr("Volume") + ":" + " "
                            }

                            Text
                            {
                                width: parent.width / 2
                                height: parent.height
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                font.family: AppTheme.fontFamily
                                font.pixelSize: AppTheme.fontNormalSize
                                color: AppTheme.greyColor
                                text: (tanksListModel.length > 0) ? app.convertVolume(tanksListModel[tanksList.currentIndex].volume) + " " + app.currentVolumeUnits() : ""
                            }
                        }

                        Item { width: 1; height: AppTheme.padding  }

                        Row
                        {
                            id: buttonsRow
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: (AppTheme.compHeight * 3 + AppTheme.margin * 2)
                            height: AppTheme.compHeight
                            spacing: AppTheme.margin

                            IconSmallSimpleButton
                            {
                                image: "qrc:/resources/img/icon_plus.png"

                                onSigButtonClicked: moveToAddNewTank(true)
                            }

                            IconSmallSimpleButton
                            {
                                image: "qrc:/resources/img/icon_edit.png"

                                onSigButtonClicked: moveToEdit(true)
                            }

                            IconSmallSimpleButton
                            {
                                image: "qrc:/resources/img/icon_cancel.png"

                                onSigButtonClicked: confirmDialog.showDialog(true,
                                                                             qsTr("Aquarium profile delete"),
                                                                             qsTr("All data assosiated with current aquarium will be deleted!"))
                            }
                        }
                    }
                }

                Rectangle
                {
                    id: rectAddEditTank
                    anchors.top: rectTankData.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: AppTheme.padding
                    anchors.right: parent.right
                    anchors.rightMargin: AppTheme.padding
                    height: flickView.height
                    color: "#00000000"

                    Column
                    {
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: 300
                        width: parent.width
                        spacing: AppTheme.padding

                        TextInput
                        {
                            id: textTankName
                            placeholderText: qsTr("Aquarium name")
                            width: parent.width
                            maximumLength: AppDefs.MAX_TANKNAME_SIZE
                            focus: false
                            text: (tanksListModel.length > 0) ? tanksListModel[tanksList.currentIndex].name : ""
                            KeyNavigation.tab: textTankDesc
                        }

                        Item { height: 1; width: 1;}

                        TextInput
                        {
                            id: textTankDesc
                            placeholderText: qsTr("Aquarium description")
                            width: parent.width
                            maximumLength: AppDefs.MAX_TANKDESC_SIZE
                            focus: false
                            text: (tanksListModel.length > 0) ? tanksListModel[tanksList.currentIndex].desc : ""
                            KeyNavigation.tab: textTankL
                        }

                        Item { height: 1; width: 1;}

                        Rectangle
                        {
                            id: rectRow
                            width: parent.width
                            height: AppTheme.compHeight
                            color: "#00000000"

                            property int unitWidth: 20

                            TextInput
                            {
                                id: textTankL
                                anchors.left: parent.left
                                placeholderText: qsTr("100")
                                width: (parent.width - rectRow.unitWidth * 3) / 3
                                maximumLength: AppDefs.MAX_TANKDIMENSION_SIZE
                                text: (tanksListModel.length > 0) ? app.convertDimension(tanksListModel[tanksList.currentIndex].l) : ""
                                inputMethod: Qt.ImhFormattedNumbersOnly | Qt.ImhNoPredictiveText
                                focus: true
                                KeyNavigation.tab: textTankW

                                Text
                                {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    verticalAlignment: Text.AlignVCenter
                                    font.family: AppTheme.fontFamily
                                    font.pixelSize: AppTheme.fontNormalSize
                                    color: AppTheme.blueFontColor
                                    text: app.currentDimensionUnits()
                                }
                            }

                            TextInput
                            {
                                id: textTankW
                                anchors.horizontalCenter: parent.horizontalCenter
                                placeholderText: qsTr("50")
                                width: (parent.width - rectRow.unitWidth * 3) / 3
                                maximumLength: AppDefs.MAX_TANKDIMENSION_SIZE
                                text: (tanksListModel.length > 0) ? app.convertDimension(tanksListModel[tanksList.currentIndex].w) : ""
                                inputMethod: Qt.ImhFormattedNumbersOnly | Qt.ImhNoPredictiveText
                                focus: true
                                KeyNavigation.tab: textTankH

                                Text
                                {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    verticalAlignment: Text.AlignVCenter
                                    font.family: AppTheme.fontFamily
                                    font.pixelSize: AppTheme.fontNormalSize
                                    color: AppTheme.blueFontColor
                                    text: app.currentDimensionUnits()
                                }
                            }

                            TextInput
                            {
                                id: textTankH
                                anchors.right: parent.right
                                placeholderText: qsTr("50")
                                width: (parent.width - rectRow.unitWidth * 3) / 3
                                maximumLength: AppDefs.MAX_TANKDIMENSION_SIZE
                                text: (tanksListModel.length > 0) ? app.convertDimension(tanksListModel[tanksList.currentIndex].h) : ""
                                inputMethod: Qt.ImhFormattedNumbersOnly | Qt.ImhNoPredictiveText
                                focus: true
                                KeyNavigation.tab: comboTankType

                                Text
                                {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    verticalAlignment: Text.AlignVCenter
                                    font.family: AppTheme.fontFamily
                                    font.pixelSize: AppTheme.fontNormalSize
                                    color: AppTheme.blueFontColor
                                    text: app.currentDimensionUnits()
                                }
                            }
                        }

                        Item { height: 1; width: 1;}

                        ComboList
                        {
                            id: comboTankType
                            propertyName: qsTr("Aquarium type");
                            width: parent.width
                            model: aquariumTypesListModel
                            currentIndex: (tanksListModel.length > 0) ? tanksListModel[tanksList.currentIndex].type : ""
                        }

                        Item { height: 1; width: 1;}

                        Text
                        {
                            verticalAlignment: Text.AlignVCenter
                            font.family: AppTheme.fontFamily
                            font.pixelSize: AppTheme.fontNormalSize
                            color: AppTheme.blueColor
                            text: qsTr("Aquarium image")
                        }

                        ImageList
                        {
                            id: imgTankEditAvatar
                            objectName: "imgTankEditAvatar"
                            imagesCountMax: 1
                        }
                    }

                    IconSimpleButton
                    {
                        id: buttonCancel
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: AppTheme.margin
                        image: "qrc:/resources/img/icon_cancel.png"
                        KeyNavigation.tab: buttonCreate

                        onSigButtonClicked:
                        {
                            moveToEdit(false)
                            sigClosing()
                        }
                    }

                    IconSimpleButton
                    {
                        id: buttonCreate
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: AppTheme.margin
                        image: "qrc:/resources/img/icon_ok.png"

                        onSigButtonClicked: checkAndCreate()
                    }
                }
            }
        }

        Tips
        {
            id: tip
            anchors.bottom: parent.bottom
            anchors.bottomMargin: AppTheme.rowHeight * 2
            anchors.horizontalCenter: parent.horizontalCenter
            visible: false
            tipText: qsTr("")
        }
    }

    ConfirmDialog
    {
        id: confirmDialog
        onSigAccept:
        {
            var id = tanksList.currentIndex

            tanksList.currentIndex = 0

            sigTankDeleting()
            app.sigDeleteTank(tanksList.model[id].tankId)

        }
    }
}
