/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   music
* @brief         Music.qml
* @author        Deng Zhimao
* @email         1252699831@qq.com
* @date          2020-06-05
*******************************************************************/
import dataModel 1.0
import QtQuick.Controls 2.5
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.1
import QtGraphicalEffects 1.0
import QtMultimedia 5.0
import QtQuick 2.4
import QtQuick 2.0

Item {
    visible: false
    id: music

    function songsInit(){
        plm.add(appCurrtentDir)
    }
    onVisibleChanged: {
        formState.state == 'right' ? formState.state = '' : formState.state = 'right'
    }
    Component.onCompleted: {
        music.x = parent.width
        songsInit()
    }
    Item {
        id: formState
        states: State {
            name: "right"
            PropertyChanges {
                target: music
                x: 0
            }
        }
        transitions: Transition {
            NumberAnimation {
                property: "x"
                easing.type: Easing.InOutQuart
                duration: 500
            }
        }
    }

    Rectangle {
        id: playListbg
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: sprogress.top
        color: "transparent"
    }
    Rectangle {
        id: songListbg
        anchors.top: playListbg.top
        anchors.bottom: playListbg.bottom
        anchors.left: playListbg.left
        anchors.right: playListbg.right
        anchors.bottomMargin: 10
        anchors.topMargin: 50
        color: "transparent"
    }
    Rectangle {
        id: topToolWidget
        anchors.top: playListbg.top
        width: playListbg.width
        height: 40
        anchors.horizontalCenter: playListbg.horizontalCenter
        color: "#30141414"
    }
    // 左上角添加返回按钮
    Button {
        id: btnBack
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 15
        anchors.topMargin: 30 // 微调位置与标题对齐
        width: 40
        height: 40

        style: ButtonStyle {
            background: Rectangle {
                implicitWidth: 50
                implicitHeight: 40
                // 平时透明，按下时显示深色半透明背景
                color: control.pressed ? "#40141414" : "transparent"
                radius: 4

                // 使用 Canvas 绘制实心箭头
                Canvas {
                    id: arrowCanvas
                    anchors.centerIn: parent
                    width: 24  // 增加宽度以容纳箭身
                    height: 12
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.reset();
                        ctx.fillStyle = "#27e0fb"; // 您统一的青蓝色

                        // 开始绘制箭头组合图形
                        ctx.beginPath();

                        // 1. 绘制左侧的三角形头部
                        ctx.moveTo(0, height / 2);          // 顶点（最左侧）
                        ctx.lineTo(10, 0);                  // 箭头右上角
                        ctx.lineTo(10, height);             // 箭头右下角

                        // 2. 绘制右侧连接的矩形箭身
                        // 箭身高度设为箭头总高度的一半，使其居中平滑连接
                        var stemHeight = 4;
                        ctx.rect(10, (height - stemHeight) / 2, 14, stemHeight);

                        ctx.closePath();
                        ctx.fill();
                    }
                }
            }
        }

        onClicked: {
            mainWindow.myMusicstate = false
            console.log("返回主页面")
        }
    }
    Button {
        id: btnListText
        anchors.centerIn: topToolWidget
        anchors.horizontalCenterOffset: - 50
        width: 80
        height: 40
        Text {
            id: listText
            text: qsTr("播放列表")
            color: "#27e0fb"
            font.pointSize: 10
            anchors.centerIn: parent
        }
        Rectangle{
            width: btnListText.width
            height: playList.visible ? 1 : 0
            anchors.bottom: btnListText.bottom
            color: "#27e0fb"
        }
        style: ButtonStyle {
            background: Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        onClicked: {
            playList.visible = true
            lyricMask.visible = false
            lyric.visible = false
        }
    }

    Button {
        id: btnLyricText
        anchors.centerIn: topToolWidget
        anchors.horizontalCenterOffset: 50
        width: 80
        height: 40
        Text {
            id: lyricText
            text: qsTr("歌词")
            color: "#27e0fb"
            font.pointSize: 10
            anchors.centerIn: parent
        }
        Rectangle{
            width: btnLyricText.width
            height: playList.visible ? 0 : 1
            anchors.bottom: btnLyricText.bottom
            color: "#27e0fb"
        }
        style: ButtonStyle {
            background: Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        onClicked: {
            playList.visible = false
            lyricMask.visible = true
            lyric.visible = true
        }
    }
    Rectangle {
        id: bg1
        anchors.top: sprogress.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: -2
        anchors.rightMargin: -2
        color: "transparent"
    }

    Audio {
        id: ado
        source: ""
        volume: volumeSlider.value / 100
        autoPlay: myMusicstate
        onAutoPlayChanged: {
            if(myMusicstate)
                ado.play()
            else
                ado.pause()
        }
        onSourceChanged: {
            lm.setPathofSong(source, appCurrtentDir);
        }
        onPositionChanged: {
            sprogress.maximumValue = duration;
            if(!sprogress.pressed)
                sprogress.value = position;
        }
        onPlaybackStateChanged: {
            switch (playbackState) {
            case Audio.PlayingState:
                btnplay.checked = true;
                break;
            case Audio.PausedState:
            case Audio.StoppedState:
                btnplay.checked = false;
                break;
            }
        }
        onStatusChanged: {
            switch (status) {
            case Audio.NoMedia:
                break;
            case Audio.Loading:
                break;
            case Audio.Loaded:
                sprogress.maximumValue = duration;
                if (metaData.title) {
                    plm.setCurrentTitle(metaData.title);
                }
                if (metaData.albumArtist) {
                    plm.setCurrentAuthor(metaData.albumArtist);
                }
                break;
            case Audio.Buffering:
                break;
            case Audio.Stalled:
                break;
            case Audio.Buffered:
                break;
            case Audio.InvalidMedia:
                switch (error) {
                case Audio.FormatError:
                    ttitle.text = qsTr("需要安装解码器");
                    break;
                case Audio.ResourceError:
                    ttitle.text = qsTr("文件错误");
                    break;
                case Audio.NetworkError:
                    ttitle.text = qsTr("网络错误");
                    break;
                case Audio.AccessDenied:
                    ttitle.text = qsTr("权限不足");
                    break;
                case Audio.ServiceMissing:
                    ttitle.text = qsTr("无法启用多媒体服务");
                    break;
                }
                break;
            case Audio.EndOfMedia:
                lm.currentIndex = 0;
                sprogress.value = 0;
                var count = plm.rowCount()
                if (count <= 0) return
                switch (btnloopMode.loopMode) {
                case 1:
                    ado.play();
                    break;
                case 2:
                    plm.currentIndex = (plm.currentIndex + 1) % count
                    break;
                case 3:
                    plm.randomIndex();
                    break;
                }
                break;
            }
        }
    }

    PlayListModel {
        id: plm
        onCurrentIndexChanged: {
            ado.source = getcurrentPath();
            playList.currentIndex = currentIndex;
        }
    }

    LyricModel {
        id: lm
        onCurrentIndexChanged: {
            lyric.currentIndex = currentIndex;
        }
    }

    ListView {
        id: lyric
        visible: true
        anchors.left: albumContainer.right
        anchors.right: parent.right
        anchors.top: topToolWidget.bottom
        anchors.bottom: bg1.top
        clip: true
        spacing: 27
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: parent.height >= 450 ? 40 : 10
        preferredHighlightEnd:  parent.height >= 450 ? 150 : 30
        highlight: Rectangle {
            color: Qt.rgba(0, 0, 0, 0)
            Behavior on y {
                SmoothedAnimation {
                    duration: 300
                }
            }
        }
        model: lm
        delegate: Rectangle {
            width: parent.width
            height: 13
            color: Qt.rgba(0,0,0,0)
            Text {
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                text: "   " + textLine
                color: parent.ListView.isCurrentItem ? "#27e0fb" : "white"
                font.pointSize: parent.ListView.isCurrentItem ? 20 : 13
                font.bold: parent.ListView.isCurrentItem
            }
        }
    }

    Image {
        id: imglyricMask
        visible: false
        anchors.fill: parent
        source: "qrc:/music/images/lyricmask.png"
    }

    OpacityMask {
        id: lyricMask
        visible: true
        anchors.fill: lyric
        source: lyric
        maskSource: imglyricMask
    }

    Slider {
        id: sprogress
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: btnplay.top
        anchors.bottomMargin: 5
        updateValueWhileDragging: false
        stepSize: 30
        property bool handled: false
        onPressedChanged: {
            handled = true;
        }
        onValueChanged: {
            if (handled && ado.seekable) {
                lm.findIndex(value);
                ado.seek(value);
                ado.play();
                handled = false;
            } else {
                lm.getIndex(value);
            }
        }
        style: SliderStyle {
            groove: Rectangle {
                width: control.width
                height: 3 // 进度条背景
                radius: 1
                color: "#303030"
                Rectangle {
                    width: styleData.handlePosition
                    height: 3  // 进度条
                    color: "#27e0fb"
                    radius: 1
                }
            }
            handle: Rectangle {
                width: 30
                height: 30
                color: "transparent"
            }
        }
    }

    ListView {
        id: playList
        visible: false
        anchors.fill: songListbg
        anchors.bottom: songListbg.bottom
        clip: true
        spacing: 10
        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            width: 5
            onActiveChanged: {
                active = true;
            }
            Component.onCompleted: {
                scrollBar.active = true;
            }
            contentItem: Rectangle{
                implicitWidth: 1
                implicitHeight: 100
                radius: 1
                color: scrollBar.hovered ? Qt.rgba(46, 46, 46, 0.2) : Qt.rgba(46, 46, 46, 0.1)
            }
        }
        model: plm
        delegate: Rectangle {
            id: itembg
            width: parent.width -10
            height: playList.currentIndex == index && ado.playbackState == Audio.PlayingState ? 60 : 45
            color: playList.currentIndex == index && ado.playbackState
                   == Audio.PlayingState ? Qt.rgba(46, 46, 46, 0.1) : "transparent"
            Image {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                width: itembg.height
                height: itembg.height
                id: album
                source: ado.playbackState == Audio.PlayingState && playList.currentIndex == index  ?
                        "file:///" + appCurrtentDir + "/src/artist/" +index +".jpg" : ""
            }

            Text {
                id: songsname
                width: itembg.width - 50
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: album.right
                verticalAlignment: Text.AlignVCenter
                text:  "  " + (index + 1 )+ " " + title
                elide: Text.ElideRight
                color: parent.ListView.isCurrentItem && ado.playbackState == Audio.PlayingState ? "#27e0fb" : "white"
                font.pointSize: 13
                font.bold: parent.ListView.isCurrentItem && ado.playbackState == Audio.PlayingState
            }
            Text {
                id: songsauthor
                visible: true
                width: 200
                height: 15
                anchors.bottom: parent.bottom
                anchors.left: album.right
                verticalAlignment: Text.AlignVCenter;
                text: "     " + author
                elide: Text.ElideRight
                color: parent.ListView.isCurrentItem && ado.playbackState == Audio.PlayingState ? "#27e0fb" : "gray"
                font.pointSize: 10
                font.bold: parent.ListView.isCurrentItem
            }
            MouseArea {
                id: mouserArea
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    plm.currentIndex = index
                    if (ado.playbackState != Audio.PlayingState)
                        myMusicstate = true
                }
            }
            Button {
                id: itembtn
                anchors.right: parent.right
                anchors.verticalCenter: itembg.verticalCenter
                width: itembg.height
                height: itembg.height
                onClicked: {
                    plm.currentIndex = index
                    if (ado.playbackState != Audio.PlayingState)
                        myMusicstate = true
                    else
                        myMusicstate = false
                }
                style: ButtonStyle {
                    background: Rectangle {
                        width: Control.width
                        height: Control.height
                        radius: 3
                        color: Qt.rgba(0,0,0,0)
                        Image {
                            id: itemImage
                            width: parent.height - 20
                            height: parent.height - 20
                            anchors.centerIn: parent
                            source:  playList.currentIndex != index || ado.playbackState != Audio.PlayingState
                                     ? "qrc:/music/images/btn_play.png" : "qrc:/music/images/btn_pause.png"
                            opacity: 0.8
                        }
                    }
                }
            }
        }
    }

    Item {
        visible: !playList.visible
        id: albumContainer
        width: 130
        height: 130
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: 150
        anchors.bottom: parent.verticalCenter
        anchors.bottomMargin: 0

        // 滑动切歌
        MouseArea {
            id: swipeArea
            anchors.fill: parent
            property real startX: 0

            onPressed: {
                startX = mouse.x
            }

            onReleased: {
                var deltaX = mouse.x - startX
                var count = plm.rowCount()
                if (count <= 0) return

                if (deltaX > 50) {
                    plm.currentIndex = (plm.currentIndex - 1 + count) % count
                } else if (deltaX < -50) {
                    plm.currentIndex = (plm.currentIndex + 1) % count
                }
            }
        }

        // 黑胶唱片背景
        Image {
            id: albumImage
            source: "qrc:/music/images/cd.png"
            width: 130
            height: 130
            anchors.centerIn: parent
            antialiasing: true
        }

        // 专辑封面（圆形，覆盖唱片中心红色区域）
        Rectangle {
            id: albumCoverContainer
            width: 65
            height: 65
            radius: 32.5
            anchors.centerIn: parent
            color: "transparent"
            clip: true

            Image {
                id: albumCover
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                source: playList.currentIndex >= 0 ?
                        "file:///" + appCurrtentDir + "/src/artist/" + playList.currentIndex + ".jpg" : ""
                fillMode: Image.PreserveAspectCrop
            }
        }

        RotationAnimator {
            id: anmimgalbum
            target: albumContainer
            from: 0
            to: 360
            duration: 50000
            loops: Animation.Infinite
            running: ado.playbackState == Audio.PlayingState && !playList.visible
            onRunningChanged: {
                if (running === false) {
                    from = albumContainer.rotation
                    to = from + 360
                }
            }
        }
    }

    Text {
        id: titleText
        anchors.top: albumContainer.bottom
        anchors.left: albumContainer.left
        anchors.topMargin: 20
        visible: !playList.visible
        text: ado.playbackState == Audio.PlayingState ? "歌 名：" + plm.getcurrentTitle() : ""
        color: "#aaffffff"
        font.pixelSize: 13
    }

    Text {
        id: singerText
        anchors.top: titleText.bottom
        anchors.left: albumContainer.left
        anchors.topMargin: 10
        visible: !playList.visible
        text: ado.playbackState == Audio.PlayingState ? "演 唱：" + plm.getcurrentAuthor() : ""
        color: "#aaffffff"
        font.pixelSize: 13
    }

    // 播放时间显示
    Text{
        id: timeText
        anchors.left: btnforward.right
        anchors.leftMargin: 20
        anchors.verticalCenter: btnplay.verticalCenter
        text: currentMusicTime(ado.position) + "/" + currentMusicTime(ado.duration)
        color: "#27e0fb"
        font.pointSize: 13
        font.bold: true
    }

    // 音量图标
    Image {
        id: volumeIcon
        source: "qrc:/music/images/img_volume2.png"
        width: 20
        height: 20
        anchors.left: timeText.right
        anchors.leftMargin: 20
        anchors.verticalCenter: btnplay.verticalCenter
    }

    // 音量滑块
    Slider {
        id: volumeSlider
        width: 100
        height: 20
        anchors.left: volumeIcon.right
        anchors.leftMargin: 5
        anchors.verticalCenter: btnplay.verticalCenter
        minimumValue: 0
        maximumValue: 100
        value: 50
        stepSize: 1
        style: SliderStyle {
            groove: Rectangle {
                width: control.width
                height: 4
                radius: 2
                color: "#303030"
                Rectangle {
                    width: styleData.handlePosition
                    height: 4
                    color: "#27e0fb"
                    radius: 2
                }
            }
            handle: Rectangle {
                width: 12
                height: 12
                radius: 6
                color: "#27e0fb"
            }
        }
    }

    // 音量百分比
    Text {
        anchors.left: volumeSlider.right
        anchors.leftMargin: 5
        anchors.verticalCenter: btnplay.verticalCenter
        text: volumeSlider.value.toFixed(0) + "%"
        color: "#27e0fb"
        font.pixelSize: 12
    }

    function currentMusicTime(time){
        var sec = Math.floor(time / 1000);
        var hours = Math.floor(sec / 3600);
        var minutes = Math.floor((sec - hours * 3600) / 60);
        var seconds = sec - hours * 3600 - minutes * 60;
        var hh, mm, ss;
        if(hours.toString().length < 2)
            hh = "0" + hours.toString();
        else
            hh = hours.toString();
        if(minutes.toString().length < 2)
            mm="0" + minutes.toString();
        else
            mm = minutes.toString();
        if(seconds.toString().length < 2)
            ss = "0" + seconds.toString();
        else
            ss = seconds.toString();
        return mm + ":" + ss
    }

    Button {
        id: btnlove
        anchors.right: btnloopMode.left
        anchors.rightMargin: 20
        anchors.verticalCenter: btnplay.verticalCenter
        style: ButtonStyle {
            background: Image {
                source: btnlove.checked ? "qrc:/music/images/btn_favorite_no.png"
                                        : "qrc:/music/images/btn_favorite_yes.png"
            }
        }
        onClicked: btnlove.checked = !btnlove.checked
    }

    Button {
        id: btnplay
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        width: 42
        height: 42
        checkable: true
        onClicked: {
            if (playList.currentIndex != -1) {
                (ado.playbackState === Audio.PlayingState) ? ado.pause() : ado.play();
            }
            ado.playbackState != Audio.PlayingState ? myMusicstate = false : myMusicstate = true
        }
        style: ButtonStyle {
            background: Image {
                id: imgplay
                source: ado.hasAudio && control.checked ? "qrc:/music/images/btn_pause.png"
                                                        : "qrc:/music/images/btn_play.png"
                opacity: control.hovered ? 0.7 : 1.0;
            }
        }
    }

    Button {
        id: btnbackward
        anchors.verticalCenter: btnplay.verticalCenter
        anchors.right: btnplay.left
        anchors.rightMargin: 20
        width: 32
        height: 32
        onClicked: {
            var count = plm.rowCount()
            if (count <= 0) return
            switch (btnloopMode.loopMode) {
            case 0:
            case 1:
            case 2:
                plm.currentIndex = (plm.currentIndex - 1 + count) % count
                break;
            case 3:
                plm.randomIndex();
                break;
            }
        }
        style: ButtonStyle {
            background: Image {
                id: imgbackward
                source: "qrc:/music/images/btn_previous.png"
                opacity: control.hovered ? 0.7 : 1.0;
            }
        }
    }

    Button {
        id: btnforward
        anchors.verticalCenter: btnplay.verticalCenter
        anchors.left: btnplay.right
        anchors.leftMargin: 20
        width: 32
        height: 32
        onClicked: {
            var count = plm.rowCount()
            if (count <= 0) return
            if (ado.hasAudio)
                switch (btnloopMode.loopMode) {
                case 0:
                case 1:
                case 2:
                    plm.currentIndex = (plm.currentIndex + 1) % count
                    break;
                case 3:
                    plm.randomIndex();
                    break;
                }
        }
        style: ButtonStyle {
            background: Image {
                id: imgforward
                source: "qrc:/music/images/btn_next.png"
                opacity: control.hovered ? 0.7 : 1.0;
            }
        }
    }

    Button {
        id: btnloopMode
        height: 25
        width: 25
        anchors.verticalCenter: btnplay.verticalCenter
        anchors.right: btnbackward.left
        anchors.rightMargin: 20
        property int loopMode: 2
        onLoopModeChanged: {
            switch (loopMode) {
            case 0:
                tooltip = qsTr("单曲播放")
                break;
            case 1:
                tooltip = qsTr("单曲循环")
                break;
            case 2:
                tooltip = qsTr("顺序播放");
                break;
            case 3:
                tooltip = qsTr("随机播放");
                break;
            default:
                loopMode = 0;
            }
        }
        onClicked: loopMode++
        tooltip: qsTr("单曲播放")
        style: ButtonStyle {
            background: Rectangle {
                width: 25
                height: 25
                radius: 3
                color: Qt.rgba(0,0,0,0)
                Image {
                    id: imgloopMode
                    anchors.fill: parent
                    anchors.centerIn: parent
                    source: {
                        switch (control.loopMode) {
                        case 1:
                            return "qrc:/music/images/btn_listscircle_single.png"
                        case 2:
                            return "qrc:/music/images/btn_listjump.png"
                        case 3:
                            return "qrc:/music/images/btn_listrandom.png"
                        default:
                            return "qrc:/music/images/btn_listsingle.png"
                        }
                    }
                }
            }
        }
    }
}
