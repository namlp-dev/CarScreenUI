import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    height: 80
    color: "transparent"
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 40

        Text {
            text: "Ready"
            color: "#00ff00"
            font.pixelSize: 20
            Layout.alignment: Qt.AlignVCenter
        }

        Item { Layout.fillWidth: true }

        RowLayout {
            spacing: 20
            NeonButton {
                text: "ECO"
                neonColor: "#00ff00"
                Layout.preferredWidth: 100
            }
            NeonButton {
                text: "SPORT"
                neonColor: "#ff0000"
                Layout.preferredWidth: 100
            }
        }
    }
    
    Rectangle {
        anchors.top: parent.top
        width: parent.width
        height: 2
        color: "#00f3ff"
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#00f3ff"
            shadowBlur: 1.0
        }
    }
}
