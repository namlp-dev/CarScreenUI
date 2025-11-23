import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    width: 100
    color: Qt.rgba(0, 0, 0, 0.5)
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 30

        NeonButton {
            text: "NAV"
            neonColor: "#ff00ff" // Purple
            Layout.preferredWidth: 80
            Layout.preferredHeight: 80
        }

        NeonButton {
            text: "MEDIA"
            neonColor: "#00f3ff" // Cyan
            Layout.preferredWidth: 80
            Layout.preferredHeight: 80
        }

        NeonButton {
            text: "CLIMATE"
            neonColor: "#ffaa00" // Orange
            Layout.preferredWidth: 80
            Layout.preferredHeight: 80
        }
    }
    
    Rectangle {
        anchors.right: parent.right
        height: parent.height
        width: 1
        color: Qt.rgba(1, 1, 1, 0.1)
    }
}
