import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    height: 60
    color: "transparent"
    
    property string timeString: new Date().toLocaleTimeString(Qt.locale(), "hh:mm")

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.timeString = new Date().toLocaleTimeString(Qt.locale(), "hh:mm")
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Text {
            text: root.timeString
            font.pixelSize: 24
            color: "white"
            Layout.alignment: Qt.AlignVCenter
        }

        Item { Layout.fillWidth: true }

        Row {
            spacing: 10
            Rectangle {
                width: 30
                height: 15
                border.color: "white"
                border.width: 1
                color: "transparent"
                radius: 2
                Rectangle {
                    width: 20
                    height: 11
                    anchors.centerIn: parent
                    color: "#00ff00"
                }
            }
            Text {
                text: "5G"
                color: "white"
                font.pixelSize: 18
            }
        }
    }
    
    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: Qt.rgba(1, 1, 1, 0.1)
    }
}
