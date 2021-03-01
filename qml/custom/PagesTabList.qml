import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import "../"

Item
{
    id: pagesTabList
    height: AppTheme.compHeight

    property alias model: listTab.model
    property alias currentIndex: listTab.currentIndex

    signal sigCurrentIndexChanged(int id)

    Rectangle
    {
        id: rectContainer
        anchors.fill: parent
        color: "#00000000"

        ListView
        {
            id: listTab
            anchors.fill: parent
            model: modelTabs
            orientation: ListView.Horizontal
            spacing: AppTheme.rowSpacing
            currentIndex: 0
            interactive: false

            delegate: Component
            {
                Rectangle
                {
                    width:  txt.contentWidth + AppTheme.padding
                    height: AppTheme.compHeight
                    color: (listTab.currentIndex === index) ? AppTheme.whiteColor : AppTheme.blueColor

                    Behavior on color { ColorAnimation {   duration: 100 } }

                    Text
                    {
                        id: txt
                        color: (listTab.currentIndex === index) ? AppTheme.blueFontColor : AppTheme.whiteColor
                        font.pixelSize: AppTheme.fontNormalSize
                        font.family: AppTheme.fontFamily
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                        height: parent.height
                        text: tab

                        Behavior on color { ColorAnimation {   duration: 100 } }

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:
                            {
                                listTab.currentIndex = index
                                sigCurrentIndexChanged(currentIndex)
                            }
                        }
                    }
                }
            }
        }
    }
}
