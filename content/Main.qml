import QtQuick
import QtQuick.Controls
import NeonUI // Import module

Window {
    id: mainWindow
    width: 1280
    height: 720
    visible: true
    title: "Neon Car Infotainment"
    color: "#050505"

    // 1. THANH ĐIỀU HƯỚNG (NAV BAR) - Giữ nguyên
    NavBar {
        id: navBar
        width: 100
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        z: 100 // Luôn nổi lên trên

        onPageSelected: (pageUrl) => {
            if (contentStack.currentItem && contentStack.currentItem.objectName !== pageUrl) {
                contentStack.replace(pageUrl)
            }
        }
    }

    // 2. THANH THÔNG TIN (TOP BAR)
    TopBar {
        id: topBar
        height: 60
        z: 100 // Luôn nổi lên trên

        // Neo TopBar nằm bên phải NavBar
        anchors.left: navBar.right
        anchors.right: parent.right
        anchors.top: parent.top
    }

    // 3. KHU VỰC NỘI DUNG (CONTENT AREA) - SỬA LỖI TẠI ĐÂY
    StackView {
        id: contentStack

        // --- SỬA LỖI ANCHOR ---
        // Thay vì anchors.top: parent.top -> Đổi thành topBar.bottom
        anchors.top: topBar.bottom

        anchors.left: navBar.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        // Trang mặc định
        initialItem: DashboardScreen {}

        // Hiệu ứng chuyển trang (Fade)
        replaceEnter: Transition { PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 200 } }
        replaceExit: Transition { PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 200 } }
    }
}
