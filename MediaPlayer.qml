import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    property bool isDarkMode: true
    property bool isPlaying: true
    property bool isLiked: false
    property int volume: 65

    Rectangle {
        anchors.fill: parent
        color: isDarkMode ? "#000000" : "transparent"
        gradient: isDarkMode ? null : lightGradient
        Gradient {
            id: lightGradient
            GradientStop { position: 0.0; color: "#fdf4ff" }
            GradientStop { position: 1.0; color: "#fce7f3" }
        }

    }

    // Animated background blobs
    Rectangle {
        x: parent.width / 4
        y: 0
        width: 384
        height: 384
        radius: 192
        color: isDarkMode ? "#33ec4899" : "#66db2777"

        SequentialAnimation on scale {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 1.3; duration: 5000; easing.type: Easing.InOutQuad }
            NumberAnimation { to: 1.0; duration: 5000; easing.type: Easing.InOutQuad }
        }

        NumberAnimation on x {
            from: parent.width / 4
            to: parent.width / 4 + 50
            duration: 5000
            easing.type: Easing.InOutQuad
            loops: Animation.Infinite
            onStopped: {
                from = parent.width / 4 + 50
                to = parent.width / 4
                restart()
            }
        }

        layer.enabled: true
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 32
        spacing: 32

        // Now Playing
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 32

                // Album Art
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 320
                    height: 320
                    radius: 16
                    color: "#a855f7"

                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#a855f7" }
                        GradientStop { position: 1.0; color: "#ec4899" }
                    }

                    scale: 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 300; easing.type: Easing.OutBack }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.scale = 1.05
                        onExited: parent.scale = 1.0
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "🎵"
                        font.pixelSize: 96
                    }

                    // Pulse animation when playing
                    Rectangle {
                        visible: isPlaying
                        anchors.fill: parent
                        radius: 16
                        color: "transparent"
                        border.color: "#ec4899"
                        border.width: 4
                        opacity: 0

                        SequentialAnimation on opacity {
                            running: isPlaying
                            loops: Animation.Infinite
                            NumberAnimation { to: 0.5; duration: 2000; easing.type: Easing.OutQuad }
                            NumberAnimation { to: 0; duration: 0 }
                        }

                        SequentialAnimation on scale {
                            running: isPlaying
                            loops: Animation.Infinite
                            NumberAnimation { to: 1.1; duration: 2000; easing.type: Easing.OutQuad }
                            NumberAnimation { to: 1.0; duration: 0 }
                        }
                    }
                }

                // Song Info
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 8

                    Text {
                        text: "Night Drive"
                        font.pixelSize: 32
                        color: isDarkMode ? "#ec4899" : "#db2777"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: "Synthwave Dreams"
                        font.pixelSize: 20
                        color: isDarkMode ? "#d8b4fe" : "#a855f7"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // Progress Bar
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 640
                    spacing: 8

                    Slider {
                        width: parent.width
                        value: 45
                        from: 0
                        to: 100

                        background: Rectangle {
                            width: parent.width
                            height: 4
                            radius: 2
                            color: isDarkMode ? "#3f3f46" : "#e5e7eb"

                            Rectangle {
                                width: parent.width * (parent.parent.value / 100)
                                height: parent.height
                                radius: 2
                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position: 0.0; color: "#ec4899" }
                                    GradientStop { position: 1.0; color: "#a855f7" }
                                }
                            }
                        }

                        handle: Rectangle {
                            x: parent.visualPosition * (parent.width - width)
                            y: parent.height / 2 - height / 2
                            width: 16
                            height: 16
                            radius: 8
                            color: "#ec4899"
                        }
                    }

                    RowLayout {
                        width: parent.width

                        Text {
                            text: "1:42"
                            font.pixelSize: 14
                            color: isDarkMode ? "#71717a" : "#6b7280"
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: "3:45"
                            font.pixelSize: 14
                            color: isDarkMode ? "#71717a" : "#6b7280"
                        }
                    }
                }

                // Controls
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 24

                    Button {
                        text: "⏮"
                        font.pixelSize: 32

                        background: Rectangle { color: "transparent" }
                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: isDarkMode ? "#ec4899" : "#db2777"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        scale: 1.0
                        Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutBack } }
                        onPressed: scale = 0.9
                        onReleased: scale = 1.2
                        // onExited: scale = 1.0
                    }

                    Button {
                        width: 64
                        height: 64

                        background: Rectangle {
                            radius: 32
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#ec4899" }
                                GradientStop { position: 1.0; color: "#a855f7" }
                            }
                        }

                        contentItem: Text {
                            text: isPlaying ? "⏸" : "▶"
                            font.pixelSize: 32
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: isPlaying = !isPlaying

                        scale: 1.0
                        Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutBack } }
                        onPressed: scale = 0.95
                        onReleased: scale = 1.1
                        // onExited: scale = 1.0
                    }

                    Button {
                        text: "⏭"
                        font.pixelSize: 32

                        background: Rectangle { color: "transparent" }
                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: isDarkMode ? "#ec4899" : "#db2777"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        scale: 1.0
                        Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutBack } }
                        onPressed: scale = 0.9
                        onReleased: scale = 1.2
                        // onExited: scale = 1.0
                    }
                }

                // Volume
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 256
                    spacing: 16

                    Text {
                        text: "🔊"
                        font.pixelSize: 20
                        color: isDarkMode ? "#a855f7" : "#7c3aed"
                    }

                    Slider {
                        Layout.fillWidth: true
                        value: volume
                        from: 0
                        to: 100
                        onValueChanged: volume = value

                        background: Rectangle {
                            width: parent.width
                            height: 4
                            radius: 2
                            color: isDarkMode ? "#3f3f46" : "#e5e7eb"

                            Rectangle {
                                width: parent.width * (parent.parent.value / 100)
                                height: parent.height
                                radius: 2
                                color: "#a855f7"
                            }
                        }

                        handle: Rectangle {
                            x: parent.visualPosition * (parent.width - width)
                            y: parent.height / 2 - height / 2
                            width: 16
                            height: 16
                            radius: 8
                            color: "#a855f7"
                        }
                    }

                    Text {
                        text: volume + "%"
                        font.pixelSize: 14
                        color: isDarkMode ? "#a855f7" : "#7c3aed"
                        Layout.preferredWidth: 40
                    }
                }
            }
        }

        // Playlist
        Rectangle {
            Layout.preferredWidth: 384
            Layout.fillHeight: true
            radius: 16
            color: isDarkMode ? "#80000000" : "#80ffffff"
            border.color: isDarkMode ? "#4da855f7" : "#7c3aed"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 24

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Up Next"
                        font.pixelSize: 20
                        color: isDarkMode ? "#d8b4fe" : "#7c3aed"
                    }

                    Item { Layout.fillWidth: true }

                    Button {
                        text: "♥"
                        font.pixelSize: 24

                        background: Rectangle { color: "transparent" }
                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: isLiked ? "#ec4899" : (isDarkMode ? "#71717a" : "#9ca3af")
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: isLiked = !isLiked

                        scale: 1.0
                        Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutBack } }
                        onPressed: scale = 0.9
                        onReleased: scale = 1.2
                        // onExited: scale = 1.0
                    }
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 12
                    clip: true

                    model: ListModel {
                        ListElement { title: "Night Drive"; artist: "Synthwave Dreams"; duration: "3:45" }
                        ListElement { title: "Electric Sunset"; artist: "Neon Highways"; duration: "4:20" }
                        ListElement { title: "Midnight City"; artist: "Urban Echoes"; duration: "3:55" }
                        ListElement { title: "Tokyo Nights"; artist: "Digital Wave"; duration: "4:10" }
                    }

                    delegate: Rectangle {
                        required property string title
                        required property string artist
                        required property string duration

                        width: ListView.view.width
                        height: 80
                        radius: 12
                        color: "transparent"
                        border.color: isDarkMode ? "#4da855f7" : "#c4b5fd"
                        border.width: 0

                        scale: 1.0

                        Behavior on scale {
                            NumberAnimation { duration: 200; easing.type: Easing.OutBack }
                        }

                        Behavior on border.width {
                            NumberAnimation { duration: 200 }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                parent.scale = 1.02
                                parent.border.width = 1
                            }
                            onExited: {
                                parent.scale = 1.0
                                parent.border.width = 0
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 16

                            Rectangle {
                                width: 48
                                height: 48
                                radius: 8
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: "#3b82f6" }
                                    GradientStop { position: 1.0; color: "#a855f7" }
                                }
                            }

                            Column {
                                Layout.fillWidth: true
                                spacing: 4

                                Text {
                                    text: title
                                    font.pixelSize: 16
                                    color: isDarkMode ? "white" : "#18181b"
                                    elide: Text.ElideRight
                                    width: parent.width
                                }

                                Text {
                                    text: artist
                                    font.pixelSize: 14
                                    color: isDarkMode ? "#a855f7" : "#7c3aed"
                                    elide: Text.ElideRight
                                    width: parent.width
                                }
                            }

                            Text {
                                text: duration
                                font.pixelSize: 14
                                color: isDarkMode ? "#71717a" : "#6b7280"
                            }
                        }
                    }
                }
            }
        }
    }
}
