import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes
import Qt.labs.platform 1.1
import QtMultimedia

Item {
    id: root

    FolderDialog {
        id: folderDialog
        title: "Select Music Folder"
        currentFolder: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]
        onAccepted: {
            // Log ra để debug xem mainWindow có tìm thấy fileScanner chưa
            console.log("Scanning folder:", currentFolder)

            // mainWindow được tham chiếu từ ID của Window trong Main.qml
            var files = mainWindow.fileScanner.scanForMp3(currentFolder)

            console.log("Files found:", files.length) // Debug số lượng file

            if (files.length > 0) {
                // ... (Logic cũ giữ nguyên)
                mainWindow.songList = files
                mainWindow.isMediaLoaded = true
                mainWindow.currentSongIndex = 0
                mainWindow.player.source = mainWindow.songList[0]
                mainWindow.player.play()
            }
        }
    }

    // 1. MÀN HÌNH CHỜ (BROWSE)
    Item {
        anchors.fill: parent
        visible: !mainWindow.isMediaLoaded // Check biến toàn cục
        z: 10
        // ... (Giữ nguyên UI Browse Folder, chỉ copy lại phần hiển thị)
        Column {
             anchors.centerIn: parent; spacing: 30
             Text { text: "NO MEDIA SOURCE"; color: "#666"; font.pixelSize: 24; font.bold: true; font.letterSpacing: 4; anchors.horizontalCenter: parent.horizontalCenter }
             Rectangle {
                 width: 260; height: 60; radius: 30; color: "transparent"; border.color: "#00FFFF"; border.width: 2; anchors.horizontalCenter: parent.horizontalCenter
                 layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowColor: "#00FFFF"; shadowBlur: 1.0; SequentialAnimation on shadowOpacity { loops: Animation.Infinite; PropertyAnimation { to: 0.4; duration: 1000 } PropertyAnimation { to: 1.0; duration: 1000 } } }
                 Row { anchors.centerIn: parent; spacing: 15; Shape { width: 24; height: 24; ShapePath { fillColor: "#00FFFF"; strokeWidth: 0; PathSvg { path: "M20 6h-8l-2-2H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2zm0 12H4V8h16v10z" } } } Text { text: "BROWSE FOLDER"; color: "#00FFFF"; font.bold: true; font.pixelSize: 16 } }
                 MouseArea { anchors.fill: parent; hoverEnabled: true; onEntered: parent.color = "#1000FFFF"; onExited: parent.color = "transparent"; onClicked: folderDialog.open() }
             }
         }
    }

    // 2. GIAO DIỆN PLAYER
    Item {
        id: mainPlayerInterface
        anchors.fill: parent
        z: 20
        visible: mainWindow.isMediaLoaded
        opacity: visible ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 500 } }

        // --- LEFT PANEL ---
        Item {
            id: leftPanel
            width: parent.width * 0.6
            anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.left: parent.left

            ColumnLayout {
                anchors.fill: parent; anchors.margins: 20; spacing: 15
                Item { Layout.fillHeight: true; Layout.minimumHeight: 10 }

                // ALBUM ART (Trỏ vào mainWindow.player)
                Item {
                    id: albumArtContainer
                    Layout.preferredWidth: Math.min(leftPanel.width * 0.7, leftPanel.height * 0.55); Layout.preferredHeight: Layout.preferredWidth; Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Rectangle {
                        anchors.fill: parent; radius: 20; border.color: "#333"; border.width: 1; clip: true
                        gradient: Gradient { orientation: Gradient.Vertical; GradientStop { position: 0.0; color: "#FF00CC" } GradientStop { position: 1.0; color: "#333399" } }
                        Image { anchors.fill: parent; fillMode: Image.PreserveAspectCrop; source: mainWindow.player.metaData.coverArtUrl ? mainWindow.player.metaData.coverArtUrl : ""; visible: mainWindow.player.metaData.coverArtUrl ? true : false }
                        Text { text: "♫"; color: "white"; font.pixelSize: parent.width * 0.4; anchors.centerIn: parent; opacity: 0.2; visible: !mainWindow.player.metaData.coverArtUrl }
                    }
                    layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowColor: "#FF00CC"; shadowBlur: 1.0; shadowOpacity: 0.5 }
                }

                // INFO TEXT
                Column {
                    Layout.alignment: Qt.AlignHCenter; Layout.fillWidth: true; spacing: 5
                    Text {
                        text: {
                            var title = mainWindow.player.metaData.stringValue(MediaMetaData.Title)
                            if (title) return title
                            var fileName = mainWindow.player.source.toString().split("/").pop()
                            return fileName.replace(".mp3", "")
                        }
                        color: "white"; font.pixelSize: Math.max(20, Math.min(28, leftPanel.width * 0.04)); font.bold: true; anchors.horizontalCenter: parent.horizontalCenter; elide: Text.ElideRight; width: leftPanel.width * 0.9; horizontalAlignment: Text.AlignHCenter
                    }
                    Text {
                        text: {
                            // mainWindow.player.metaData.stringValue(MediaMetaData.Author) ? mainWindow.player.metaData.stringValue(MediaMetaData.Author) : "Unknown Artist";
                            var artist = mainWindow.player.metaData.stringValue(MediaMetaData.ContributingArtist)
                            if (!artist) artist = mainWindow.player.metaData.stringValue(MediaMetaData.Author)
                            return artist ? artist : "Unknown Artist"
                        }
                        color: "#888"; font.pixelSize: 18; anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // SEEK BAR
                Item {
                    // Tăng chiều cao lên 40 để dễ chạm hơn
                    Layout.preferredWidth: leftPanel.width * 0.85
                    Layout.preferredHeight: 40
                    Layout.alignment: Qt.AlignHCenter

                    // Thời gian hiện tại
                    Text {
                        text: mainWindow.formatTime(mainWindow.player.position)
                        color: "#00FFFF"; font.pixelSize: 12; font.bold: true
                        anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                    }

                    Slider {
                        id: seekSlider // Bắt buộc phải có ID này
                        anchors.left: parent.left; anchors.leftMargin: 45
                        anchors.right: parent.right; anchors.rightMargin: 45
                        anchors.verticalCenter: parent.verticalCenter

                        from: 0
                        to: mainWindow.player.duration

                        // Ý nghĩa: Chỉ cập nhật slider theo nhạc khi tay bạn KHÔNG chạm vào nó
                        Binding on value {
                            value: mainWindow.player.position
                            when: !seekSlider.pressed
                        }

                        // Khi kéo xong hoặc đang kéo thì set vị trí nhạc
                        onMoved: mainWindow.player.setPosition(value)

                        background: Rectangle {
                            x: parent.leftPadding
                            y: parent.topPadding + parent.availableHeight / 2 - height / 2
                            width: parent.availableWidth; height: 4; radius: 2; color: "#333"
                            Rectangle {
                                width: parent.parent.visualPosition * parent.width
                                height: parent.height; color: "#00FFFF"; radius: 2
                                layer.enabled: true
                                layer.effect: MultiEffect { shadowEnabled: true; shadowColor: "#00FFFF"; shadowBlur: 0.5 }
                            }
                        }

                        // Nút kéo to lên chút cho dễ bấm
                        handle: Rectangle {
                            x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                            y: parent.topPadding + parent.availableHeight / 2 - height / 2
                            width: 20; height: 20; radius: 10 // Tăng size handle
                            color: "#00FFFF"; border.color: "white"; border.width: 2
                            scale: parent.pressed ? 1.3 : 1.0
                            Behavior on scale { NumberAnimation { duration: 100 } }
                        }
                    }

                    // Tổng thời gian
                    Text {
                        text: mainWindow.formatTime(mainWindow.player.duration)
                        color: "#666"; font.pixelSize: 12; font.bold: true
                        anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // CONTROLS
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter; Layout.fillWidth: true; Layout.maximumWidth: 500; spacing: 20
                    Item { Layout.fillWidth: true }
                    Row {
                        spacing: 25
                        MediaButton { iconPath: "M6 6h2v12H6zm3.5 6l8.5 6V6z"; onClicked: mainWindow.prevSong() }
                        MediaButton {
                            iconPath: mainWindow.player.playbackState === MediaPlayer.PlayingState ? "M6 19h4V5H6v14zm8-14v14h4V5h-4z" : "M8 5v14l11-7z"
                            isBig: true
                            onClicked: mainWindow.player.playbackState === MediaPlayer.PlayingState ? mainWindow.player.pause() : mainWindow.player.play()
                        }
                        MediaButton { iconPath: "M6 18l8.5-6L6 6v12zM16 6v12h2V6h-2z"; onClicked: mainWindow.nextSong() }
                    }
                    Item { width: 20 }
                    Row {
                        spacing: 10
                        Shape { width: 20; height: 20; anchors.verticalCenter: parent.verticalCenter; ShapePath { fillColor: "#888"; strokeWidth: 0; PathSvg { path: "M3 9v6h4l5 5V4L7 9H3zm13.5 3c0-1.77-1.02-3.29-2.5-4.03v8.05c1.48-.73 2.5-2.25 2.5-4.02z" } } }

                        Slider {
                            id: volSlider // [QUAN TRỌNG] Đặt ID
                            width: 100
                            anchors.verticalCenter: parent.verticalCenter
                            from: 0; to: 1

                            // [FIX LỖI KẸT VOLUME]: Tương tự như Seekbar
                            Binding on value {
                                value: mainWindow.audioOut.volume
                                when: !volSlider.pressed
                            }

                            onMoved: mainWindow.audioOut.volume = value

                            background: Rectangle { x: parent.leftPadding; y: parent.topPadding + parent.availableHeight / 2 - height / 2; width: parent.availableWidth; height: 4; radius: 2; color: "#333"; Rectangle { width: parent.parent.visualPosition * parent.width; height: parent.height; color: "#00FFFF"; radius: 2 } }
                            handle: Rectangle { x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width); y: parent.topPadding + parent.availableHeight / 2 - height / 2; width: 12; height: 12; radius: 6; color: "#00FFFF"; border.color: "white"; border.width: 1 }
                        }
                    }
                    Item { Layout.fillWidth: true }
                }
                Item { Layout.fillHeight: true; Layout.minimumHeight: 20 }
            }
        }

        // --- RIGHT PANEL (PLAYLIST) ---
        Rectangle {
            id: rightPanel
            width: parent.width * 0.4; anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.right: parent.right; color: "#00000000"
            Rectangle { width: 1; anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; gradient: Gradient { orientation: Gradient.Vertical; GradientStop { position: 0.0; color: "transparent" } GradientStop { position: 0.5; color: "#333" } GradientStop { position: 1.0; color: "transparent" } } }

            Button { text: "📂"; anchors.right: parent.right; anchors.top: parent.top; anchors.margins: 10; width: 40; height: 40; background: Rectangle { color: "transparent" } contentItem: Text { text: parent.text; font.pixelSize: 20; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } onClicked: folderDialog.open() }
            Item { id: playlistHeader; height: 80; anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; anchors.margins: 10; Text { text: "PLAYLIST (" + mainWindow.songList.length + ")"; color: "#666"; font.bold: true; font.pixelSize: 14; anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter } }

            ListView {
                id: playlistView
                anchors.top: playlistHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 20
                clip: true
                spacing: 10

                model: mainWindow.songList

                // --- [MỚI] TỰ ĐỘNG CUỘN KHI ĐỔI BÀI ---
                Connections {
                    target: mainWindow // Lắng nghe Main Window
                    function onCurrentSongIndexChanged() {
                        // Kiểm tra index hợp lệ
                        if (mainWindow.currentSongIndex >= 0 && mainWindow.currentSongIndex < playlistView.count) {
                            // ListView.Center: Đưa bài đang hát vào giữa danh sách
                            // ListView.Contain: Chỉ cuộn nếu bài đó đang bị che khuất
                            playlistView.positionViewAtIndex(mainWindow.currentSongIndex, ListView.Center)
                        }
                    }
                }
                // --------------------------------------

                delegate: Rectangle {
                    // ... (Giữ nguyên code delegate cũ)
                    width: playlistView.width; height: 60; radius: 10
                    property bool isActive: index === mainWindow.currentSongIndex
                    color: isActive ? "#2000FFFF" : "transparent"; border.color: isActive ? "#00FFFF" : "transparent"; border.width: 1
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            mainWindow.currentSongIndex = index
                            mainWindow.player.source = modelData
                            mainWindow.player.play()
                        }
                    }
                    RowLayout {
                        anchors.fill: parent; anchors.leftMargin: 15; anchors.rightMargin: 15
                        Item {
                            width: 20; height: 20
                            visible: isActive // Chỉ hiện khi bài này đang hát

                            Row {
                                spacing: 2
                                anchors.centerIn: parent
                                anchors.verticalCenterOffset: 4 // Căn chỉnh lại chút cho đẹp

                                Repeater {
                                    model: 3
                                    Rectangle {
                                        width: 3
                                        color: "#00FFFF"
                                        // Chiều cao khởi điểm
                                        height: 5
                                        radius: 1.5

                                        // Animation làm cho thanh nhảy lên xuống
                                        SequentialAnimation on height {
                                            running: isActive && mainWindow.player.playbackState === MediaPlayer.PlayingState
                                            loops: Animation.Infinite
                                            // Mỗi thanh nhảy với tốc độ khác nhau dựa trên index để ko bị đồng bộ
                                            PropertyAnimation { to: 18; duration: 250 + (index * 50); easing.type: Easing.InOutQuad }
                                            PropertyAnimation { to: 5;  duration: 250 + (index * 50); easing.type: Easing.InOutQuad }
                                        }
                                    }
                                }
                            }
                        }
                        Text { text: index + 1; color: "#666"; visible: !isActive; font.bold: true; Layout.preferredWidth: 20 }
                        Column {
                            Layout.fillWidth: true;
                            Text {
                                text: modelData.toString().split("/").pop().replace(".mp3", "")
                                color: isActive ? "#00FFFF" : "white"
                                font.bold: true
                                font.pixelSize: 14

                                width: parent.width * 0.9
                                elide: Text.ElideRight
                                wrapMode: Text.NoWrap
                            }

                            // Text { text: "Unknown Artist"; color: "#666"; font.pixelSize: 12 }
                        }
                        Text {
                            // text: isActive ? mainWindow.formatTime(mainWindow.player.duration) : "--:--";
                            text: mainWindow.formatTime(mainWindow.player.duration);
                            color: "#666"; font.pixelSize: 14
                        }
                    }
                }
            }
        }
    }

    // Component MediaButton giữ nguyên (nhớ code fix lỗi ID trước đó)
    component MediaButton : Item {
        id: btnRoot // [QUAN TRỌNG] Đặt ID để tham chiếu chính xác

        property string iconPath: ""
        property bool isBig: false
        signal clicked()

        width: isBig ? 64 : 48; height: width

        // 1. Vòng tròn viền (Background)
        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: "transparent"
            border.color: btnRoot.isBig ? "#00FFFF" : "#666" // Dùng btnRoot
            border.width: 2

            layer.enabled: btnRoot.isBig
            layer.effect: MultiEffect {
                shadowEnabled: true; shadowColor: "#00FFFF"; shadowBlur: 0.5
            }
        }

        // 2. Icon bên trong (Shape)
        Shape {
            anchors.centerIn: parent
            width: 24; height: 24
            scale: btnRoot.isBig ? 1.5 : 1.0 // Dùng btnRoot

            ShapePath {
                // Màu icon: Cyan nếu nút to, Trắng nếu nút nhỏ
                fillColor: btnRoot.isBig ? "#00FFFF" : "white"
                strokeWidth: 0 // Icon dạng fill nên không cần stroke

                // [SỬA LỖI TẠI ĐÂY] Gọi trực tiếp qua ID btnRoot
                PathSvg { path: btnRoot.iconPath }
            }
        }

        // 3. Xử lý click
        MouseArea {
            anchors.fill: parent
            onClicked: btnRoot.clicked()
            onPressed: btnRoot.scale = 0.9
            onReleased: btnRoot.scale = 1.0
        }
    }
}
