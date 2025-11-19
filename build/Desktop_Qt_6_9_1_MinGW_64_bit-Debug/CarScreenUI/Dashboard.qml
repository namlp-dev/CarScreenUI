import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    property bool isDarkMode: true

    property int speed: 65
    property int maxSpeed: 180
    property real speedAngle: -135 + (speed / maxSpeed) * 270

    Rectangle {
        anchors.fill: parent
        color: isDarkMode ? "#000000" : "transparent"
        gradient: isDarkMode ? null : lightGradient
        Gradient {
            id: lightGradient
            GradientStop { position: 0.0; color: "#f5f3ff" }
            GradientStop { position: 1.0; color: "#ecfeff" }
        }
    }

    // Animated backgrounds
    Rectangle {
        x: parent.width / 3
        y: parent.height / 4
        width: 256
        height: 256
        radius: 128
        color: isDarkMode ? "#1a06b6d4" : "#4d06b6d4"
        layer.enabled: true

        SequentialAnimation on scale {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 1.2; duration: 4000; easing.type: Easing.InOutQuad }
            NumberAnimation { to: 1.0; duration: 4000; easing.type: Easing.InOutQuad }
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 48

        // Speedometer
        Item {
            Layout.alignment: Qt.AlignHCenter
            width: 400
            height: 400

            scale: 0
            NumberAnimation on scale {
                to: 1
                duration: 800
                easing.type: Easing.OutBack
                running: true
            }

            // Outer glow
            Rectangle {
                anchors.fill: parent
                radius: 200
                color: "transparent"
                border.color: isDarkMode ? "#4d06b6d4" : "#7c3aed"
                border.width: 2
                opacity: 0.3
                layer.enabled: true
            }

            // Main ring
            Rectangle {
                anchors.fill: parent
                anchors.margins: 16
                radius: 192
                color: isDarkMode ? "#cc000000" : "#ccffffff"
                border.color: isDarkMode ? "#1a3f3f46" : "#4dd1d5db"
                border.width: 4

                // Speed markers
                Repeater {
                    model: 37

                    Rectangle {
                        required property int index
                        property real angle: -135 + (index * 7.5)
                        property bool isMajor: index % 4 === 0
                        property real speedValue: (index / 36) * 180
                        property bool isInRange: speedValue <= speed

                        x: parent.width / 2 - width / 2
                        y: parent.height / 2 - height / 2
                        transformOrigin: Item.Center

                        width: isMajor ? 4 : 2
                        height: isMajor ? 24 : 12
                        radius: 2

                        color: {
                            if (isMajor && isInRange) {
                                return isDarkMode ? "#06b6d4" : "#7c3aed"
                            } else if (isInRange) {
                                return isDarkMode ? "#4d06b6d4" : "#7c3aed"
                            } else {
                                return isDarkMode ? "#3f3f46" : "#d1d5db"
                            }
                        }

                        transform: [
                            Translate { x: 170 * Math.cos((angle - 90) * Math.PI / 180); y: 170 * Math.sin((angle - 90) * Math.PI / 180) },
                            Rotation { angle: parent.angle }
                        ]
                    }
                }

                // Speed numbers
                Repeater {
                    model: [0, 20, 40, 60, 80, 100, 120, 140, 160, 180]

                    Text {
                        required property int index
                        required property int modelData

                        property real angle: -135 + (index * 30)
                        property bool isActive: modelData <= speed

                        x: parent.width / 2 + 145 * Math.cos((angle - 90) * Math.PI / 180) - width / 2
                        y: parent.height / 2 + 145 * Math.sin((angle - 90) * Math.PI / 180) - height / 2

                        text: modelData
                        font.pixelSize: 14
                        color: isActive ? (isDarkMode ? "#06b6d4" : "#7c3aed") : (isDarkMode ? "#52525b" : "#9ca3af")
                    }
                }

                // Center speed display
                Column {
                    anchors.centerIn: parent
                    spacing: 8

                    Text {
                        text: speed
                        font.pixelSize: 96
                        color: isDarkMode ? "#06b6d4" : "#7c3aed"
                        anchors.horizontalCenter: parent.horizontalCenter

                        SequentialAnimation on opacity {
                            running: true
                            loops: Animation.Infinite
                            NumberAnimation { to: 1.0; duration: 2000 }
                            NumberAnimation { to: 0.7; duration: 2000 }
                        }
                    }

                    Text {
                        text: "mph"
                        font.pixelSize: 18
                        color: isDarkMode ? "#06b6d4" : "#0891b2"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: "AVG: 58 mph"
                        font.pixelSize: 12
                        color: isDarkMode ? "#71717a" : "#9ca3af"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // Needle
                Rectangle {
                    id: needle
                    width: 140
                    height: 4
                    x: parent.width / 2
                    y: parent.height / 2 - height / 2
                    transformOrigin: Item.Left

                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: isDarkMode ? "#06b6d4" : "#7c3aed" }
                        GradientStop { position: 0.5; color: isDarkMode ? "#a855f7" : "#ec4899" }
                        GradientStop { position: 1.0; color: "transparent" }
                    }

                    radius: 2
                    rotation: speedAngle

                    Behavior on rotation {
                        SpringAnimation { spring: 2; damping: 0.2; mass: 1 }
                    }

                    Rectangle {
                        width: 12
                        height: 12
                        radius: 6
                        color: isDarkMode ? "#a855f7" : "#ec4899"
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // Center hub
                Rectangle {
                    width: 32
                    height: 32
                    radius: 16
                    anchors.centerIn: parent
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: isDarkMode ? "#06b6d4" : "#7c3aed" }
                        GradientStop { position: 1.0; color: isDarkMode ? "#a855f7" : "#ec4899" }
                    }

                    Rectangle {
                        width: 16
                        height: 16
                        radius: 8
                        anchors.centerIn: parent
                        color: isDarkMode ? "#000000" : "#ffffff"
                    }
                }
            }
        }

        // Info Cards
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 24

            InfoCard {
                icon: "⛽"
                value: "248"
                unit: "miles"
                cardColor: isDarkMode ? "#3306b6d4" : "#cce7fffe"
                textColor: isDarkMode ? "#06b6d4" : "#0891b2"
                isDark: isDarkMode
            }

            InfoCard {
                icon: "🔋"
                value: "78%"
                unit: "battery"
                cardColor: isDarkMode ? "#3322c55e" : "#ccd1fae5"
                textColor: isDarkMode ? "#4ade80" : "#16a34a"
                isDark: isDarkMode
            }

            InfoCard {
                icon: "🌡"
                value: "72°F"
                unit: "engine"
                cardColor: isDarkMode ? "#33f97316" : "#ccfed7aa"
                textColor: isDarkMode ? "#fb923c" : "#ea580c"
                isDark: isDarkMode
            }

            InfoCard {
                icon: "⚡"
                value: "45"
                unit: "kwh"
                cardColor: isDarkMode ? "#33eab308" : "#ccfef08a"
                textColor: isDarkMode ? "#facc15" : "#ca8a04"
                isDark: isDarkMode
            }
        }
    }

    component InfoCard: Rectangle {
        property string icon: ""
        property string value: ""
        property string unit: ""
        property color cardColor: "#06b6d4"
        property color textColor: "#06b6d4"
        property bool isDark: true

        width: 180
        height: 140
        radius: 16
        color: cardColor
        border.color: textColor
        border.width: 1

        scale: 1.0

        Behavior on scale {
            NumberAnimation { duration: 200; easing.type: Easing.OutBack }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.scale = 1.05
            onExited: parent.scale = 1.0
            onPressed: parent.scale = 0.95
            onReleased: parent.scale = 1.05
        }

        Column {
            anchors.centerIn: parent
            spacing: 12

            Text {
                text: icon
                font.pixelSize: 32
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: value
                font.pixelSize: 28
                color: textColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: unit
                font.pixelSize: 14
                color: isDark ? "#71717a" : "#6b7280"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
