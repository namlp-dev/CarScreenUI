import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes
import Qt.labs.platform 1.1
import QtMultimedia

Item {
    id: root

    // Đồng bộ với Main Window
    property string currentMediaType: mainWindow.savedMediaType
    onCurrentMediaTypeChanged: {
        mainWindow.savedMediaType = currentMediaType
        mainWindow.activeFilterMode = currentMediaType // [FIX 1] Báo cho Main biết để lọc Next/Prev
    }

    property bool isFullscreen: false
    property bool controlsVisible: true

    // [FIX 3] TIMER THÔNG MINH
    // Chỉ chạy khi: Đang Fullscreen VÀ Đang hiện VÀ Không di chuột VÀ Không đang kéo Slider
    Timer {
        id: hideControlsTimer
        interval: 3000
        repeat: false
        running: root.isFullscreen && root.controlsVisible
                 && !controlMouseArea.containsMouse // Chuột không nằm trong vùng điều khiển
                 && !seekSlider.pressed // Không đang tua
                 && !volSlider.pressed // Không đang chỉnh volume
                 && mainWindow.player.playbackState === MediaPlayer.PlayingState
        onTriggered: root.controlsVisible = false
    }

    // States giữ nguyên logic cũ
    states: [
        State {
            name: "MUSIC_MODE"
            when: root.currentMediaType === "music"
            PropertyChanges { target: mediaContainer; width: leftPanel.width * 0.7; height: width }
            PropertyChanges { target: albumArtImg; visible: true }
            PropertyChanges { target: videoOutput; visible: false }
            PropertyChanges { target: fullScreenBtn; visible: false }
            PropertyChanges { target: rightPanel; visible: true; opacity: 1 }
        },
        State {
            name: "VIDEO_WINDOWED"
            when: root.currentMediaType === "video" && !root.isFullscreen
            PropertyChanges { target: mediaContainer; width: leftPanel.width * 0.95; height: width * 9/16 }
            PropertyChanges { target: albumArtImg; visible: false }
            PropertyChanges { target: videoOutput; visible: true }
            PropertyChanges { target: fullScreenBtn; visible: true; text: "⛶" }
            PropertyChanges { target: rightPanel; visible: true; opacity: 1 }
            PropertyChanges { target: controlArea; opacity: 1; visible: true }
        },
        State {
            name: "VIDEO_FULLSCREEN"
            when: root.currentMediaType === "video" && root.isFullscreen
            PropertyChanges { target: leftPanel; x: 0; y: 0; width: root.width; height: root.height; z: 100 }
            PropertyChanges { target: mediaContainer; width: root.width; height: root.height }
            PropertyChanges { target: albumArtImg; visible: false }
            PropertyChanges { target: rightPanel; visible: false; opacity: 0 }
            PropertyChanges { target: mainPlayerInterface; anchors.margins: 0}

            // [FIX 2] Xử lý hiển thị Controls Overlay
            PropertyChanges { target: controlArea; parent: leftPanel; anchors.bottom: leftPanel.bottom }
            PropertyChanges { target: controlArea; opacity: root.controlsVisible ? 1.0 : 0.0 }
            // Quan trọng: Nếu opacity = 0 thì set visible = false để tránh bấm nhầm
            PropertyChanges { target: controlArea; visible: root.controlsVisible }

            PropertyChanges { target: fullScreenBtn; visible: true; text: "✖" }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "width,height,opacity,x,y"; duration: 200; easing.type: Easing.InOutQuad }
    }

    function isVideo(filePath) { return filePath.toString().toLowerCase().endsWith(".mp4") }

    property var filteredList: {
        var list = []
        for(var i=0; i<mainWindow.songList.length; i++) {
            var file = mainWindow.songList[i]
            if (currentMediaType === "music" && !isVideo(file)) list.push(file)
            else if (currentMediaType === "video" && isVideo(file)) list.push(file)
        }
        return list
    }

    FolderDialog {
        id: folderDialog
        currentFolder: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]
        onAccepted: {
            var files = mainWindow.fileScanner.scanForMediaFiles(currentFolder)
            if (files.length > 0) {
                mainWindow.songList = files
                mainWindow.isMediaLoaded = true
                root.currentMediaType = "music"
                mainWindow.currentSongIndex = -1 // Reset index
            }
        }
    }

    Item {
        anchors.fill: parent; z: 10; visible: !mainWindow.isMediaLoaded
        Column {
            anchors.centerIn: parent; spacing: 30
            Text { text: "MEDIA CENTER"; color: "#666"; font.pixelSize: 24; font.bold: true; font.letterSpacing: 4; anchors.horizontalCenter: parent.horizontalCenter }
            Rectangle {
                width: 200; height: 60; radius: 30; color: "transparent"; border.color: "#00FFFF"; border.width: 2; anchors.horizontalCenter: parent.horizontalCenter
                Row { anchors.centerIn: parent; spacing: 15; Text { text: "BROWSE MEDIA"; color: "#00FFFF"; font.bold: true; font.pixelSize: 16 } }
                MouseArea { anchors.fill: parent; onClicked: folderDialog.open() }
            }
        }
    }

    Item {
        id: mainPlayerInterface
        anchors.fill: parent; anchors.margins: 20
        visible: mainWindow.isMediaLoaded

        Item {
            id: leftPanel
            width: parent.width * 0.6
            anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.left: parent.left;

            // MouseArea kích hoạt controls khi click màn hình
            MouseArea {
                anchors.fill: parent
                enabled: root.isFullscreen
                onClicked: {
                    root.controlsVisible = !root.controlsVisible
                    // Timer tự restart nhờ binding ở trên
                }
            }

            ColumnLayout {
                anchors.fill: parent; spacing: 10

                Item {
                    Layout.fillHeight: true; Layout.fillWidth: true
                    Item {
                        id: mediaContainer
                        anchors.centerIn: parent
                        Rectangle {
                            anchors.fill: parent; color: "black"; clip: true
                            radius: root.isFullscreen ? 0 : 20
                            border.color: "#333"; border.width: root.isFullscreen ? 0 : 1

                            VideoOutput {
                                id: videoOutput
                                anchors.fill: parent; fillMode: VideoOutput.PreserveAspectFit
                                visible: root.currentMediaType === "video"

                            }
                            Binding { target: mainWindow.player; property: "videoOutput"; value: videoOutput; when: root.visible }

                            Image {
                                id: albumArtImg
                                anchors.fill: parent; fillMode: Image.PreserveAspectCrop


                                source: mainWindow.player.metaData.coverArtImage ? mainWindow.player.metaData.coverArtImage : ""
                            }
                            Text {
                                text: "♫"; color: "#00FFFF"; font.pixelSize: 100; anchors.centerIn: parent; opacity: 0.5;
                                visible: albumArtImg.visible && !mainWindow.player.metaData.coverArtImage
                            }
                        }
                        layer.enabled: !root.isFullscreen
                        layer.effect: MultiEffect { shadowEnabled: true; shadowColor: "#00FFFF"; shadowBlur: 0.8; shadowOpacity: 0.5 }
                    }
                }

                // 2. CONTROL AREA
                Item {
                    id: controlArea
                    Layout.preferredHeight: 160; Layout.fillWidth: true

                    // [FIX 3] MOUSE AREA BAO QUANH CONTROLS
                    // Để phát hiện hover -> chặn auto hide
                    MouseArea {
                        id: controlMouseArea
                        anchors.fill: parent
                        hoverEnabled: true // Bắt buộc để bắt sự kiện hover
                        propagateComposedEvents: true // Cho phép click xuyên qua để bấm nút con
                        onPressed: (mouse) => mouse.accepted = false // Không chặn click của con
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: root.isFullscreen ? "#AA000000" : "transparent"
                        radius: 20
                    }

                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 10

                        Text {
                            text: {
                                var t = mainWindow.player.metaData.stringValue(MediaMetaData.Title);
                                return t ? t : mainWindow.player.source.toString().split("/").pop().replace(/\.[^.]+$/, "") }
                            color: "white"; font.pixelSize: 22; font.bold: true; Layout.alignment: Qt.AlignHCenter; elide: Text.ElideRight; Layout.maximumWidth: parent.width * 0.9
                        }

                        Item {
                            Layout.preferredWidth: parent.width * 0.95; Layout.preferredHeight: 30; Layout.alignment: Qt.AlignHCenter
                            Text { text: mainWindow.formatTime(mainWindow.player.position); color: "#00FFFF"; font.bold: true; anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter }
                            Slider {
                                id: seekSlider
                                anchors.left: parent.left; anchors.right: parent.right; anchors.margins: 50; anchors.verticalCenter: parent.verticalCenter
                                from: 0; to: mainWindow.player.duration
                                Binding on value { value: mainWindow.player.position; when: !seekSlider.pressed }
                                onMoved: mainWindow.player.setPosition(value)
                                background: Rectangle { width: parent.availableWidth; height: 4; color: "#333"; radius: 2; anchors.centerIn: parent; Rectangle { width: parent.parent.visualPosition * parent.width; height: parent.height; color: "#00FFFF"; radius: 2 } }
                                handle: Rectangle { x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width); y: parent.topPadding + parent.availableHeight / 2 - height / 2; width: 16; height: 16; radius: 8; color: "#00FFFF"; border.color: "white"; scale: parent.pressed || parent.hovered ? 1.3 : 1.0 }
                            }
                            Text { text: mainWindow.formatTime(mainWindow.player.duration); color: "#666"; font.bold: true; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter }
                        }

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter; spacing: 20

                            Row {
                                spacing: 8
                                Text { text: "🔈"; color: "#888"; font.pixelSize: 16; anchors.verticalCenter: parent.verticalCenter }
                                Slider {
                                    id: volSlider
                                    width: 100
                                    anchors.verticalCenter: parent.verticalCenter
                                    from: 0; to: 1.0; value: mainWindow.audioOut.volume
                                    onMoved: mainWindow.audioOut.volume = value
                                    background: Rectangle { width: parent.availableWidth; height: 4; color: "#333"; radius: 2; anchors.centerIn: parent; Rectangle { width: parent.parent.visualPosition * parent.width; height: parent.height; color: "#00FFFF"; radius: 2 } }
                                    handle: Rectangle { x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width); y: parent.topPadding + parent.availableHeight / 2 - height / 2; width: 14; height: 14; radius: 7; color: "white" }
                                }
                            }

                            Item { width: 20 }

                            MediaButton { iconPath: "M6 6h2v12H6zm3.5 6l8.5 6V6z"; onClicked: mainWindow.prevSong() }
                            MediaButton {
                                iconPath: mainWindow.player.playbackState === MediaPlayer.PlayingState ? "M6 19h4V5H6v14zm8-14v14h4V5h-4z" : "M8 5v14l11-7z"
                                isBig: true
                                onClicked: mainWindow.player.playbackState === MediaPlayer.PlayingState ? mainWindow.player.pause() : mainWindow.player.play()
                            }
                            MediaButton { iconPath: "M6 18l8.5-6L6 6v12zM16 6v12h2V6h-2z"; onClicked: mainWindow.nextSong() }

                            Item { width: 20 }

                            Button {
                                id: fullScreenBtn
                                text: "⛶"
                                visible: false
                                background: Rectangle { color: "transparent"; border.color: "#00FFFF"; radius: 5 }
                                contentItem: Text { text: parent.text; color: "#00FFFF"; font.pixelSize: 24; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                                onClicked: root.isFullscreen = !root.isFullscreen
                                Layout.preferredWidth: 40; Layout.preferredHeight: 40
                            }
                        }
                    }
                }
            }
        }

        // --- RIGHT PANEL (PLAYLIST) ---
        Rectangle {
            id: rightPanel
            width: parent.width * 0.4; anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.right: parent.right; color: "transparent"
            Rectangle { width: 1; anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; color: "#333" }

            Row {
                id: playlistHeader
                anchors.top: parent.top;
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0
                Rectangle { width: 100; height: 35; color: root.currentMediaType === "music" ? "#00FFFF" : "#222"; radius: 5; Text { text: "MUSIC"; anchors.centerIn: parent; color: root.currentMediaType === "music" ? "black" : "#888"; font.bold: true } MouseArea { anchors.fill: parent; onClicked: root.currentMediaType = "music" } }
                Rectangle { width: 100; height: 35; color: root.currentMediaType === "video" ? "#00FFFF" : "#222"; radius: 5; Text { text: "VIDEO"; anchors.centerIn: parent; color: root.currentMediaType === "video" ? "black" : "#888"; font.bold: true } MouseArea { anchors.fill: parent; onClicked: root.currentMediaType = "video" } }
            }
            Button {
                text: "+"
                width: 35
                height: 35
                // 1. Reset padding to ensure the control doesn't reserve unnecessary space
                padding: 0
                background: Rectangle {
                    color: "transparent"
                    border.color: "#00FFFF"
                    radius: 5
                }
                contentItem: Text {
                    text: parent.text
                    color: "#00FFFF"
                    font.pixelSize: 24

                    anchors.centerIn: parent

                    // 2. Nudge the text down (try values between 1 and 3)
                    anchors.verticalCenterOffset: -2 // Negative often moves it UP, Positive moves DOWN.
                                                     // Note: In some coordinate systems +y is down.
                                                     // If it looks too high, try '2'. If too low, try '-2'.
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: folderDialog.open()
                anchors.right: parent.right
            }

            ListView {
                id: playlistView
                anchors.top: playlistHeader.bottom; anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; anchors.margins: 10; topMargin: 20
                clip: true; spacing: 10
                model: root.filteredList
                delegate: Rectangle {
                    width: playlistView.width; height: 60; radius: 10
                    property bool isActive: mainWindow.player.source.toString() === modelData
                    color: isActive ? "#2000FFFF" : "transparent"; border.color: isActive ? "#00FFFF" : "transparent"; border.width: 1
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            // [FIX 1] CẬP NHẬT INDEX CHÍNH XÁC KHI BẤM CHỌN BÀI
                            // Tìm index thực sự của bài này trong danh sách gốc (songList)
                            var realIndex = -1
                            for(var i=0; i<mainWindow.songList.length; i++) {
                                if(mainWindow.songList[i] === modelData) {
                                    realIndex = i
                                    break
                                }
                            }
                            if (realIndex !== -1) mainWindow.currentSongIndex = realIndex

                            mainWindow.player.source = modelData
                            mainWindow.player.play()
                        }
                    }
                    RowLayout {
                        anchors.fill: parent; anchors.margins: 15
                        Text {text: root.isVideo(modelData) ? "🎬" : "🎵"; font.pixelSize: 18; color: "#00FFFF" }
                        Column { Layout.fillWidth: true; Text { text: modelData.toString().split("/").pop().replace(/\.[^.]+$/, ""); color: isActive ? "#00FFFF" : "white"; font.bold: true; elide: Text.ElideRight; width: parent.width } }
                    }
                }
            }
        }
    }

    // Component MediaButton
    component MediaButton : Item {
        id: btnRoot; property string iconPath: ""; property bool isBig: false; signal clicked()
        width: isBig ? 64 : 48; height: width
        Rectangle { anchors.fill: parent; radius: width/2; color: "transparent"; border.color: btnRoot.isBig ? "#00FFFF" : "#666"; border.width: 2; layer.enabled: btnRoot.isBig; layer.effect: MultiEffect { shadowEnabled: true; shadowColor: "#00FFFF" } }
        Shape { anchors.centerIn: parent; width: 24; height: 24; scale: btnRoot.isBig ? 1.5 : 1.0; ShapePath { fillColor: btnRoot.isBig ? "#00FFFF" : "white"; strokeWidth: 0; PathSvg { path: btnRoot.iconPath } } }
        MouseArea { anchors.fill: parent; onClicked: btnRoot.clicked(); onPressed: btnRoot.scale = 0.9; onReleased: btnRoot.scale = 1.0 }
    }
}
