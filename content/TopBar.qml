import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes

Item {
    id: root
    height: 60

    // Properties dữ liệu (Giữ nguyên logic cũ)
    property string currentTime: ""
    property string currentDate: ""
    property string weatherData: "Loading..."

    // Timer logic (Giữ nguyên code cũ của bạn về Timer và fetchWeather)
    Timer {
        interval: 1000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            var date = new Date()
            root.currentTime = Qt.formatDateTime(date, "hh:mm")
            root.currentDate = Qt.formatDateTime(date, "dd/MM/yyyy")
        }
    }
    Timer {
        interval: 900000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: fetchWeather()
    }
    function fetchWeather() {
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE && doc.status === 200) {
                root.weatherData = doc.responseText.trim()
            }
        }
        doc.open("GET", "https://wttr.in/?format=3"); doc.send();
    }

    // --- GIAO DIỆN ---

    // Nền mờ nhẹ cho TopBar (tùy chọn, để phân biệt với nội dung bên dưới)
    Rectangle {
        anchors.fill: parent
        color: "#050505"
        opacity: 0.8
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 30
        anchors.rightMargin: 30

        // Bên trái: Có thể để tiêu đề trang hoặc Logo xe
        Text {
            text: "NEON OS"
            color: "#444"
            font.pixelSize: 14
            font.bold: true
            font.letterSpacing: 2
            Layout.alignment: Qt.AlignVCenter
        }

        Item { Layout.fillWidth: true } // Spacer đẩy nội dung sang 2 bên

        // Bên phải: Thông tin Weather & Clock
        Row {
            spacing: 30
            Layout.alignment: Qt.AlignVCenter

            // Weather
            Text {
                text: root.weatherData
                color: "#00FFFF"
                font.pixelSize: 16
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }

            // Divider nhỏ giữa Weather và Clock
            Rectangle {
                width: 1; height: 24
                color: "#333"
                anchors.verticalCenter: parent.verticalCenter
            }

            // Clock & Date
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                    text: root.currentTime
                    color: "white"
                    font.pixelSize: 22
                    font.bold: true
                    horizontalAlignment: Text.AlignRight
                    anchors.right: parent.right
                }
                Text {
                    text: root.currentDate
                    color: "#888"
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignRight
                    anchors.right: parent.right
                }
            }
        }
    }

    // --- ĐƯỜNG KẺ NGĂN CÁCH DƯỚI (BOTTOM SEPARATOR) ---
        Rectangle {
            height: 1
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            // SỬA LỖI: Dùng Gradient trực tiếp của Rectangle
            gradient: Gradient {
                orientation: Gradient.Horizontal // Quan trọng: Chỉnh hướng ngang

                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.1; color: "#333333" }
                GradientStop { position: 0.5; color: "#00FFFF" } // Sáng ở giữa
                GradientStop { position: 0.9; color: "#333333" }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }
}
