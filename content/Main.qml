import QtQuick
import QtQuick.Controls
import QtMultimedia
import NeonBackend 1.0
import NeonUI

Window {
    id: mainWindow
    width: 1280; height: 720
    visible: true
    title: "Neon Car Infotainment"

    // --- [QUAN TRỌNG] CÔNG KHAI CÁC ĐỐI TƯỢNG RA NGOÀI ---
    // Để MediaScreen và TopBar có thể gọi mainWindow.player, mainWindow.fileScanner
    property alias player: player
    property alias audioOut: audioOut
    property alias fileScanner: fileScanner

    // --- GLOBAL MEDIA STATE ---
    property bool isMediaLoaded: false
    property int currentSongIndex: -1
    property var songList: []

    // Backend Scanner
    FileScanner { id: fileScanner } // ID này là nội bộ, nhưng đã được expose qua alias ở trên

    // Audio Engine
    MediaPlayer {
        id: player // ID này là nội bộ
        audioOutput: audioOut
        autoPlay: true
        onPlaybackStateChanged: {
            if (playbackState === MediaPlayer.StoppedState && position === duration && duration > 0) {
                mainWindow.nextSong()
            }
        }
    }
    AudioOutput { id: audioOut; volume: 0.7 }

    // ... (Giữ nguyên các hàm nextSong, prevSong, formatTime)
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

    // --- UI STRUCTURE ---
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
