import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import "custom"
import ".."


Item
{
    id: tab_Current

    function handleBackKeyEvent()
    {
        if (paramsTable.noteViewVisible === true)
        {
            paramsTable.closeNoteViewDialog()

            return true
        }
        else if (dialogAddParamNote.handleBackKeyEvent() === true)
        {
            return true
        }
        else if (dialogAddParamNote.visible === true)
        {
            dialogAddParamNote.show(false)

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

    function addLogRecord(isEdit)
    {
        var smpId = 0

        if (isEdit === false)
            smpId = app.lastSmpId + 1
        else
            smpId = curValuesListModel[0].smpIdNow

        for (var i = 0; i < dialogAddParamNote.addParamsListModel.length; i++)
        {
            if (dialogAddParamNote.addParamsListModel[i].en === true &&
                dialogAddParamNote.addParamsListModel[i].value !== -1)
            {
                if (isEdit === false)
                {
                    app.sigAddRecord(smpId,
                                     dialogAddParamNote.addParamsListModel[i].paramId,
                                     dialogAddParamNote.addParamsListModel[i].value)
                }
                else
                {
                    app.sigEditRecord(smpId,
                                      dialogAddParamNote.addParamsListModel[i].paramId,
                                      dialogAddParamNote.addParamsListModel[i].value)
                }
            }
        }

        if (dialogAddParamNote.note.length > 0 || dialogAddParamNote.selectedImagesList.count > 0)
        {
            var links = ""

            for (i = 0; i < dialogAddParamNote.selectedImagesList.count; i++)
            {
                if (i !== 0)
                    links += ";"

                links += dialogAddParamNote.selectedImagesList.get(i).fileLink
            }

            if (isEdit === false)
            {
                sigAddRecordNotes(smpId,
                                  dialogAddParamNote.note,
                                  links)
            }
            else
            {
                sigEditRecordNotes(smpId,
                                   dialogAddParamNote.note,
                                   links)
            }
        }
        else
        {
            if (isEdit === false)
                sigAddRecordNotes(-1, "", "")
            else
                sigEditRecordNotes(-1, "", "")
        }

        sigRefreshData()
    }

    function getParamListRealCount()
    {
        var size = 0

        for (var i = 0; i < dialogAddParamNote.addParamsListModel.length; i++)
            if (dialogAddParamNote.addParamsListModel[i].en === true)
                size++;

        return size
    }

    function checkIfTodayRecordExist()
    {
        var lastDate
        var todayDate

        if (paramsTable.model.length > 0)
        {
            lastDate = new Date(paramsTable.model[0].dtLast * 1000)
            todayDate = new Date()

            if (lastDate.getYear() === todayDate.getYear() &&
                lastDate.getMonth() === todayDate.getMonth() &&
                lastDate.getDate() === todayDate.getDate())
            {
                confirmDialog.showDialog(true, qsTr("WARNING"), qsTr("The record for today is exist. Do you want to update existing?"))
            }
            else
                showAddParamDialog(false)
        }
        else
            showAddParamDialog(false)
    }

    function showAddParamDialog(isEdit)
    {
        var i = 0

        dialogAddParamNote.setEdit(isEdit)
        dialogAddParamNote.show(true)

        if (isEdit === true)
        {
            for (i = 0; i < dialogAddParamNote.addParamsListModel.length; i++)
            {
                if (dialogAddParamNote.addParamsListModel[i].en === true)
                {
                    for (var p = 0; p < paramsTable.model.length; p++)
                    {
                        if (dialogAddParamNote.addParamsListModel[i].paramId === paramsTable.model[p].paramId)
                        {
                            app.getAllParamsListModel()[i].value = paramsTable.model[p].valueNow
                            break
                        }
                    }
                }
            }
        }
        else
        {
            for (i = 0; i < dialogAddParamNote.addParamsListModel.length; i++)
            {
                if (dialogAddParamNote.addParamsListModel[i].en === true)
                    dialogAddParamNote.addParamsListModel[i].value = -1
            }
        }

        dialogAddParamNote.addParamsListModel = 0
        dialogAddParamNote.addParamsListModel = app.getAllParamsListModel()
    }

    Rectangle
    {
        id: rectDataContainer
        anchors.fill: parent
        anchors.leftMargin: AppTheme.padding * app.scale
        anchors.rightMargin: AppTheme.padding * app.scale
        color: "#00002000"

        Behavior on opacity
        {
            NumberAnimation {   duration: 200 }
        }

        CurrentParamsTable
        {
            id: paramsTable
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            model: curValuesListModel
            height: AppTheme.compHeight * 8 * app.scale
        }

        Rectangle
        {
            anchors.fill: paramsTable
            visible: (curValuesListModel) ? (curValuesListModel.length === 0) : false
            color: "#00000000"

            Text
            {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: AppTheme.rowHeight * app.scale
                horizontalAlignment: Text.AlignHCenter
                width: 250 * app.scale
                font.family: AppTheme.fontFamily
                font.pixelSize: AppTheme.fontNormalSize * app.scale
                wrapMode: Text.WordWrap
                color: AppTheme.greyColor
                text: qsTr("No record found for this aquarium")
            }
        }

        PointList
        {
            id: ptList
            anchors.top: paramsTable.top
            anchors.left: parent.left
            anchors.leftMargin: -AppTheme.padding * app.scale
            anchors.right: parent.right
            anchors.rightMargin: -AppTheme.padding * app.scale
            model:  datesList
            visible: (curValuesListModel.length !== 0)

            onModelChanged: currentIndex = 0
            onSigCurIndexChanged:
            {
                if (ptList.model && ptList.model.length > id && id >= 0)
                    app.sigCurrentSmpIdChanged(ptList.model[id].smpId)
            }
        }

        IconSimpleButton
        {
            id: addRecordButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: AppTheme.margin * app.scale

            onSigButtonClicked: checkIfTodayRecordExist()
        }
    }

    DialogAddParamNote
    {
        id: dialogAddParamNote
        visible: false

        onSigOk: addLogRecord(dialogAddParamNote.isEdit)
    }

    ConfirmDialog
    {
        id: confirmDialog
        visible: false
        onSigAccept: showAddParamDialog(true)
    }
}
