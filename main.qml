import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import AppDefs 1.0
import "qml"
import "qml/custom"

Window
{
    id: app
    objectName: "app"

    property bool   isAndro: false
    property int    lastSmpId: 0
    property bool   isAccountCreated: false
    property real   scale: (Screen.orientation  === Qt.PortraitOrientation) ? Screen.desktopAvailableHeight / 720 : Screen.desktopAvailableHeight / 1080

    property string curUserName: ""
    property string curUserEmail: ""
    property string curUserAvatar: ""
    property int curUserDateCreate: 0

    property string global_APP_DOMAIN: "Undefined"
    property string global_APP_NAME: "AquariumStory"
    property string global_APP_VERSION: "Undefined"
    property bool global_APP_PERMISSION_DENIED: true
    property int global_APP_TYPE: AppDefs.UStatus_Blocked
    property int global_APP_LANG: AppDefs.Lang_English
    property int global_DIMUNITS:   AppDefs.Dimensions_CM
    property int global_VOLUNITS:   AppDefs.Volume_L
    property int global_DATEFORMAT: AppDefs.DateFormat_DD_MM_YYYY
    property string global_USERREGION: ""
    property string global_USERCOUNTRY: ""
    property string global_USERCITY: ""
    property bool   global_FULLFEATURES: false
    property string global_FULLFEATURESKEY: ""

    ListView
    {
        id: tmpParamList
        model: allParamsListModel
        visible: false
    }

    visible: true
    width: 360
    height: 720

    onGlobal_APP_PERMISSION_DENIEDChanged: startGui()
    onIsAccountCreatedChanged: startGui()

    signal sigCreateAccount(string uname, string upass, string umail, string img)
    signal sigEditAccount(string uname, string upass, string umail, string img)
    signal sigDeleteAccount()
    signal sigCreateTank(string name, string desc, int type, int l, int w, int h, string img)
    signal sigEditTank(string tankId, string name, string desc, int type, int l, int w, int h, string img)
    signal sigDeleteTank(string tankId)
    signal sigAddRecord(int smpId, int paramId, double value)
    signal sigEditRecord(int smpId, int paramId, double value)
    signal sigAddRecordNotes(int smpId, string note, string imageLink)
    signal sigEditRecordNotes(int smpId, string note, string imageLink)
    signal sigTankSelected(int tankIdx)
    signal sigTankStoryLoad(int tankIdx)
    signal sigPersonalParamStateChanged(int paramId, bool en)
    signal sigAddAction(string name, string desc, int type, int period, int dt)
    signal sigEditAction(int id, string name, string desc, int type, int period, int dt)
    signal sigDeleteAction(int id)
    signal sigActionViewPeriodChanged(int p)
    signal sigRefreshData()
    signal sigFullRefreshData()
    signal sigCurrentSmpIdChanged(int smpId)
    signal sigDebug()
    signal sigOpenGallery(string objName)
    signal sigLanguageChanged(int id)
    signal sigDimensionUnitsChanged(int id)
    signal sigVolumeUnitsChanged(int id)
    signal sigDateFormatChanged(int id)
    signal sigRegisterApp()
    signal sigExportData(string fileName)
    signal sigImportData(string fileName)
    signal sigGetImportFilesList()
    signal sigGrantPermission()

    function startGui()
    {
        if (isAccountCreated === false)
        {
            page_TankSett.visible = false
            page_AccountSett.visible = false
            page_TankData.visible = false
            page_Main.visible = false

            if (app.global_APP_PERMISSION_DENIED === false)
            {
                page_AccountWizard.visible = true
                rectPermissiondenied.visible = false
            }
        }
        else
        {
            if (app.global_APP_PERMISSION_DENIED === false)
            {
                page_Main.showPage(true)
                rectPermissiondenied.visible = false
            }

            page_AccountWizard.visible = false
        }
    }

    function hideLoadingScreen()
    {
        hideLoadingScreenAnimation.start()

        if (app.global_APP_PERMISSION_DENIED === true)
            rectPermissiondenied.visible = true
    }

    function getAllParamsListModel() { return allParamsListModel    }

    function getParamById(id)
    {
        for (var i = 0; i < allParamsListModel.length; i++)
        {
            if (allParamsListModel[i].paramId === id)
                return allParamsListModel[i]
        }

        return 0
    }

    function convertDimension(dim)
    {
        var val = dim

        if (global_DIMUNITS === AppDefs.Dimensions_INCH)
            val = dim / 2.54

        return Math.round(val * 100) / 100
    }

    function deconvertDimension(dim)
    {
        if (global_DIMUNITS === AppDefs.Dimensions_INCH)
            return dim * 2.54
        else
            return dim
    }

    function convertVolume(vol)
    {
        var val = vol

        if (global_VOLUNITS === AppDefs.Volume_L)
            val = vol
        else if (global_VOLUNITS === AppDefs.Volume_G_UK)
            val = vol * 0.219969
        else
            val = vol * 0.2641717541633774

        return Math.round(val)
    }

    function currentDimensionUnits()
    {
        if (global_DIMUNITS === AppDefs.Dimensions_CM)
            return qsTr("cm")
        else
            return qsTr("inch")
    }

    function currentVolumeUnits()
    {
        if (global_VOLUNITS === AppDefs.Volume_L)
            return qsTr("L")
        else if (global_VOLUNITS === AppDefs.Volume_G_UK)
            return qsTr("Gal(UK)")
        else
            return qsTr("Gal(US)")
    }

    function currentVolumeUnitsShort()
    {
        if (global_VOLUNITS === AppDefs.Volume_L)
            return qsTr("L")
        else if (global_VOLUNITS === AppDefs.Volume_G_UK)
            return qsTr("G")
        else
            return qsTr("G")
    }

    function isFullFunctionality()
    {
        return global_FULLFEATURES;
    }

    function getAppVersion(version)
    {
        var ver = ""

        ver += ((parseInt(version / 1000000)) % 1000).toString()+"."
        ver += ((parseInt(version / 1000)) % 1000).toString()+"."
        ver += (parseInt(version) % 1000).toString()

        return ver
    }

    NumberAnimation
    {
        id: hideLoadingScreenAnimation
        target: rectAppLoadingSpinner
        property: "opacity"
        from: 1
        to: 0
        duration: 200
        running: false
        onFinished:
        {
            if (rectAppLoadingSpinner.opacity === 0)
            {
                rectAppLoadingSpinner.visible = false

                if (isAccountCreated === true)
                {
                    if (app.global_APP_PERMISSION_DENIED === false)
                        page_Main.showPage(true)
                }
                else
                    if (app.global_APP_PERMISSION_DENIED === false)
                        page_AccountWizard.visible = true
            }
        }
    }

    Rectangle
    {
        id: rectMain
        anchors.fill: parent

        Image
        {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: AppTheme.margin * app.scale
            width: parent.width
            height: width * 0.75
            source: "qrc:/resources/img/back_waves.png"
        }

        Rectangle
        {
            id: rectBackground
            anchors.fill: parent
            color: "#00000000"

            Rectangle
            {
                id: rectHeader
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: AppTheme.rowHeightMin * app.scale
                color: AppTheme.blueColor

                Text
                {
                    id: textAppName
                    anchors.left: parent.left
                    anchors.leftMargin: AppTheme.margin/2 * app.scale
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: AppTheme.fontFamily
                    font.pixelSize: AppTheme.fontNormalSize * app.scale
                    color: AppTheme.whiteColor
                    text: global_APP_NAME.toUpperCase()
                }
            }
        }

        Page_Main
        {
            id: page_Main
            anchors.fill: rectBackground
            anchors.topMargin: AppTheme.rowHeightMin * app.scale
            visible: false
            interactive: page_TankData.visible === false
        }

        Rectangle
        {
            id: rectAppLoadingSpinner
            objectName: "rectAppLoadingSpinner"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: AppTheme.rowHeight * 2 * app.scale

            Behavior on opacity {   NumberAnimation {duration: 400} }

            Image
            {
                id: imgSpinner
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/resources/img/icon.png"
                width: 180 * app.scale
                height: 180 * app.scale
            }

            Text
            {
                id: textLoading
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: imgSpinner.bottom
                anchors.topMargin: AppTheme.margin * 3 * app.scale
                font.family: AppTheme.fontFamily
                font.pixelSize: AppTheme.fontNormalSize * app.scale
                color: AppTheme.greyDarkColor
                text: qsTr("Loading data") + " ..."
            }
        }

        Page_AccountsWizard
        {
            id: page_AccountWizard
            objectName: "page_AccountWizard"
            anchors.fill: rectBackground
            visible: false

            onSigAppInitCompleted: isAccountCreated = true
        }

        Page_TankData
        {
            id: page_TankData
            anchors.fill: rectBackground
            anchors.topMargin: AppTheme.rowHeightMin * app.scale
        }

        Page_AccountSett
        {
            id: page_AccountSett
            anchors.fill: rectBackground
            anchors.topMargin: AppTheme.rowHeightMin * app.scale
            visible: false
            onSigDeleting: page_TankData.showPage(false, 0)
        }

        Page_TankSett
        {
            id: page_TankSett
            anchors.fill: rectBackground
            anchors.topMargin: AppTheme.rowHeightMin * app.scale
            visible: false
        }

        Page_AppSett
        {
            id: page_AppSett
            anchors.fill: rectBackground
            anchors.topMargin: AppTheme.rowHeightMin * app.scale
            visible: false
        }

        Page_About
        {
            id: page_About
            anchors.fill: rectBackground
            anchors.topMargin: AppTheme.rowHeightMin * app.scale
            visible: false
        }

        Rectangle
        {
            id: rectPermissiondenied
            objectName: "rectPermissiondenied"
            anchors.fill: parent
            height: AppTheme.rowHeight * 8 * app.scale
            color: "#00000000"
            visible: false

            MouseArea
            {
                anchors.fill: parent
                enabled: rectPermissiondenied.visible
            }

            Rectangle
            {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: AppTheme.rowHeight * 8 * app.scale
                color: "#00000000"

                Text
                {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - AppTheme.margin * 2 * app.scale
                    font.family: AppTheme.fontFamily
                    font.pixelSize: AppTheme.fontNormalSize * app.scale
                    color: AppTheme.greyDarkColor
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("Cannot create or read database!") +"\n" + qsTr("Please grant \"Write external storage\" permission to the application.")
                }

                IconSimpleButton
                {
                    id: buttonGrant
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: AppTheme.margin * app.scale
                    anchors.horizontalCenter: parent.horizontalCenter

                    onSigButtonClicked:
                    {
                        app.sigGrantPermission()
                    }
                }
            }
        }
    }

    SideMenu
    {
        id: sideMenu
        anchors.top: parent.top
        anchors.right: parent.right
        width: parent.width
        height: parent.height

        accountName: app.curUserName
        accountImage: "data:image/jpg;base64," + app.curUserAvatar
        en: app.isAccountCreated

        onSigMenuSelected:
        {
            if (isAccountCreated === true)
            {
                if (id === AppDefs.Menu_Account)
                {
                    page_TankSett.moveToEdit(false)
                    page_TankSett.showPage(false)
                    page_AppSett.showPage(false)
                    page_About.showPage(false)
                    page_AccountSett.showPage(true)
                }
                else if (id === AppDefs.Menu_TankInfo)
                {
                    page_AccountSett.moveToEdit(false)
                    page_AccountSett.showPage(false)
                    page_AppSett.showPage(false)
                    page_About.showPage(false)
                    page_TankSett.showPage(true)
                }
                else if (id === AppDefs.Menu_Settings)
                {
                    page_AccountSett.moveToEdit(false)
                    page_AccountSett.showPage(false)
                    page_TankSett.showPage(false)
                    page_About.showPage(false)
                    page_AppSett.showPage(true)
                }
                else if (id === AppDefs.Menu_About)
                {
                    page_AccountSett.moveToEdit(false)
                    page_AccountSett.showPage(false)
                    page_TankSett.showPage(false)
                    page_AppSett.showPage(false)
                    page_About.showPage(true)
                }
            }
        }
    }

    onClosing:
    {
        close.accepted = false

        if (page_AccountSett.visible === true)
        {
            if (page_AccountSett.handleBackKeyEvent() === false)
                page_AccountSett.showPage(false)
        }
        else if (page_TankSett.visible === true)
        {
            if (page_TankSett.handleBackKeyEvent() === false)
                page_TankSett.showPage(false)
        }
        else if (page_AppSett.visible === true)
            page_AppSett.showPage(false)
        else if (page_About.visible === true)
        {
            if (page_About.handleBackKeyEvent() === false)
                page_About.showPage(false)
        }
        else if (page_TankData.visible === true)
            page_TankData.handleBackKeyEvent()
        else if (page_Main.handleBackKeyEvent() === false || page_AccountWizard.visible === true)
        {
            close.accepted = true
            Qt.quit()
        }
    }
}
