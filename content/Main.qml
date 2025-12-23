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

    // --- [MỚI] PROPERTIES QUẢN LÝ LOGIC ---
    property alias player: player
    property alias audioOut: audioOut
    property alias fileScanner: fileScanner
    // property alias duration: MediaPlayer.duration

    property bool isMediaLoaded: false
    property int currentSongIndex: -1
    property var songList: []

    // Biến lưu trạng thái (như đã bàn ở bước trước)
    property string savedMediaType: "music"

    // [FIX 1] Biến này để MediaScreen báo cho Main biết đang lọc theo kiểu gì
    property string activeFilterMode: "music" // "music" hoặc "video"

    FileScanner { id: fileScanner }
    MediaDevices { id: mediaDevices }

    MediaPlayer {
        id: player
        audioOutput: audioOut
        autoPlay: true
        onErrorOccurred: { console.log("Media Error: " + errorString); if (error === MediaPlayer.ResourceError) player.stop() }
        onPlaybackStateChanged: {
            if (playbackState === MediaPlayer.StoppedState && position === duration && duration > 0) {
                mainWindow.nextSong() // Tự chuyển bài khi hết
            }
        }
    }

    AudioOutput {
        id: audioOut
        volume: 0.7
        device: mediaDevices.defaultAudioOutput
    }

    // --- [FIX 1] LOGIC NEXT/PREV THÔNG MINH ---
    // Hàm kiểm tra xem file có khớp với chế độ hiện tại không
    function isFileValidForMode(filePath) {
        var isVid = filePath.toString().toLowerCase().endsWith(".mp4")
        if (activeFilterMode === "video") return isVid
        else return !isVid // Music mode (mp3, wav)
    }

    function nextSong() {
        if (songList.length === 0) return

        var nextIndex = currentSongIndex
        var loopCount = 0

        // Vòng lặp tìm bài tiếp theo HỢP LỆ
        do {
            nextIndex = (nextIndex + 1) % songList.length
            loopCount++
            // Nếu tìm thấy bài hợp lệ thì dừng
            if (isFileValidForMode(songList[nextIndex])) break
        } while (loopCount < songList.length)

        // Chỉ play nếu tìm thấy
        if (isFileValidForMode(songList[nextIndex])) {
            currentSongIndex = nextIndex
            player.source = songList[currentSongIndex]
            player.play()
        }
    }

    function prevSong() {
        if (songList.length === 0) return

        var prevIndex = currentSongIndex
        var loopCount = 0

        // Vòng lặp lùi
        do {
            prevIndex = (prevIndex - 1 + songList.length) % songList.length
            loopCount++
            if (isFileValidForMode(songList[prevIndex])) break
        } while (loopCount < songList.length)

        if (isFileValidForMode(songList[prevIndex])) {
            currentSongIndex = prevIndex
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
