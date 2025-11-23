import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "components"

Window {
    id: window
    width: 1280
    height: 720
    visible: true
    title: qsTr("Neon Car UI")
    color: "#050510" // Deep dark blue/black background

    // Background gradient/glow
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#050510" }
            GradientStop { position: 1.0; color: "#0a0a20" }
        }
    }

    // Main Layout
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Top Bar
        TopBar {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
        }

        // Center Content Area
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Side Menu
            SideMenu {
                Layout.preferredWidth: 120
                Layout.fillHeight: true
            }

            // Dashboard Content
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                // Speedometer
                NeonGauge {
                    id: speedometer
                    anchors.centerIn: parent
                    width: 400
                    height: 400
                    value: 0
                    maxValue: 240
                    unit: "KM/H"
                    neonColor: "#00f3ff"
                }

                // Tachometer (smaller, to the right)
                NeonGauge {
                    anchors.left: speedometer.right
                    anchors.leftMargin: 50
                    anchors.verticalCenter: speedometer.verticalCenter
                    width: 250
                    height: 250
                    value: 2
                    maxValue: 8
                    unit: "x1000 RPM"
                    neonColor: "#ff00ff"
                }

                // Simulation Animation
                SequentialAnimation {
                    running: true
                    loops: Animation.Infinite
                    
                    NumberAnimation {
                        target: speedometer
                        property: "value"
                        from: 0
                        to: 120
                        duration: 4000
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: speedometer
                        property: "value"
                        from: 120
                        to: 60
                        duration: 3000
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        // Bottom Bar
        BottomBar {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
        }
    }
}
