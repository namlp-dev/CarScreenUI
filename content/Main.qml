import QtQuick
import QtQuick.Controls
import QtMultimedia // [QUAN TRỌNG]
import NeonBackend 1.0
import NeonUI

Window {
    id: mainWindow
    width: 1280; height: 720
    visible: true
    title: "Neon Car Infotainment"

    // Alias giữ nguyên
    property alias player: player
    property alias audioOut: audioOut
    property alias fileScanner: fileScanner

    // Properties cũ giữ nguyên...
    property bool isMediaLoaded: false
    property int currentSongIndex: -1
    property var songList: []

    // Backend Scanner
    FileScanner { id: fileScanner }

    // --- [MỚI] QUẢN LÝ THIẾT BỊ ÂM THANH ---
    MediaDevices {
        id: mediaDevices
    }
    // ---------------------------------------

    // Audio Engine
    MediaPlayer {
        id: player
        audioOutput: audioOut
        autoPlay: true

        // [TÙY CHỌN] Xử lý nếu xảy ra lỗi thiết bị thì thử play lại hoặc dừng an toàn
        onErrorOccurred: {
            console.log("Media Error: " + errorString)
            if (error === MediaPlayer.ResourceError) {
                // Thường lỗi thiết bị sẽ rơi vào đây, ta có thể stop để tránh crash
                player.stop()
            }
        }

        onPlaybackStateChanged: {
            if (playbackState === MediaPlayer.StoppedState && position === duration && duration > 0) {
                mainWindow.nextSong()
            }
        }
    }

    AudioOutput {
        id: audioOut
        volume: 0.7

        // --- [QUAN TRỌNG NHẤT] ---
        // Luôn bind thiết bị đầu ra theo thiết bị mặc định của hệ thống
        // Khi bạn cắm/rút tai nghe, 'defaultAudioOutput' thay đổi -> 'device' tự cập nhật theo
        device: mediaDevices.defaultAudioOutput
    }

    // ... (Phần code Logic Next/Prev và UI bên dưới GIỮ NGUYÊN KHÔNG ĐỔI)
    function nextSong() {
        if (songList.length > 0) {
            currentSongIndex = (currentSongIndex + 1) % songList.length
            player.source = songList[currentSongIndex]
            player.play()
        }
    }
    function prevSong() {
        if (songList.length > 0) {
            currentSongIndex = (currentSongIndex - 1 + songList.length) % songList.length
            player.source = songList[currentSongIndex]
            player.play()
        }
    }
    function formatTime(milliseconds) {
        if (milliseconds <= 0) return "00:00";
        var totalSeconds = Math.floor(milliseconds / 1000);
        var minutes = Math.floor(totalSeconds / 60);
        var seconds = totalSeconds % 60;
        return (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
    }

    NeonBackground { z: -100 }

    NavBar {
        id: navBar; z: 100
        anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom
        onPageSelected: (pageUrl) => {
            if (contentStack.currentItem && contentStack.currentItem.objectName !== pageUrl) {
                contentStack.replace(pageUrl)
            }
        }
    }

    TopBar {
        id: topBar; z: 100
        anchors.left: navBar.right; anchors.right: parent.right; anchors.top: parent.top
    }

    StackView {
        id: contentStack
        anchors.top: topBar.bottom; anchors.left: navBar.right; anchors.right: parent.right; anchors.bottom: parent.bottom
        initialItem: DashboardScreen {}
        replaceEnter: Transition { PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 200 } }
        replaceExit: Transition { PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 200 } }
    }
}
