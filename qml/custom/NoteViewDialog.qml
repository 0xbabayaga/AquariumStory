import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.1
import QtGraphicalEffects 1.12
import "../"
import AppDefs 1.0

Item
{
    id: noteViewDialog
    visible: false
    opacity: 0

    property bool   isOpened: false
    property string noteText: ""
    property alias  noteDate: textNoteDate.text
    property string noteImages: ""

    ListModel { id: listOfImages }

    function update(note, imgs)
    {
        noteText = note
        noteImages = imgs

        hide()
    }

    function hide()
    {
        hideAnimation.stop()
        showAnimation.stop()
        hideAnimation.start()
    }

    function getImages()
    {
        var imgs = []

        listOfImages.clear()

        imgs = noteImages.split(';')

        for (var i = 0; i < imgs.length; i++)
            if (imgs[i].length > 0)
                listOfImages.append( { "fileLink": imgs[i] })

        if (imgs.length === 0)
            imagesListView.width = 0
        else if (imgs.length === 1)
            imagesListView.width = AppTheme.rowHeightMin
        else
            imagesListView.width = AppTheme.rowHeightMin  + (imgs.length - 1) * AppTheme.rowHeightMin / 4
    }

    function showDetails(vis)
    {
        if (vis === true)
        {
            rectDetailedContainer.visible = true
            textNoteDetailed.text = noteText
            showDetailsAnimation.start()
            isOpened = true
        }
        else
        {
            if (noteText.length > AppDefs.MAX_NOTETEXT_SIZE)
                textNote.text = trimText(noteViewDialog.noteText)
            else
                textNote.text = noteViewDialog.noteText

            hideDetailsAnimation.start()
            isOpened = false
        }
    }

    function trimText(str)
    {
        var trimStr = str.substr(0, AppDefs.MAX_NOTETEXT_SIZE)
        trimStr = trimStr.substr(0, Math.min(trimStr.length, trimStr.lastIndexOf(" ")))

        return trimStr
    }

    SequentialAnimation
    {
        id: showDetailsAnimation

        onStarted: rectDetailedContainer.visible = true

        NumberAnimation
        {
            target: rectDetailedContainer
            property: "opacity"
            duration: 200
            from: 0
            to: 1
            easing.type: Easing.OutCubic
        }

        NumberAnimation
        {
            target: rectShadowNoteDetails
            property: "anchors.topMargin"
            duration: 200
            from: rectDetailedContainer.height
            to: AppTheme.padding * 5
            easing.type: Easing.OutCubic
        }
    }

    SequentialAnimation
    {
        id: hideDetailsAnimation

        NumberAnimation
        {
            target: rectShadowNoteDetails
            property: "anchors.topMargin"
            duration: 200
            from: AppTheme.padding * 5
            to: rectDetailedContainer.height
            easing.type: Easing.InCubic
        }

        NumberAnimation
        {
            target: rectDetailedContainer
            property: "opacity"
            duration: 200
            from: 1
            to: 0
            easing.type: Easing.InCubic
        }

        onFinished: rectDetailedContainer.visible = false
    }

    SequentialAnimation
    {
        id: dragAnimation

        ScaleAnimator
        {
            target: noteViewDialog
            from: 1
            to: 0.95
            easing.type: Easing.OutBack
            duration: 100
            running: false
        }

        ScaleAnimator
        {
            target: noteViewDialog
            from: 0.95
            to: 1
            easing.type: Easing.OutBack
            duration: 500
            running: false
        }
    }

    NumberAnimation
    {
        id: hideAnimation
        target: noteViewDialog
        property: "opacity"
        duration: 200
        from: 1
        to: 0
        easing.type: Easing.InOutQuad

        onFinished:
        {
            noteViewDialog.visible = false

            if (noteViewDialog.noteText.length > AppDefs.MAX_NOTETEXT_SIZE)
                textNote.text = trimText(noteViewDialog.noteText)
            else
                textNote.text = noteViewDialog.noteText

            getImages()

            if (noteText.length > 0 || listOfImages.count > 0)
                showAnimation.start()
        }
    }

    NumberAnimation
    {
        id: showAnimation
        target: noteViewDialog
        property: "opacity"
        duration: 200
        from: 0
        to: 1
        easing.type: Easing.InOutQuad
        onStarted: noteViewDialog.visible = true
    }

    Rectangle
    {
        id: rectNoteFound
        anchors.left: parent.left
        anchors.top: parent.top
        width: parent.width
        height: (textNote.contentHeight + AppTheme.padding * 4)
        color: AppTheme.whiteColor

        Behavior on height {    NumberAnimation {   duration:  200 } }

        MouseArea
        {
            anchors.fill: parent
            onPressed: dragAnimation.start()
            onReleased: showDetails(true)
        }

        Text
        {
            id: textNoteFound
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: AppTheme.padding / 2
            height: AppTheme.compHeight
            verticalAlignment: Text.AlignVCenter
            font.family: AppTheme.fontFamily
            font.pixelSize: AppTheme.fontNormalSize
            color: AppTheme.blueFontColor
            text: qsTr("NOTE FOUND")
        }

        Rectangle
        {
            anchors.top: textNoteFound.bottom
            anchors.left: parent.left
            anchors.leftMargin: AppTheme.padding
            anchors.right: imagesListView.left
            anchors.rightMargin: AppTheme.padding
            height: 1
            color: AppTheme.backLightBlueColor
        }

        ListView
        {
            id: imagesListView
            anchors.top: parent.top
            anchors.topMargin: AppTheme.compHeight
            anchors.right: parent.right
            width: 0
            height: (AppTheme.rowHeightMin + 2)
            orientation: ListView.Horizontal
            spacing: -AppTheme.rowHeightMin * 3 / 4
            clip: true
            model: listOfImages
            interactive: false

            Behavior on width
            {
                NumberAnimation { duration: 100 }
            }

            delegate: Rectangle
            {
                width: AppTheme.rowHeightMin
                height: width
                radius: height / 2
                color: AppTheme.lightBlueColor


                Image
                {
                    anchors.fill: parent
                    anchors.leftMargin: 2
                    anchors.rightMargin: 2
                    anchors.topMargin: 2
                    anchors.bottomMargin: 2

                    source: (fileLink.length > 0) ? "file:///" + fileLink : ""
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
        }

        Rectangle
        {
            id: imgNotePhotoMask
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: AppTheme.compHeight
            height: AppTheme.rowHeight
            width: height
            radius: height / 2
            visible: false
        }

        Text
        {
            id: textNote
            anchors.left: parent.left
            anchors.leftMargin: AppTheme.padding / 2
            anchors.right: imagesListView.left
            anchors.rightMargin: AppTheme.padding / 2
            anchors.top: textNoteFound.bottom
            height: contentHeight + AppTheme.padding
            verticalAlignment: Text.AlignVCenter
            font.family: AppTheme.fontFamily
            font.pixelSize: AppTheme.fontSmallSize
            color: AppTheme.greyColor
            text: ""
            wrapMode: Text.WordWrap
        }
    }


    Rectangle
    {
        id: rectDetailedContainer
        anchors.fill: parent
        parent: Overlay.overlay
        color: AppTheme.backHideColor
        visible: false

        MouseArea { anchors.fill: parent    }

        Rectangle
        {
            id: rectShadowNoteDetails
            width: parent.width
            height: imgCurrent.height + AppTheme.rowHeight * 3
            anchors.top: parent.top
            anchors.topMargin: rectDetailedContainer.height
            anchors.bottom: parent.bottom
            color: AppTheme.whiteColor
            clip: true
        }

        DropShadow
        {
            anchors.fill: rectShadowNoteDetails
            horizontalOffset: 0
            verticalOffset: 3
            radius: AppTheme.shadowSize
            samples: AppTheme.shadowSamples
            color: AppTheme.shadowColor
            source: rectShadowNoteDetails
        }

        Rectangle
        {
            id: rectNoteDetails
            anchors.fill: rectShadowNoteDetails
            clip: true

            Behavior on height { NumberAnimation { duration: 200 } }

            onVisibleChanged:
            {
                textNoteDetailed.text = textNote.text

                if(listOfImages.count > 0)
                    imgCurrent.source = "file:///" + listOfImages.get(0).fileLink
            }

            Item
            {
                id: photoFrame
                anchors.top: parent.top
                width: parent.width
                height: 400

                Image
                {
                    id: imgCurrent
                    anchors.fill: parent
                    anchors.bottomMargin: 2

                    onStatusChanged:
                    {
                        if (status == Image.Ready)
                        {
                            var sc = sourceSize.width / photoFrame.width
                            photoFrame.height = sourceSize.height / sc
                            photoFrame.scale = 1
                        }
                    }
                }

                PinchArea
                {
                    anchors.fill: parent
                    pinch.target: photoFrame
                    pinch.minimumRotation: 0
                    pinch.maximumRotation: 0
                    pinch.minimumScale: 1
                    pinch.maximumScale: 4

                    onPinchUpdated:
                    {
                        if(photoFrame.x < dragArea.drag.minimumX)
                            photoFrame.x = dragArea.drag.minimumX
                        else if(photoFrame.x > dragArea.drag.maximumX)
                            photoFrame.x = dragArea.drag.maximumX

                        if(photoFrame.y < dragArea.drag.minimumY)
                            photoFrame.y = dragArea.drag.minimumY
                        else if(photoFrame.y > dragArea.drag.maximumY)
                            photoFrame.y = dragArea.drag.maximumY
                    }

                    MouseArea
                    {
                        id: dragArea
                        hoverEnabled: true
                        anchors.fill: parent
                        drag.target: photoFrame
                        scrollGestureEnabled: false
                        drag.minimumX: (rectNoteDetails.width - (photoFrame.width * photoFrame.scale))/2
                        drag.maximumX: -(rectNoteDetails.width - (photoFrame.width * photoFrame.scale))/2
                        drag.minimumY: (rectNoteDetails.height - (photoFrame.height * photoFrame.scale))/2
                        drag.maximumY: -(rectNoteDetails.height - (photoFrame.height * photoFrame.scale))/2

                        onDoubleClicked:
                        {
                            photoFrame.x = 0
                            photoFrame.y = 0
                            photoFrame.scale = 1
                        }

                        onWheel:
                        {
                            var scaleBefore = photoFrame.scale
                            photoFrame.scale += photoFrame.scale * wheel.angleDelta.y / 120 / 10
                            if(photoFrame.scale < 1)
                                photoFrame.scale = 1
                            else if(photoFrame.scale > 4)
                                photoFrame.scale = 4

                            if(photoFrame.x < drag.minimumX)
                                photoFrame.x = drag.minimumX
                            else if(photoFrame.x > drag.maximumX)
                                photoFrame.x = drag.maximumX

                            if(photoFrame.y < drag.minimumY)
                                photoFrame.y = drag.minimumY
                            else if(photoFrame.y > drag.maximumY)
                                photoFrame.y = drag.maximumY
                        }
                    }
                }
            }

            ListView
            {
                id: detailedImagesListView
                anchors.top: photoFrame.bottom
                anchors.topMargin: AppTheme.padding  + (photoFrame.scale - 1) * photoFrame.height / 2
                anchors.horizontalCenter: parent.horizontalCenter
                width: listOfImages.count * (AppTheme.compHeight + AppTheme.padding / 2)
                height: AppTheme.compHeight
                orientation: ListView.Horizontal
                spacing: AppTheme.padding / 2
                clip: true
                model: listOfImages
                interactive: false

                Behavior on width
                {
                    NumberAnimation { duration: 100 }
                }

                delegate: Rectangle
                {
                    width: parent.height
                    height: width
                    radius: height / 2
                    color: "#00000000"

                    Image
                    {
                        anchors.fill: parent
                        source: (fileLink === "") ? "" : "file:///" + fileLink
                        mipmap: true
                        layer.enabled: true
                        layer.effect: OpacityMask
                        {
                            maskSource: imgMask
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked: imgCurrent.source = "file:///" + fileLink
                        }
                    }

                    Rectangle
                    {
                        id: imgMask
                        anchors.fill: parent
                        radius: height/2
                        visible: false
                    }
                }
            }

            Text
            {
                id: textNoteDetailed
                anchors.left: parent.left
                anchors.leftMargin: AppTheme.padding * 3 / 2
                anchors.right: parent.right
                anchors.rightMargin: AppTheme.padding * 3 / 2
                anchors.top: detailedImagesListView.bottom
                anchors.topMargin: AppTheme.padding / 2
                height: contentHeight + AppTheme.padding
                verticalAlignment: Text.AlignVCenter
                font.family: AppTheme.fontFamily
                font.pixelSize: AppTheme.fontSmallSize
                color: AppTheme.greyColor
                text: ""
                wrapMode: Text.WordWrap
            }

            Text
            {
                id: textNoteDate
                anchors.right: parent.right
                anchors.rightMargin: AppTheme.padding * 3 / 2
                anchors.top: textNoteDetailed.bottom
                anchors.topMargin: AppTheme.padding / 2
                height: AppTheme.compHeight
                verticalAlignment: Text.AlignVCenter
                font.family: AppTheme.fontFamily
                font.pixelSize: AppTheme.fontSmallSize
                color: AppTheme.blueFontColor
                text: ""
            }

            IconSimpleButton
            {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: AppTheme.margin
                anchors.horizontalCenter: parent.horizontalCenter
                image: "qrc:/resources/img/icon_arrow_down.png"

                onSigButtonClicked: showDetails(false)
            }
        }
    }
}
