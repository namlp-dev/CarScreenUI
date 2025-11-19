import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: root
    width: 1920
    height: 1080
    visible: true
    title: "Car Screen UI"

    property string activeView: "dashboard"
    property bool isDarkMode: true

    color: isDarkMode ? "#000000" : "#f5f3ff"

    // Background gradient overlays
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: isDarkMode ? "#1a9d6f33" : "#ddd6fe" }
            GradientStop { position: 0.5; color: isDarkMode ? "#000000" : "#ffffff" }
            GradientStop { position: 1.0; color: isDarkMode ? "#1a06b6d4" : "#cffafe" }
        }
    }

    // Animated background blobs
    Rectangle {
        x: parent.width / 4
        y: parent.height / 4
        width: 384
        height: 384
        radius: 192
        color: isDarkMode ? "#339d6f33" : "#669d6f66"

        SequentialAnimation on scale {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 1.2; duration: 4000; easing.type: Easing.InOutQuad }
            NumberAnimation { to: 1.0; duration: 4000; easing.type: Easing.InOutQuad }
        }

        SequentialAnimation on opacity {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 0.5; duration: 4000; easing.type: Easing.InOutQuad }
            NumberAnimation { to: 0.3; duration: 4000; easing.type: Easing.InOutQuad }
        }

        layer.enabled: true
        layer.effect: ShaderEffect {
            property real blurRadius: 48
        }
    }

    Rectangle {
        x: parent.width * 3 / 4
        y: parent.height * 3 / 4
        width: 384
        height: 384
        radius: 192
        color: isDarkMode ? "#3306b6d4" : "#6606b6d4"

        SequentialAnimation on scale {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 1.0; duration: 4000; easing.type: Easing.InOutQuad }
            NumberAnimation { to: 1.2; duration: 4000; easing.type: Easing.InOutQuad }
        }

        SequentialAnimation on opacity {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 0.3; duration: 4000; easing.type: Easing.InOutQuad }
            NumberAnimation { to: 0.5; duration: 4000; easing.type: Easing.InOutQuad }
        }

        layer.enabled: true
        layer.effect: ShaderEffect {
            property real blurRadius: 48
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Status Bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: isDarkMode ? "#80000000" : "#80ffffff"
            border.color: isDarkMode ? "#4d06b6d4" : "#4da855f7"
            border.width: 1

            layer.enabled: true

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 24
                anchors.rightMargin: 24

                Text {
                    text: "10:24 AM"
                    color: isDarkMode ? "#06b6d4" : "#7c3aed"
                    font.pixelSize: 16
                }

                Text {
                    text: "72°F"
                    color: isDarkMode ? "#a855f7" : "#0891b2"
                    font.pixelSize: 16
                    Layout.leftMargin: 24
                }

                Item { Layout.fillWidth: true }

                // Theme Toggle
                Button {
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 40

                    background: Rectangle {
                        color: isDarkMode ? "#3306b6d4" : "#e9d5ff"
                        border.color: isDarkMode ? "#4d06b6d4" : "#a855f7"
                        border.width: 1
                        radius: 8
                    }

                    contentItem: Row {
                        spacing: 8
                        anchors.centerIn: parent

                        Text {
                            text: isDarkMode ? "☀" : "☾"
                            color: isDarkMode ? "#06b6d4" : "#7c3aed"
                            font.pixelSize: 16
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    onClicked: isDarkMode = !isDarkMode

                    Behavior on scale {
                        NumberAnimation { duration: 100 }
                    }

                    onPressed: scale = 0.95
                    onReleased: scale = 1.0
                }

                Rectangle {
                    width: 8
                    height: 8
                    radius: 4
                    color: isDarkMode ? "#4ade80" : "#22c55e"

                    SequentialAnimation on opacity {
                        running: true
                        loops: Animation.Infinite
                        NumberAnimation { to: 1.0; duration: 1000 }
                        NumberAnimation { to: 0.5; duration: 1000 }
                    }
                }

                Text {
                    text: "Connected"
                    color: isDarkMode ? "#4ade80" : "#16a34a"
                    font.pixelSize: 16
                    Layout.leftMargin: 8
                }

                Text {
                    text: "78%"
                    color: isDarkMode ? "#06b6d4" : "#0891b2"
                    font.pixelSize: 16
                    Layout.leftMargin: 16
                }
            }
        }

        // Main Content Area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Loader {
                id: contentLoader
                anchors.fill: parent
                source: {
                    switch(activeView) {
                        case "dashboard": return "Dashboard.qml"
                        case "media": return "MediaPlayer.qml"
                        case "navigation": return "Navigation.qml"
                        case "climate": return "ClimateControl.qml"
                        default: return "Dashboard.qml"
                    }
                }

                onLoaded: {
                    if (item) {
                        item.isDarkMode = Qt.binding(() => root.isDarkMode)
                    }
                }
            }
        }

        // Bottom Navigation
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            color: isDarkMode ? "#80000000" : "#80ffffff"
            border.color: isDarkMode ? "#4d06b6d4" : "#4da855f7"
            border.width: 1

            layer.enabled: true

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 24
                anchors.rightMargin: 24
                spacing: 0

                NavButton {
                    Layout.fillWidth: true
                    text: "Dashboard"
                    icon: "📊"
                    isActive: activeView === "dashboard"
                    isDark: isDarkMode
                    accentColor: "#06b6d4"
                    onClicked: activeView = "dashboard"
                }

                NavButton {
                    Layout.fillWidth: true
                    text: "Navigation"
                    icon: "🗺"
                    isActive: activeView === "navigation"
                    isDark: isDarkMode
                    accentColor: "#a855f7"
                    onClicked: activeView = "navigation"
                }

                NavButton {
                    Layout.fillWidth: true
                    text: "Media"
                    icon: "🎵"
                    isActive: activeView === "media"
                    isDark: isDarkMode
                    accentColor: "#ec4899"
                    onClicked: activeView = "media"
                }

                NavButton {
                    Layout.fillWidth: true
                    text: "Climate"
                    icon: "💨"
                    isActive: activeView === "climate"
                    isDark: isDarkMode
                    accentColor: "#3b82f6"
                    onClicked: activeView = "climate"
                }

                NavButton {
                    Layout.fillWidth: true
                    text: "Settings"
                    icon: "⚙"
                    isActive: activeView === "settings"
                    isDark: isDarkMode
                    accentColor: "#22c55e"
                    onClicked: activeView = "settings"
                }
            }
        }
    }

    component NavButton: Button {
        id: navBtn
        property string icon: ""
        property bool isActive: false
        property bool isDark: true
        property color accentColor: "#06b6d4"

        background: Rectangle {
            color: isActive ? (isDark ? accentColor + "33" : accentColor + "33") : "transparent"
            border.color: isActive ? accentColor : "transparent"
            border.width: isActive ? 1 : 0
            radius: 12
        }

        contentItem: Column {
            spacing: 4
            anchors.centerIn: parent

            Text {
                text: icon
                font.pixelSize: 24
                color: isActive ? accentColor : (isDark ? "#71717a" : "#a1a1aa")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: navBtn.text
                font.pixelSize: 12
                color: isActive ? accentColor : (isDark ? "#71717a" : "#a1a1aa")
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        scale: 1.0

        Behavior on scale {
            NumberAnimation { duration: 100; easing.type: Easing.OutBack }
        }

        onPressed: scale = 0.95
        onReleased: scale = 1.1
        // onExited: scale = 1.0
    }
}
