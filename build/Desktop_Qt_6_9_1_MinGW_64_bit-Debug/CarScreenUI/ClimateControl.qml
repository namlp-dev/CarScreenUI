import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    property bool isDarkMode: true
    property int driverTemp: 72
    property int passengerTemp: 70
    property int fanSpeed: 3
    property bool isAuto: true
    property bool isRecirculate: false

    Rectangle {
        anchors.fill: parent
        color: isDarkMode ? "#000000" : "transparent"
        gradient: isDarkMode ? null : lightGradient
        Gradient {
            id: lightGradient
            GradientStop { position: 0.0; color: "#eff6ff" }
            GradientStop { position: 1.0; color: "#ecfeff" }
        }
    }

    // Animated background blobs
    Rectangle {
        x: parent.width / 4
        y: parent.height / 4
        width: 384
        height: 384
        radius: 192
        color: isDarkMode ? "#333b82f6" : "#663b82f6"

        SequentialAnimation on scale {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 1.3; duration: 4000; easing.type: Easing.InOutQuad }
            NumberAnimation { to: 1.0; duration: 4000; easing.type: Easing.InOutQuad }
        }

        layer.enabled: true
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width * 0.9
        spacing: 48

        // Temperature Controls
        RowLayout {
            Layout.fillWidth: true
            spacing: 32

            // Driver Side
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 280
                radius: 16
                color: isDarkMode ? "#8018181b" : "#80ffffff"
                border.color: isDarkMode ? "#4d06b6d4" : "#22d3ee"
                border.width: 1

                x: -50
                opacity: 0

                NumberAnimation on x {
                    to: 0
                    duration: 600
                    easing.type: Easing.OutBack
                    running: true
                }

                NumberAnimation on opacity {
                    to: 1
                    duration: 600
                    running: true
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 24

                    Text {
                        text: "Driver"
                        font.pixelSize: 18
                        color: isDarkMode ? "#06b6d4" : "#0891b2"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: driverTemp + "°"
                        font.pixelSize: 72
                        color: isDarkMode ? "#06b6d4" : "#7c3aed"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 16

                        TempButton {
                            icon: "❄"
                            buttonColor: isDarkMode ? "#333b82f6" : "#dbeafe"
                            iconColor: isDarkMode ? "#60a5f6" : "#1e40af"
                            onClicked: if (driverTemp > 60) driverTemp--
                        }

                        TempButton {
                            icon: "☀"
                            buttonColor: isDarkMode ? "#33ef4444" : "#fee2e2"
                            iconColor: isDarkMode ? "#ef4444" : "#dc2626"
                            onClicked: if (driverTemp < 85) driverTemp++
                        }
                    }
                }
            }

            // Passenger Side
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 280
                radius: 16
                color: isDarkMode ? "#8018181b" : "#80ffffff"
                border.color: isDarkMode ? "#4da855f7" : "#c084fc"
                border.width: 1

                x: 50
                opacity: 0

                NumberAnimation on x {
                    to: 0
                    duration: 600
                    easing.type: Easing.OutBack
                    running: true
                }

                NumberAnimation on opacity {
                    to: 1
                    duration: 600
                    running: true
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 24

                    Text {
                        text: "Passenger"
                        font.pixelSize: 18
                        color: isDarkMode ? "#a855f7" : "#7c3aed"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: passengerTemp + "°"
                        font.pixelSize: 72
                        color: isDarkMode ? "#a855f7" : "#ec4899"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 16

                        TempButton {
                            icon: "❄"
                            buttonColor: isDarkMode ? "#333b82f6" : "#dbeafe"
                            iconColor: isDarkMode ? "#60a5f6" : "#1e40af"
                            onClicked: if (passengerTemp > 60) passengerTemp--
                        }

                        TempButton {
                            icon: "☀"
                            buttonColor: isDarkMode ? "#33ef4444" : "#fee2e2"
                            iconColor: isDarkMode ? "#ef4444" : "#dc2626"
                            onClicked: if (passengerTemp < 85) passengerTemp++
                        }
                    }
                }
            }
        }

        // Fan Speed
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 160
            radius: 16
            color: isDarkMode ? "#8018181b" : "#80ffffff"
            border.color: isDarkMode ? "#4d22c55e" : "#86efac"
            border.width: 1

            y: 50
            opacity: 0

            SequentialAnimation {
                running: true

                PauseAnimation { duration: 100 }

                NumberAnimation {
                    target: parent
                    property: "y"
                    to: 0
                    duration: 600
                    easing.type: Easing.OutBack
                }
            }


            SequentialAnimation {
                running: true

                PauseAnimation { duration: 100 }

                NumberAnimation {
                    target: parent
                    property: "opacity"
                    to: 1
                    duration: 600
                }
            }


            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 32
                spacing: 24

                RowLayout {
                    Layout.fillWidth: true

                    Row {
                        spacing: 12

                        Text {
                            text: "💨"
                            font.pixelSize: 24
                        }

                        Text {
                            text: "Fan Speed"
                            font.pixelSize: 20
                            color: isDarkMode ? "#4ade80" : "#16a34a"
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: fanSpeed
                        font.pixelSize: 28
                        color: isDarkMode ? "#4ade80" : "#16a34a"
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Repeater {
                        model: 5

                        Button {
                            required property int index
                            Layout.fillWidth: true
                            Layout.preferredHeight: 64

                            background: Rectangle {
                                radius: 12
                                gradient: (index + 1) <= fanSpeed ? fanGradient : null
                                Gradient {
                                    id: fanGradient
                                    GradientStop { position: 0.0; color: isDarkMode ? "#22c55e" : "#10b981" }
                                    GradientStop { position: 1.0; color: isDarkMode ? "#06b6d4" : "#0891b2" }
                                }
                                color: (index + 1) > fanSpeed ? (isDarkMode ? "#27272a" : "#f4f4f5") : "transparent"
                                border.color: (index + 1) > fanSpeed ? (isDarkMode ? "#3f3f46" : "#e4e4e7") : "transparent"
                                border.width: 1
                            }

                            contentItem: Text {
                                text: index + 1
                                font.pixelSize: 24
                                color: (index + 1) <= fanSpeed ? "white" : (isDarkMode ? "#52525b" : "#a1a1aa")
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            onClicked: fanSpeed = index + 1

                            scale: 1.0

                            Behavior on scale {
                                NumberAnimation { duration: 100; easing.type: Easing.OutBack }
                            }

                            onPressed: scale = 0.95
                            onReleased: scale = 1.05
                            // onExited: scale = 1.0
                        }
                    }
                }
            }
        }

        // Quick Controls
        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            ClimateButton {
                Layout.fillWidth: true
                text: "Auto"
                icon: "💨"
                isActive: isAuto
                activeColor: isDarkMode ? "#06b6d4" : "#0891b2"
                isDark: isDarkMode
                onClicked: isAuto = !isAuto
            }

            ClimateButton {
                Layout.fillWidth: true
                text: "Recirculate"
                icon: "🔄"
                isActive: isRecirculate
                activeColor: isDarkMode ? "#a855f7" : "#7c3aed"
                isDark: isDarkMode
                onClicked: isRecirculate = !isRecirculate
            }

            ClimateButton {
                Layout.fillWidth: true
                text: "Defrost"
                icon: "❄"
                isActive: false
                activeColor: isDarkMode ? "#3b82f6" : "#2563eb"
                isDark: isDarkMode
            }

            ClimateButton {
                Layout.fillWidth: true
                text: "Heated Seats"
                icon: "🔥"
                isActive: false
                activeColor: isDarkMode ? "#f97316" : "#ea580c"
                isDark: isDarkMode
            }
        }
    }

    component TempButton: Button {
        property string icon: ""
        property color buttonColor: "#06b6d4"
        property color iconColor: "#06b6d4"

        width: 64
        height: 64

        background: Rectangle {
            radius: 32
            color: buttonColor
            border.color: iconColor
            border.width: 1
        }

        contentItem: Text {
            text: icon
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        scale: 1.0

        Behavior on scale {
            NumberAnimation { duration: 100; easing.type: Easing.OutBack }
        }

        onPressed: scale = 0.9
        onReleased: scale = 1.1
        // onExited: scale = 1.0
    }

    component ClimateButton: Button {
        property string icon: ""
        property bool isActive: false
        property color activeColor: "#06b6d4"
        property bool isDark: true

        height: 96

        background: Rectangle {
            radius: 12
            gradient: isActive ? activeGradient : null
            Gradient {
                id: activeGradient
                GradientStop { position: 0.0; color: activeColor }
                GradientStop { position: 1.0; color: Qt.darker(activeColor, 1.2) }
            }
            color: !isActive ? (isDark ? "#27272a" : "#f4f4f5") : "transparent"
            border.color: isActive ? activeColor : (isDark ? "#3f3f46" : "#e4e4e7")
            border.width: 1
        }

        contentItem: Column {
            spacing: 8

            Text {
                text: icon
                font.pixelSize: 24
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: parent.parent.text
                font.pixelSize: 14
                color: isActive ? "white" : (isDark ? "#a1a1aa" : "#71717a")
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        scale: 1.0

        Behavior on scale {
            NumberAnimation { duration: 100; easing.type: Easing.OutBack }
        }

        onPressed: scale = 0.95
        onReleased: scale = 1.05
        // onExited: scale = 1.0
    }
}
