import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.0
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.12
import "./music"

Window {
    id: mainWindow
    property bool myMusicstate: false
    property string currentTimeString
    property string currentWeekString
    visible: true
    width: 800
    height: 480

    Rectangle {
        anchors.fill: parent
        color: "#1f1e58"
    }

    Item {
        id: topMenu
        anchors.top: mainWindow.top
        anchors.left: mainWindow.left
        width: mainWindow.width
        height: 30
        z: 100

        Rectangle {
            anchors.fill: topMenu
            color: "#30000000"

            Text {
                id: timeText
                text: currentTimeString
                color: "white"
                font.bold: true
                font.pixelSize: 18
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: dateText
                text: currentWeekString
                color: "#bbffffff"
                font.pixelSize: 14
                anchors.left: timeText.right
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    Music {
        id: musicPage
        anchors.fill: parent
        visible: true
    }

    function currentWeek(){
        var dayofWeek = ""
        var str = Qt.formatDateTime(new Date(), "ddd")
        switch (str){
        case "Sun":
        case "周日":
            dayofWeek = "周日"
            break
        case "Mon":
        case "周一":
            dayofWeek = "周一"
            break
        case "Tue":
        case "周二":
            dayofWeek = "周二"
            break
        case "Wed":
        case "周三":
            dayofWeek = "周三"
            break
        case "Thu":
        case "周四":
            dayofWeek = "周四"
            break
        case "Fri":
        case "周五":
            dayofWeek = "周五"
            break
        case "Sat":
        case "周六":
            dayofWeek = "周六"
            break
        }
        return dayofWeek + Qt.formatDateTime(new Date(), ",MM月dd日")
    }

    function currentTime(){
        return Qt.formatDateTime(new Date(), "hh:mm")
    }

    Timer{
        id: timer
        interval: 1000
        repeat: true
        running: true
        onTriggered:{
            currentTimeString = currentTime()
            currentWeekString = currentWeek()
        }
        Component.onCompleted: {
            currentTimeString = currentTime()
            currentWeekString = currentWeek()
        }
    }
}
