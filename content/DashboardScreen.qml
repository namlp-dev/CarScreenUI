import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import QtQuick.Effects
import QtQuick.Layouts
import NeonBackend 1.0 // [QUAN TRỌNG]

Item {
    id: root

    property real currentSpeed: VehicleData.speed
    property string currentGear: VehicleData.gear
    property int batteryLevel: VehicleData.battery
    property bool turnLeft: VehicleData.leftSignal
    property bool turnRight: VehicleData.rightSignal

    property bool blinkState: false // Biến này sẽ bật/tắt liên tục

    Timer {
        interval: 500 // Nháy mỗi 0.5 giây
        running: root.turnLeft || root.turnRight // Chạy khi có ít nhất 1 bên bật
        repeat: true
        onTriggered: root.blinkState = !root.blinkState
        // Khi tắt xi nhan, reset blink về false
        onRunningChanged: if (!running) root.blinkState = false
    }

    property real pressureFL: VehicleData.tireFL
    property real pressureFR: VehicleData.tireFR
    property real pressureRL: VehicleData.tireRL
    property real pressureRR: VehicleData.tireRR

    // [QUAN TRỌNG] XÓA BỎ CÁC ĐOẠN "SequentialAnimation" VÀ "Timer" GIẢ LẬP CŨ ĐI
    // (Xóa đoạn Animation speed từ 0 -> 124)
    // (Xóa Timer nháy xi nhan tự động)

    property real inspectOpacity: 0

    // --- 1. KHU VỰC TRUNG TÂM (DRIVE MODE) ---
    Item {
        id: driveCenter
        width: 500; height: 500
        anchors.centerIn: parent
        opacity: 1 - root.inspectOpacity // Mờ đi khi Inspect
        scale: 1 - (root.inspectOpacity * 0.2) // Thu nhỏ nhẹ khi Inspect

        // A. Đồng hồ tốc độ
        NeonGauge {
            id: mainGauge
            anchors.centerIn: parent
            width: 400; height: 400
            value: root.currentSpeed
            maxValue: 240
            accentColor: "#00FFFF"
        }

        // B. Thông tin Pin & Range (Nằm dưới tốc độ)
        Column {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 120 // Dời xuống dưới
            spacing: 5

            // Thanh Pin đơn giản
            Rectangle {
                width: 200; height: 6
                color: "#333"
                radius: 3
                Rectangle {
                    width: parent.width * (root.batteryLevel / 100)
                    height: parent.height
                    radius: 3
                    color: root.batteryLevel > 20 ? "#00FF00" : "#FF3333"
                }
            }
            Text {
                text: root.batteryLevel + "%"
                color: root.batteryLevel > 20 ? "#00FF00" : "#FF3333"
                font.pixelSize: 14
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // C. Cần số (P R N D) - Nằm dưới cùng
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            spacing: 30

            Repeater {
                model: ["P", "R", "N", "D"]
                delegate: Text {
                    text: modelData
                    font.pixelSize: 24
                    font.bold: true
                    color: root.currentGear === modelData ? "#00FFFF" : "#444"
                    // Hiệu ứng Glow cho số đang chọn
                    layer.enabled: root.currentGear === modelData
                    layer.effect: MultiEffect { shadowEnabled: true; shadowColor: "#00FFFF"; shadowBlur: 1.0 }
                }
            }
        }

        // D. Xi nhan (Turn Signals)

        Item {
            x: 30; y: 50 // Vị trí tùy chỉnh góc trái trên
            width: 60; height: 60

            // Chỉ hiện khi bật xi nhan VÀ đang ở nhịp sáng (blinkState)
            opacity: (root.turnLeft && root.blinkState) ? 1.0 : 0.1
            Behavior on opacity { NumberAnimation { duration: 100 } } // Hiệu ứng fade nhanh

            // Vẽ mũi tên trái
            Shape {
                anchors.centerIn: parent
                ShapePath {
                    fillColor: "#00FF00" // Màu xanh lá chuẩn xi nhan
                    strokeWidth: 0
                    startX: 40; startY: 0
                    PathLine { x: 40; y: 40 }
                    PathLine { x: 0; y: 20 }
                    PathLine { x: 40; y: 0 }
                }
            }
            // Glow cho mũi tên
            layer.enabled: opacity > 0.5
            layer.effect: MultiEffect { shadowEnabled: true; shadowColor: "#00FF00"; shadowBlur: 1.0 }
        }

        // --- HIỂN THỊ XI NHAN PHẢI ---
        Item {
            x: parent.width - 90; y: 50 // Vị trí góc phải trên
            width: 60; height: 60

            opacity: (root.turnRight && root.blinkState) ? 1.0 : 0.1
            Behavior on opacity { NumberAnimation { duration: 100 } }

            // Vẽ mũi tên phải
            Shape {
                anchors.centerIn: parent
                ShapePath {
                    fillColor: "#00FF00"
                    strokeWidth: 0
                    startX: 0; startY: 0
                    PathLine { x: 0; y: 40 }
                    PathLine { x: 40; y: 20 }
                    PathLine { x: 0; y: 0 }
                }
            }
            layer.enabled: opacity > 0.5
            layer.effect: MultiEffect { shadowEnabled: true; shadowColor: "#00FF00"; shadowBlur: 1.0 }
        }
    }

    // --- 2. MÔ HÌNH XE (VF7 STYLE - DARK MATTE) ---
    Item {
        id: carContainer
        width: 220; height: 380
        z: 10

        // Vị trí và Scale thay đổi theo State
        // State Drive: Nằm góc, nhỏ
        // State Inspect: Ra giữa, to

        // Mặc định (Inspect Mode values - để dễ chỉnh layout, sau đó State sẽ override)
        x: (root.width - width)/2
        y: (root.height - height)/2 + 20

        // --- THÂN XE (BODY) ---
        Shape {
            anchors.fill: parent
            // Bỏ hiệu ứng Glow lòe loẹt toàn thân, chỉ dùng bóng đổ nhẹ
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#000000"
                shadowBlur: 2.0
                shadowVerticalOffset: 10
            }

            ShapePath {
                // Viền mỏng màu xám hoặc xanh rất tối
                strokeColor: "#333333"
                strokeWidth: 2
                // MÀU FILL: Gradient đen mờ sang trọng
                fillGradient: LinearGradient {
                    x1: 0; y1: 0; x2: 220; y2: 380
                    GradientStop { position: 0.0; color: "#222222" } // Xám đen
                    GradientStop { position: 0.5; color: "#050505" } // Đen sâu ở giữa
                    GradientStop { position: 1.0; color: "#111111" }
                }

                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin

                // SVG Path dáng xe SUV thể thao (béo hơn chút so với bản cũ)
                PathSvg { path: "M40,20 C10,20 0,60 0,100 L0,280 C0,330 10,360 40,360 L180,360 C210,360 220,330 220,280 L220,100 C220,60 210,20 180,20 Z M20,110 L200,110 M20,270 L200,270" }
            }

            // Kính chắn gió (Windshield) - Tạo điểm nhấn
            ShapePath {
                strokeWidth: 0
                fillColor: "#000000"
                PathSvg { path: "M40,50 L180,50 L190,100 L30,100 Z" }
            }
        }

        // --- 4 BÁNH XE (NỔI BẬT) ---
        // Thay vì hình chữ nhật đơn điệu, dùng Rectangle bo góc + Glow riêng
        component WheelView : Rectangle {
            property bool isError: false
            width: 24; height: 50
            radius: 4
            color: isError ? "#FF3333" : "#333333" // Màu lốp
            border.color: isError ? "red" : "#00FFFF" // Viền neon
            border.width: 2

            // Chỉ phát sáng bánh xe (VF7 style: lốp nổi bật trên nền tối)
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: border.color
                shadowBlur: isError ? 1.5 : 0.5 // Lỗi thì sáng rực lên
            }
        }

        WheelView { x: -12; y: 60; isError: root.pressureFL < 30 }
        WheelView { x: 208; y: 60; isError: root.pressureFR < 30 }
        WheelView { x: -12; y: 270; isError: root.pressureRL < 30 }
        WheelView { x: 208; y: 270; isError: root.pressureRR < 30 }

        // Vùng chạm để chuyển chế độ
        MouseArea {
            anchors.fill: parent
            onClicked: root.state = "inspect"
            enabled: root.state === "drive"
        }
    }

    // --- 3. CÁC WIDGET THÔNG SỐ (GIỮ NGUYÊN LOGIC CŨ, CHỈNH LẠI VỊ TRÍ) ---
    // (Đã phẳng hóa cấu trúc để tránh lỗi anchor)

    // Front Left
    TireWidget {
        anchors.right: carContainer.left; anchors.rightMargin: 10 // Gần hơn
        anchors.top: carContainer.top; anchors.topMargin: 70
        label: "FRONT LEFT"
        pressure: root.pressureFL
        isLeft: true
        opacity: root.inspectOpacity
        visible: opacity > 0
    }

    // Front Right
    TireWidget {
        anchors.left: carContainer.right; anchors.leftMargin: 10
        anchors.top: carContainer.top; anchors.topMargin: 70
        label: "FRONT RIGHT"
        pressure: root.pressureFR
        isLeft: false
        opacity: root.inspectOpacity
        visible: opacity > 0
    }

    // Rear Left
    TireWidget {
        anchors.right: carContainer.left; anchors.rightMargin: 10
        anchors.bottom: carContainer.bottom; anchors.bottomMargin: 20
        label: "REAR LEFT"
        pressure: root.pressureRL
        isLeft: true
        opacity: root.inspectOpacity
        visible: opacity > 0
    }

    // Rear Right
    TireWidget {
        anchors.left: carContainer.right; anchors.leftMargin: 10
        anchors.bottom: carContainer.bottom; anchors.bottomMargin: 20
        label: "REAR RIGHT"
        pressure: root.pressureRR
        isLeft: false
        opacity: root.inspectOpacity
        visible: opacity > 0
    }

    // Nút BACK
    Button {
        text: "◀ BACK"
        anchors.left: parent.left; anchors.leftMargin: 40
        anchors.top: parent.top; anchors.topMargin: 30
        opacity: root.inspectOpacity
        visible: opacity > 0
        background: Rectangle { color: "#111"; radius: 5; border.color: "#444" }
        contentItem: Text { text: parent.text; color: "white"; font.bold: true; padding: 10 }
        onClicked: root.state = "drive"
    }

    // --- COMPONENT TIRE WIDGET ---
    component TireWidget : Item {
        id: widgetRoot
        property string label: "TIRE"
        property real pressure: 30.0
        property bool isLeft: true
        property bool isWarning: widgetRoot.pressure < 30.0

        width: 200; height: 80 // Gọn hơn

        // Connector Line (Mảnh hơn, tinh tế hơn)
        Rectangle {
            width: 80; height: 1
            color: widgetRoot.isWarning ? "red" : "#666" // Màu xám nếu bình thường
            anchors.top: parent.top; anchors.topMargin: 15
            anchors.right: widgetRoot.isLeft ? parent.right : undefined
            anchors.left: widgetRoot.isLeft ? undefined : parent.left
        }

        Column {
            anchors.top: parent.top
            anchors.right: widgetRoot.isLeft ? parent.right : undefined
            anchors.left: widgetRoot.isLeft ? undefined : parent.left
            anchors.rightMargin: widgetRoot.isLeft ? 90 : 0
            anchors.leftMargin: widgetRoot.isLeft ? 0 : 90

            Text {
                text: widgetRoot.pressure.toFixed(1) + " PSI"
                color: widgetRoot.isWarning ? "#FF3333" : "#666" // Đỏ hoặc Trắng
                font.pixelSize: 28; font.bold: true; font.family: "Arial"
                horizontalAlignment: widgetRoot.isLeft ? Text.AlignRight : Text.AlignLeft
                width: 110

                SequentialAnimation on opacity {
                    running: widgetRoot.isWarning
                    loops: Animation.Infinite
                    PropertyAnimation { to: 0.3; duration: 500 }
                    PropertyAnimation { to: 1.0; duration: 500 }
                }
            }
            Text {
                text: widgetRoot.label
                color: "#666"; font.pixelSize: 10; font.bold: true
                horizontalAlignment: widgetRoot.isLeft ? Text.AlignRight : Text.AlignLeft
                width: 110
            }
        }
    }

    // --- STATE MACHINE ---
    state: "drive"

    states: [
        State {
            name: "drive"
            PropertyChanges { target: carContainer; x: root.width - carContainer.width - 40; y: root.height - carContainer.height + 20; scale: 0.4; opacity: 0.6 }
            PropertyChanges { target: root; inspectOpacity: 0 }
        },
        State {
            name: "inspect"
            PropertyChanges { target: carContainer; x: (root.width - carContainer.width)/2; y: (root.height - carContainer.height)/2 + 30; scale: 1.0; opacity: 1 }
            PropertyChanges { target: root; inspectOpacity: 1 }
        }
    ]

    transitions: [
        Transition {
            ParallelAnimation {
                NumberAnimation { properties: "x,y,scale,opacity,inspectOpacity"; duration: 600; easing.type: Easing.OutQuint }
            }
        }
    ]
}
