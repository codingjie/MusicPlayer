import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtGraphicalEffects 1.0
import "../settings"

Item {
    id: winDesktop
    visible: true

    Text {
        id: tips1
        text: qsTr("应用")
        color: "white"
        font.pixelSize: 17
        font.bold: true
        anchors.bottom: music_app.top
        anchors.bottomMargin: 16
        anchors.left: music_app.left
    }

    Button {
        id: music_app
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -110
        width: 205
        height: 102

        Image {
            id: music_icon
            width: 205
            height: 102
            anchors.centerIn: parent
            source: "qrc:/desktop/winstyleicons/music_app_icon.png"
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: { music_icon.width = 207; music_icon.height = 104 }
            onExited: { music_icon.width = 205; music_icon.height = 102 }
            onClicked: { mainSwipeView.setCurrentIndex(1) }
        }

        style: ButtonStyle {
            background: Rectangle { color: "transparent" }
        }
    }

    Button {
        id: wifi_app
        anchors.left: music_app.right
        anchors.leftMargin: 10
        anchors.top: music_app.top
        width: 100
        height: 102
        onClicked: { mainSwipeView.setCurrentIndex(2) }

        style: ButtonStyle {
            background: Rectangle {
                color: "#108840"
                border.color: "#bbbbbbbb"
                border.width: control.hovered ? 1 : 0
            }
        }

        Image {
            width: 100
            height: 102
            anchors.centerIn: parent
            source: "qrc:/desktop/winstyleicons/wirless_app.png"
        }

        Text {
            text: qsTr("WIFI")
            color: "white"
            font.pixelSize: 15
            font.bold: true
            anchors.left: parent.left
            anchors.leftMargin: 3
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 3
        }
    }

    Button {
        id: settings_app
        anchors.left: wifi_app.right
        anchors.leftMargin: 10
        anchors.top: music_app.top
        width: 100
        height: 102
        onClicked: { mainSwipeView.setCurrentIndex(3) }

        style: ButtonStyle {
            background: Rectangle {
                color: "#80397b"
                border.color: "#bbbbbbbb"
                border.width: control.hovered ? 1 : 0
            }
        }

        Image {
            anchors.centerIn: parent
            source: "qrc:/desktop/winstyleicons/settings_app.png"
        }

        Text {
            text: qsTr("设置")
            color: "white"
            font.pixelSize: 15
            font.bold: true
            anchors.left: parent.left
            anchors.leftMargin: 3
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 3
        }
    }
}
