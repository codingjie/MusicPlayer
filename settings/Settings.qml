import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.12
import QtQuick.Controls 1.2

Item {
    id: settings
    visible: false

    // 关闭设置页面，返回音乐界面
    function closeSettings() {
        settings.visible = false
    }

    Rectangle {
        anchors.fill: parent
        color: "#1f1e58"
    }

    // 返回按钮
    Button {
        id: backBtn
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.right: parent.right
        anchors.rightMargin: 20
        width: 60
        height: 30
        text: "返回"
        onClicked: closeSettings()
        style: ButtonStyle {
            background: Rectangle {
                color: "#55ffffff"
                radius: 5
            }
            label: Text {
                text: control.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    Text {
        id: settingsText
        anchors.top: parent.top
        anchors.topMargin: 60
        anchors.left: parent.left
        anchors.leftMargin: 20
        text: qsTr("设置")
        color: "white"
        font.pixelSize: 25
    }

    Image {
        id: bellImage
        source: "qrc:/settings/images/bell.png"
        anchors.right: volumeText.left
        anchors.rightMargin: 10
        opacity: 0.7
        anchors.verticalCenter: volumeText.verticalCenter
    }

    Text {
        id: volumeText
        text: qsTr("音量设置")
        color: "white"
        font.pixelSize: 15
        anchors.top: settingsText.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 80
    }

    Slider {
        id: system_volume_slider
        height: 50
        width: 280
        anchors.top: volumeText.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 50
        updateValueWhileDragging: true
        stepSize: 1
        minimumValue: 0
        maximumValue: 100
        value: 50
        style: SliderStyle {
            groove: Rectangle {
                width: control.width
                height: 30
                radius: 8
                color: "gray"
                Rectangle {
                    width: styleData.handlePosition
                    height: 30
                    color: "#27e0fb"
                    radius: 8
                }
            }
            handle: Rectangle {
                width: 1
                height: 30
                color: "transparent"
                Text {
                    anchors.bottom: parent.top
                    color: "#27e0fb"
                    font.pixelSize: 18
                    text: String(control.value.toFixed(0)) + "%"
                }
            }
        }
    }

    // 退出和重启按钮
    Row {
        anchors.top: system_volume_slider.bottom
        anchors.topMargin: 80
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 50

        Rectangle {
            width: 150
            height: 150
            radius: 8
            color: "#aabbbbbb"

            Image {
                source: "qrc:/settings/images/close.png"
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.top: parent.top
                anchors.topMargin: 20
            }
            Text {
                anchors.centerIn: parent
                text: "退出程序"
                color: "white"
                font.pixelSize: 18
                font.bold: true
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Qt.quit()
            }
        }

        Rectangle {
            width: 150
            height: 150
            radius: 8
            color: "#aabbbbbb"

            Image {
                source: "qrc:/settings/images/reboot.png"
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.top: parent.top
                anchors.topMargin: 20
            }
            Text {
                anchors.centerIn: parent
                text: "重启"
                color: "white"
                font.pixelSize: 18
                font.bold: true
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Qt.quit()
            }
        }
    }
}
