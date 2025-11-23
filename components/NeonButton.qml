import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Button {
    id: control
    text: "Button"
    
    property color neonColor: "#00f3ff" // Cyan default

    contentItem: Text {
        text: control.text
        font.pixelSize: 18
        font.bold: true
        font.family: "Arial" // Use a standard font for now
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? "#ffffff" : control.neonColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 40
        color: control.down ? Qt.rgba(control.neonColor.r, control.neonColor.g, control.neonColor.b, 0.2) : "transparent"
        border.color: control.neonColor
        border.width: 2
        radius: 10
        
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: control.neonColor
            shadowBlur: control.down ? 1.5 : 0.5
            blurMax: 16
            blurEnabled: control.hovered
            blur: 0.5
        }

        Behavior on color { ColorAnimation { duration: 100 } }
    }
}
