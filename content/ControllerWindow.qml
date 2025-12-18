import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import NeonBackend 1.0

Window {
    id: simWindow
    width: 450; height: 700
    visible: true
    title: "SIM CONTROLLER"
    color: "#1e1e1e"
    x: 50; y: 100

    ScrollView {
        anchors.fill: parent
        contentWidth: parent.width
        clip: true

        ColumnLayout {
            width: parent.width
            spacing: 25
            anchors.margins: 30

            Text {
                text: "VEHICLE TELEMETRY"; color: "#00FFFF";
                font.bold: true; font.pixelSize: 22; font.letterSpacing: 2
                Layout.alignment: Qt.AlignHCenter
            }

            // --- 1. POWERTRAIN ---
            GroupBox {
                title: "POWERTRAIN"
                Layout.fillWidth: true
                background: Rectangle { color: "#2a2a2a"; radius: 8; border.color: "#444" }
                label: Text { text: parent.title; color: "#aaa"; font.bold: true;}
                topPadding: 30
                leftPadding: 12
                rightPadding: 12
                bottomPadding: 12
                GridLayout {

                    columns: 3 // Label - Slider - Value
                    width: parent.width
                    columnSpacing: 15 // Khoảng cách ngang
                    rowSpacing: 20    // Khoảng cách dọc

                    // SPEED
                    Text { text: "Speed"; color: "white"; font.bold: true; Layout.preferredWidth: 60 }
                    Slider {
                        id: speedSlider
                        from: 0
                        to: 240
                        stepSize: 1
                        Layout.fillWidth: true

                        value: VehicleData.speed
                        onMoved: VehicleData.speed = value

                        handle: Rectangle {
                            width: 24
                            height: 24
                            radius: 12
                            color: "#00FFFF"

                            x: speedSlider.leftPadding
                               + speedSlider.visualPosition
                               * (speedSlider.availableWidth - width)

                            y: speedSlider.topPadding
                               + (speedSlider.availableHeight - height) / 2
                        }
                    }


                    Text { text: VehicleData.speed + " km/h"; color: "#00FFFF";  Layout.preferredWidth: 70; horizontalAlignment: Text.AlignRight }

                    // BATTERY
                    Text { text: "Battery"; color: "white"; font.bold: true; Layout.preferredWidth: 60 }
                    Slider {
                        id: batterySlider
                        from: 0
                        to: 100
                        stepSize: 1
                        Layout.fillWidth: true

                        value: VehicleData.battery
                        onMoved: VehicleData.battery = value

                        handle: Rectangle {
                            width: 24
                            height: 24
                            radius: 12
                            color: "#00FFFF"

                            x: batterySlider.leftPadding
                               + batterySlider.visualPosition
                               * (batterySlider.availableWidth - width)

                            y: batterySlider.topPadding
                               + (batterySlider.availableHeight - height) / 2
                        }
                    }

                    Text { text: VehicleData.battery + " %"; color: VehicleData.battery < 20 ? "red" : "#00FF00";  Layout.preferredWidth: 70; horizontalAlignment: Text.AlignRight }
                }
            }

            // --- 2. GEARBOX ---
            GroupBox {
                title: "GEAR SELECTOR"
                Layout.fillWidth: true
                background: Rectangle { color: "#2a2a2a"; radius: 8; border.color: "#444" }
                label: Text { text: parent.title; color: "#aaa"; font.bold: true; padding: 10 }
                topPadding: 30
                leftPadding: 12
                rightPadding: 12
                bottomPadding: 12
                RowLayout {
                    spacing: 15
                    Layout.alignment: Qt.AlignHCenter
                    Repeater {
                        model: ["P", "R", "N", "D"]
                        Rectangle {
                            width: 60; height: 40; radius: 5
                            color: VehicleData.gear === modelData ? "#00FFFF" : "#444"
                            border.color: VehicleData.gear === modelData ? "white" : "transparent"
                            Text { text: modelData; anchors.centerIn: parent; color: VehicleData.gear === modelData ? "black" : "white"; font.bold: true }
                            MouseArea { anchors.fill: parent; onClicked: VehicleData.gear = modelData }
                        }
                    }
                }
            }

            // --- 3. SIGNALS ---
            GroupBox {
                title: "LIGHT SIGNALS"
                Layout.fillWidth: true
                background: Rectangle { color: "#2a2a2a"; radius: 8; border.color: "#444" }
                label: Text { text: parent.title; color: "#aaa"; font.bold: true; padding: 10 }
                topPadding: 30
                leftPadding: 12
                rightPadding: 12
                bottomPadding: 12
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 30
                    CheckBox {
                        checked: VehicleData.leftSignal
                        onCheckedChanged: VehicleData.leftSignal = checked
                        contentItem: Text { text: parent.text; color: checked ? "#00FF00" : "white"; font.bold: true; leftPadding: 10; verticalAlignment: Text.AlignVCenter }
                    }
                    Text {text: "◀ Left"; color: "white";}
                    CheckBox {
                        checked: VehicleData.rightSignal
                        onCheckedChanged: VehicleData.rightSignal = checked
                        contentItem: Text { text: parent.text; color: checked ? "#00FF00" : "white"; font.bold: true; leftPadding: 10; verticalAlignment: Text.AlignVCenter }
                    }
                    Text {text: "Right ▶"; color: "white";}
                }
            }

            // --- 4. TIRE PRESSURE ---
            GroupBox {
                title: "TIRE PRESSURE (PSI)"
                Layout.fillWidth: true
                background: Rectangle { color: "#2a2a2a"; radius: 8; border.color: "#444" }
                label: Text { text: parent.title; color: "#aaa"; font.bold: true; padding: 10 }
                topPadding: 30
                leftPadding: 12
                rightPadding: 12
                bottomPadding: 12
                // [FIX]: Viết tường minh từng Slider để tránh lỗi Component binding
                GridLayout {
                    columns: 3
                    width: parent.width
                    columnSpacing: 10; rowSpacing: 15

                    // FL
                    Text { text: "Front L"; color: "#ccc"; Layout.preferredWidth: 60; Layout.alignment: Qt.AlignVCenter }
                    Slider { from: 0; to: 50; stepSize: 0.5; value: VehicleData.tireFL; onMoved: VehicleData.tireFL = value; Layout.fillWidth: true }
                    Text { text: VehicleData.tireFL.toFixed(1); color: VehicleData.tireFL < 28 ? "red" : "white";  Layout.alignment: Qt.AlignVCenter }

                    // FR
                    Text { text: "Front R"; color: "#ccc"; Layout.preferredWidth: 60; Layout.alignment: Qt.AlignVCenter }
                    Slider { from: 0; to: 50; stepSize: 0.5; value: VehicleData.tireFR; onMoved: VehicleData.tireFR = value; Layout.fillWidth: true }
                    Text { text: VehicleData.tireFR.toFixed(1); color: VehicleData.tireFR < 28 ? "red" : "white";  Layout.alignment: Qt.AlignVCenter }

                    // RL
                    Text { text: "Rear L"; color: "#ccc"; Layout.preferredWidth: 60; Layout.alignment: Qt.AlignVCenter }
                    Slider { from: 0; to: 50; stepSize: 0.5; value: VehicleData.tireRL; onMoved: VehicleData.tireRL = value; Layout.fillWidth: true }
                    Text { text: VehicleData.tireRL.toFixed(1); color: VehicleData.tireRL < 28 ? "red" : "white";  Layout.alignment: Qt.AlignVCenter }

                    // RR
                    Text { text: "Rear R"; color: "#ccc"; Layout.preferredWidth: 60; Layout.alignment: Qt.AlignVCenter }
                    Slider { from: 0; to: 50; stepSize: 0.5; value: VehicleData.tireRR; onMoved: VehicleData.tireRR = value; Layout.fillWidth: true }
                    Text { text: VehicleData.tireRR.toFixed(1); color: VehicleData.tireRR < 28 ? "red" : "white";  Layout.alignment: Qt.AlignVCenter }
                }
            }

            Item { Layout.fillHeight: true }
        }
    }
}
