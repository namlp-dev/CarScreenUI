import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: root
    width: 250; height: 250

    property real value: 20.0
    property real from: 16.0
    property real to: 32.0
    property string label: "DRIVER"

    // [THAY ĐỔI] Nhận màu từ bên ngoài truyền vào
    property color accentColor: "#00FFFF"

    // Góc vẽ vòng cung
    property real startAngle: 140
    property real sweepAngle: 260

    // 1. Vòng nền (Tối)
    Shape {
        anchors.fill: parent
        ShapePath {
            strokeColor: "#222"
            strokeWidth: 20
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            PathAngleArc {
                centerX: root.width/2; centerY: root.height/2
                radiusX: root.width/2 - 20; radiusY: root.height/2 - 20
                startAngle: root.startAngle
                sweepAngle: root.sweepAngle
            }
        }
    }

    // 2. Vòng hiển thị (Active) - Có Glow theo màu accentColor
    Item {
        anchors.fill: parent
        layer.enabled: true
        layer.effect: MultiEffect { shadowEnabled: true; shadowColor: root.accentColor; shadowBlur: 0.8 }

        Shape {
            anchors.fill: parent
            ShapePath {
                strokeColor: root.accentColor // Dùng màu truyền vào
                strokeWidth: 20
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                PathAngleArc {
                    centerX: root.width/2; centerY: root.height/2
                    radiusX: root.width/2 - 20; radiusY: root.height/2 - 20
                    startAngle: root.startAngle
                    sweepAngle: (root.value - root.from) / (root.to - root.from) * root.sweepAngle
                }
            }
        }
    }

    // 3. Thông số ở giữa
    Column {
        anchors.centerIn: parent
        Text {
            text: root.value.toFixed(1) + "°"
            color: "white"
            font.pixelSize: 48
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            text: root.label
            color: "#666"
            font.bold: true
            font.pixelSize: 14
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // 4. Xử lý cảm ứng
    MouseArea {
        anchors.fill: parent
        property real lastY: 0
        onPressed: lastY = mouseY
        onMouseYChanged: {
            var diff = lastY - mouseY
            var step = 0.1
            if (diff > 0) root.value = Math.min(root.to, root.value + step)
            else if (diff < 0) root.value = Math.max(root.from, root.value - step)
            lastY = mouseY
        }
    }
}
