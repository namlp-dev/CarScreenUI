import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes

Item {
    id: root

    // Trạng thái Player
    property bool isPlaying: true
    property real volumeLevel: 0.7
    property string currentSongTitle: "Midnight City"
    property string currentArtist: "M83"

    // --- 1. KHU VỰC TRÁI: NOW PLAYING (60%) ---
    Item {
        id: leftPanel
        width: parent.width * 0.6
        anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.left: parent.left

        // A. Album Art (Đĩa than hoặc Bìa vuông)
        Item {
            id: albumArt
            width: 300; height: 300
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -40

            // SỬA LỖI: Dùng Rectangle với Gradient trực tiếp
            Rectangle {
                anchors.fill: parent
                radius: 20
                // Không cần color nền nữa vì đã có gradient
                border.color: "#333"
                border.width: 1

                // Gradient trực tiếp của Qt 6 (Tự động bo góc theo radius)
                gradient: Gradient {
                    orientation: Gradient.Vertical // Chỉnh chiều dọc (từ trên xuống)
                    GradientStop { position: 0.0; color: "#FF00CC" } // Purple Neon
                    GradientStop { position: 1.0; color: "#333399" } // Blue Neon
                }

                // Icon nốt nhạc ở giữa
                Text {
                    text: "♫"
                    color: "white"
                    font.pixelSize: 100
                    anchors.centerIn: parent
                    opacity: 0.2
                }
            }

            // Glow bao quanh (Giữ nguyên)
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true; shadowColor: "#FF00CC"; shadowBlur: 1.0; shadowOpacity: 0.5
            }
        }

        // B. Thông tin bài hát
        Column {
            anchors.top: albumArt.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5

            Text {
                text: root.currentSongTitle
                color: "white"
                font.pixelSize: 32
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: root.currentArtist
                color: "#888"
                font.pixelSize: 18
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // C. Visualizer (Sóng nhạc Neon) - Nằm nền sau Album Art
        Row {
            anchors.centerIn: parent
            spacing: 8
            z: -1 // Nằm sau bìa album
            opacity: 0.5

            Repeater {
                model: 20 // 20 thanh sóng
                delegate: Rectangle {
                    width: 15
                    height: 50 // Chiều cao cơ bản
                    color: "#00FFFF"
                    radius: 5
                    anchors.bottom: parent.bottom // Mọc từ dưới lên

                    // Animation thay đổi chiều cao ngẫu nhiên
                    SequentialAnimation on height {
                        loops: Animation.Infinite
                        running: root.isPlaying
                        PropertyAnimation {
                            to: Math.random() * 200 + 50 // Random độ cao
                            duration: Math.random() * 300 + 100
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
        }

        // D. Thanh điều khiển (Play/Pause, Volume)
        RowLayout {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 30

            // Nút Prev
            MediaButton { iconPath: "M6 6h2v12H6zm3.5 6l8.5 6V6z" } // SVG Prev

            // Nút Play/Pause (To hơn)
            MediaButton {
                iconPath: root.isPlaying ? "M6 19h4V5H6v14zm8-14v14h4V5h-4z" : "M8 5v14l11-7z"
                isBig: true
                onClicked: root.isPlaying = !root.isPlaying
            }

            // Nút Next
            MediaButton { iconPath: "M6 18l8.5-6L6 6v12zM16 6v12h2V6h-2z" } // SVG Next

            // Thanh Volume
            Row {
                Layout.leftMargin: 40 // Cách xa cụm nút
                spacing: 10

                // Icon loa
                Shape {
                    width: 20; height: 20
                    ShapePath {
                        fillColor: "#888"
                        strokeWidth: 0
                        PathSvg { path: "M3 9v6h4l5 5V4L7 9H3zm13.5 3c0-1.77-1.02-3.29-2.5-4.03v8.05c1.48-.73 2.5-2.25 2.5-4.02z" }
                    }
                }

                // Slider Custom
                Slider {
                    width: 150
                    from: 0; to: 1
                    value: root.volumeLevel

                    // Tùy biến thanh trượt style Neon
                    background: Rectangle {
                        x: parent.leftPadding
                        y: parent.topPadding + parent.availableHeight / 2 - height / 2
                        width: parent.availableWidth
                        height: 4
                        radius: 2
                        color: "#333"

                        Rectangle {
                            width: parent.parent.visualPosition * parent.width
                            height: parent.height
                            color: "#00FFFF"
                            radius: 2
                        }
                    }

                    handle: Rectangle {
                        x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                        y: parent.topPadding + parent.availableHeight / 2 - height / 2
                        width: 16; height: 16
                        radius: 8
                        color: "#00FFFF"
                        border.color: "white"
                        border.width: 1
                    }
                }
            }
        }
    }

    // --- 2. KHU VỰC PHẢI: PLAYLIST & SEARCH (40%) ---
    Rectangle {
        id: rightPanel
        width: parent.width * 0.4
        anchors.top: parent.top; anchors.bottom: parent.bottom; anchors.right: parent.right
        color: "#080808" // Nền tối hơn chút

        // Đường kẻ ngăn cách dọc
        Rectangle {
            width: 1; anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.5; color: "#333" }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        // Header: Tiêu đề & Nút Mic
        Item {
            id: playlistHeader
            height: 80
            anchors.top: parent.top
            anchors.left: parent.left; anchors.right: parent.right
            anchors.margins: 20

            Text {
                text: "UP NEXT"
                color: "#666"
                font.bold: true
                font.pixelSize: 14
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }

            // Nút Tìm Kiếm Giọng Nói
            Rectangle {
                width: 160; height: 40
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                radius: 20
                color: "#1A1A1A"
                border.color: "#333"

                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    // Icon Mic
                    Shape {
                        width: 16; height: 16
                        ShapePath {
                            fillColor: "#00FFFF" // Màu Mic Cyan
                            strokeWidth: 0
                            PathSvg { path: "M12 14c1.66 0 3-1.34 3-3V5c0-1.66-1.34-3-3-3S9 3.34 9 5v6c0 1.66 1.34 3 3 3z" }
                        }
                    }
                    Text { text: "Voice Search"; color: "white"; font.pixelSize: 14 }
                }

                // Hiệu ứng bấm
                MouseArea {
                    anchors.fill: parent
                    onPressed: parent.color = "#333"
                    onReleased: parent.color = "#1A1A1A"
                }
            }
        }

        // List Bài Hát
        ListView {
            id: playlistView
            anchors.top: playlistHeader.bottom
            anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
            anchors.margins: 20
            clip: true
            spacing: 10

            model: ListModel {
                ListElement { title: "Starboy"; artist: "The Weeknd"; duration: "3:50"; active: false }
                ListElement { title: "Blinding Lights"; artist: "The Weeknd"; duration: "3:20"; active: false }
                ListElement { title: "Nightcall"; artist: "Kavinsky"; duration: "4:18"; active: true } // Bài đang phát giả định trong list
                ListElement { title: "Tech Noir"; artist: "Gunship"; duration: "4:32"; active: false }
                ListElement { title: "Turbo Killer"; artist: "Carpenter Brut"; duration: "4:03"; active: false }
                ListElement { title: "Resonance"; artist: "Home"; duration: "3:32"; active: false }
            }

            delegate: Rectangle {
                width: playlistView.width
                height: 60
                radius: 10
                color: model.active ? "#112222" : "transparent" // Highlight bài đang active
                border.color: model.active ? "#00FFFF" : "transparent"
                border.width: 1

                // Hiệu ứng hover
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: if (!model.active) parent.color = "#111"
                    onExited: if (!model.active) parent.color = "transparent"
                    onClicked: {
                        // Logic chọn bài (giả lập)
                        root.currentSongTitle = model.title
                        root.currentArtist = model.artist
                        // Reset active state (cần logic phức tạp hơn ở backend thực tế)
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15; anchors.rightMargin: 15

                    // Equalizer icon nhỏ nếu đang active
                    Item {
                        width: 20; height: 20
                        visible: model.active
                        // Vẽ 3 thanh nhảy nhỏ
                        Row {
                            spacing: 2; anchors.centerIn: parent
                            Repeater {
                                model: 3
                                Rectangle { width: 3; height: 10 + Math.random()*10; color: "#00FFFF" }
                            }
                        }
                    }

                    // Số thứ tự (ẩn nếu đang active)
                    Text {
                        text: index + 1
                        color: "#666"
                        visible: !model.active
                        font.bold: true
                        Layout.preferredWidth: 20
                    }

                    Column {
                        Layout.fillWidth: true
                        Text { text: model.title; color: model.active ? "#00FFFF" : "white"; font.bold: true; font.pixelSize: 16 }
                        Text { text: model.artist; color: "#888"; font.pixelSize: 12 }
                    }

                    Text {
                        text: model.duration
                        color: "#666"
                        font.pixelSize: 14
                    }
                }
            }
        }
    }

    // --- COMPONENT BUTTON (Tái sử dụng) ---
    component MediaButton : Item {
        property string iconPath: ""
        property bool isBig: false
        signal clicked()

        width: isBig ? 64 : 48
        height: width

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: "transparent"
            border.color: isBig ? "#00FFFF" : "#666"
            border.width: 2

            // Glow cho nút Play to
            layer.enabled: isBig
            layer.effect: MultiEffect { shadowEnabled: true; shadowColor: "#00FFFF"; shadowBlur: 0.5 }
        }

        Shape {
            anchors.centerIn: parent
            width: 24; height: 24
            scale: isBig ? 1.5 : 1.0
            ShapePath {
                fillColor: isBig ? "#00FFFF" : "white"
                strokeWidth: 0
                PathSvg { path: parent.parent.iconPath }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: parent.clicked()
            onPressed: parent.scale = 0.9
            onReleased: parent.scale = 1.0
        }
    }
}
