import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: root
    width: 300; height: 300

    // Các thuộc tính có thể tùy chỉnh từ bên ngoài
    property real value: 0          // Giá trị hiện tại (0 - maxValue)
    property real maxValue: 240     // Tốc độ tối đa
    property string unit: "KM/H"    // Đơn vị
    property color accentColor: "#00FFFF" // Màu Neon chủ đạo

    // 1. Vòng tròn nền (Tối hơn)
    Shape {
        anchors.fill: parent
        ShapePath {
            strokeColor: Qt.darker(root.accentColor, 4.5) // Màu rất tối của neon
            strokeWidth: 20
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: root.width / 2; centerY: root.height / 2
                radiusX: (root.width / 2) - 20; radiusY: (root.height / 2) - 20
                startAngle: 135
                sweepAngle: 270
            }
        }
    }

    // 2. Vòng tròn hiển thị giá trị (Sáng rực)
    Item {
        anchors.fill: parent
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: root.accentColor
            shadowBlur: 1.0 // Độ tỏa sáng (Bloom)
            shadowOpacity: 1.0
        }

        Shape {
            anchors.fill: parent
            ShapePath {
                strokeColor: root.accentColor
                strokeWidth: 20
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: root.width / 2; centerY: root.height / 2
                    radiusX: (root.width / 2) - 20; radiusY: (root.height / 2) - 20
                    startAngle: 135
                    // Tính góc quét dựa trên value
                    sweepAngle: 270 * (root.value / root.maxValue)
                }
            }
        }
    }

    // 3. Hiển thị số trung tâm
    Column {
        anchors.centerIn: parent

        Text {
            text: Math.floor(root.value)
            color: "white"
            font.pixelSize: 64
            font.bold: true
            font.family: "Arial"
            anchors.horizontalCenter: parent.horizontalCenter

            // Bóng đổ cho chữ
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: root.accentColor
                shadowBlur: 0.5
            }
        }

        Text {
            text: root.unit
            color: "#888"
            font.pixelSize: 18
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
