import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: root
    width: 300
    height: 300
    
    property real value: 0
    property real maxValue: 240
    property string unit: "KM/H"
    property color neonColor: "#00f3ff"

    Shape {
        id: track
        anchors.fill: parent
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#222"
            shadowBlur: 0.5
        }

        ShapePath {
            strokeColor: "#333"
            strokeWidth: 20
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            
            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height / 2
                radiusX: root.width / 2 - 20
                radiusY: root.height / 2 - 20
                startAngle: 135
                sweepAngle: 270
            }
        }
    }

    Shape {
        id: progress
        anchors.fill: parent
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: root.neonColor
            shadowBlur: 1.0
        }

        ShapePath {
            strokeColor: root.neonColor
            strokeWidth: 20
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            
            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height / 2
                radiusX: root.width / 2 - 20
                radiusY: root.height / 2 - 20
                startAngle: 135
                sweepAngle: 270 * (root.value / root.maxValue)
            }
        }
    }

    Text {
        anchors.centerIn: parent
        text: Math.round(root.value)
        font.pixelSize: 64
        font.bold: true
        color: "white"
        style: Text.Outline
        styleColor: root.neonColor
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.verticalCenter
        anchors.topMargin: 40
        text: root.unit
        font.pixelSize: 20
        color: "#aaa"
    }
}
