import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes
import QtMultimedia

Item {
    id: root
    height: 60

    // --- LOGIC GIỮ NGUYÊN ---
    property string currentTime: ""
    property string currentDate: ""
    property string weatherData: "Loading..."
    Timer { interval: 1000; running: true; repeat: true; triggeredOnStart: true; onTriggered: { var date = new Date(); root.currentTime = Qt.formatDateTime(date, "hh:mm"); root.currentDate = Qt.formatDateTime(date, "dd/MM/yyyy") } }
    Timer { interval: 900000; running: true; repeat: true; triggeredOnStart: true; onTriggered: fetchWeather() }
    function fetchWeather() { var doc = new XMLHttpRequest(); doc.onreadystatechange = function() { if (doc.readyState === XMLHttpRequest.DONE && doc.status === 200) root.weatherData = doc.responseText.trim() }; doc.open("GET", "https://wttr.in/?format=3"); doc.send(); }

    Rectangle { anchors.fill: parent; color: "#050505"; opacity: 0.8 }

    // --- 1. LOGO (ĐẶT ID ĐỂ NEO) ---
    Text {
        id: appLogo // [QUAN TRỌNG] Đặt ID để Mini Player bám vào
        text: "NEON OS"
        color: "#444"
        font.pixelSize: 14; font.bold: true; font.letterSpacing: 2

        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.verticalCenter: parent.verticalCenter
    }

    // --- 2. MINI PLAYER (NEO VÀO BÊN PHẢI LOGO) ---
    Item {
        id: miniPlayer
        height: parent.height
        width: 400

        // [THAY ĐỔI] Thay vì centerIn: parent, ta neo vào appLogo
        anchors.left: appLogo.right
        anchors.leftMargin: 60 // Cách logo một khoảng xa chút cho thoáng
        anchors.verticalCenter: parent.verticalCenter

        visible: mainWindow.isMediaLoaded
        opacity: visible ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 300 } }

        RowLayout {
            // Neo vào bên trái của Item chứa nó
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 20

            // Cụm nút Mini (Đưa lên trước Text cho tiện tay thao tác)
            Row {
                spacing: 15
                Layout.alignment: Qt.AlignVCenter

                MiniBtn { iconPath: "M6 6h2v12H6zm3.5 6l8.5 6V6z"; onClicked: mainWindow.prevSong() }
                MiniBtn {
                    iconPath: (mainWindow.player && mainWindow.player.playbackState === MediaPlayer.PlayingState) ? "M6 19h4V5H6v14zm8-14v14h4V5h-4z" : "M8 5v14l11-7z"
                    onClicked: if(mainWindow.player) { mainWindow.player.playbackState === MediaPlayer.PlayingState ? mainWindow.player.pause() : mainWindow.player.play() }
                }
                MiniBtn { iconPath: "M6 18l8.5-6L6 6v12zM16 6v12h2V6h-2z"; onClicked: mainWindow.nextSong() }
            }

            // Vạch ngăn nhỏ giữa nút và tên bài (Optional - cho đẹp)
            Rectangle { width: 1; height: 16; color: "#333" }

            // Tên bài hát
            Text {
                text: {
                     if (!mainWindow.player || !mainWindow.player.metaData) return ""
                     var title = mainWindow.player.metaData.stringValue(MediaMetaData.Title)
                     var sourceStr = mainWindow.player.source.toString()
                     var fileName = sourceStr ? sourceStr.split("/").pop().replace(".mp3", "") : ""
                     return title ? title : fileName
                }
                color: "#00FFFF"; font.bold: true; font.pixelSize: 14

                Layout.maximumWidth: 250
                elide: Text.ElideRight
                // [THAY ĐỔI] Căn trái để text chạy ra xa khỏi logo
                horizontalAlignment: Text.AlignLeft
            }
        }
    }

    // --- 3. ĐỒNG HỒ & THỜI TIẾT (GIỮ NGUYÊN BÊN PHẢI) ---
    Row {
        anchors.right: parent.right; anchors.rightMargin: 30; anchors.verticalCenter: parent.verticalCenter; spacing: 30
        Text { text: root.weatherData; color: "#00FFFF"; font.pixelSize: 16; font.bold: true; anchors.verticalCenter: parent.verticalCenter }
        Rectangle { width: 1; height: 24; color: "#333"; anchors.verticalCenter: parent.verticalCenter }
        Column {
            anchors.verticalCenter: parent.verticalCenter; spacing: 2
            Text { text: root.currentTime; color: "white"; font.pixelSize: 22; font.bold: true; horizontalAlignment: Text.AlignRight; anchors.right: parent.right }
            Text { text: root.currentDate; color: "#888"; font.pixelSize: 11; horizontalAlignment: Text.AlignRight; anchors.right: parent.right }
        }
    }

    Rectangle { height: 1; anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; gradient: Gradient { orientation: Gradient.Horizontal; GradientStop { position: 0.0; color: "transparent" } GradientStop { position: 0.1; color: "#333333" } GradientStop { position: 0.5; color: "#00FFFF" } GradientStop { position: 0.9; color: "#333333" } GradientStop { position: 1.0; color: "transparent" } } }

    // Component nút nhỏ cho TopBar
    // --- COMPONENT MINI BUTTON (ĐÃ FIX SCOPE ID) ---
    component MiniBtn : Item {
        id: miniBtnRoot // [QUAN TRỌNG] Đặt ID để tham chiếu

        property string iconPath: ""
        signal clicked()

        width: 24; height: 24

        // Vùng tương tác chuột
        MouseArea {
            anchors.fill: parent
            onClicked: parent.clicked()
            onPressed: parent.opacity = 0.5
            onReleased: parent.opacity = 1.0
        }

        // Vẽ Icon
        Shape {
            anchors.centerIn: parent
            width: 14; height: 14

            ShapePath {
                fillColor: "white"
                strokeWidth: 0

                // [SỬA LỖI TẠI ĐÂY] Gọi trực tiếp qua ID miniBtnRoot
                PathSvg { path: miniBtnRoot.iconPath }
            }
        }
    }
}
