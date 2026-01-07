import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2 // 确保包含按钮组件
import QtGraphicalEffects 1.12
import "./music"

Window {
    id: mainWindow
    property bool myMusicstate: false // false 代表空白页，true 代表音乐页
    property string currentTimeString: "00:00"
    property string currentWeekString: ""
    visible: true
    width: 800
    height: 480

    // 背景
    Rectangle {
        anchors.fill: parent
        color: "#1f1e58"
    }

    // 空白界面层
    Rectangle {
        id: emptyPage
        anchors.fill: parent
        color: "#1f1e58"
        visible: !mainWindow.myMusicstate // 当 myMusicstate 为 false 时显示

        Button {
            text: "进入音乐播放器"
            anchors.centerIn: parent
            onClicked: mainWindow.myMusicstate = true
        }
    }

    // 音乐界面层
    Music {
        id: musicPage
        anchors.fill: parent
        // 关键：将 Music 里的 visible 与变量绑定
        visible: mainWindow.myMusicstate
    }

    // --- 状态栏保持不变 (z: 100 确保它在所有页面之上) ---
    Item {
        id: topMenu
        anchors.top: parent.top
        width: parent.width
        height: 30
        z: 100
        Rectangle {
            anchors.fill: parent
            color: "#30000000"
            Text {
                id: timeText
                text: currentTimeString
                color: "white"
                font.pixelSize: 18
                anchors.left: parent.left; anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: currentWeekString
                color: "#bbffffff"
                font.pixelSize: 14
                anchors.left: timeText.right; anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    function currentWeek() {
        var dayofWeek = "";
        var date = new Date();
        var str = Qt.formatDateTime(date, "ddd");

        switch (str) {
            case "Sun": case "周日": dayofWeek = "周日"; break;
            case "Mon": case "周一": dayofWeek = "周一"; break;
            case "Tue": case "周二": dayofWeek = "周二"; break;
            case "Wed": case "周三": dayofWeek = "周三"; break;
            case "Thu": case "周四": dayofWeek = "周四"; break;
            case "Fri": case "周五": dayofWeek = "周五"; break;
            case "Sat": case "周六": dayofWeek = "周六"; break;
            default:
                // 如果 str 既不是英文也不是中文（比如是数字 1-7），
                // 使用通用的格式作为备份，防止返回 undefined
                dayofWeek = Qt.formatDateTime(date, "ddd");
                break;
        }

        // 确保最终返回的是一个拼接好的字符串
        return dayofWeek + Qt.formatDateTime(date, ", MM月dd日");
    }

    function currentTime() {
        // 显式确保返回字符串
        var time = Qt.formatDateTime(new Date(), "hh:mm");
        return time ? time : "00:00";
    }

    Timer {
        interval: 1000; repeat: true; running: true
        onTriggered: {
            currentTimeString = currentTime()
            currentWeekString = currentWeek()
        }
        Component.onCompleted: {
            currentTimeString = currentTime()
            currentWeekString = currentWeek()
        }
    }
}
