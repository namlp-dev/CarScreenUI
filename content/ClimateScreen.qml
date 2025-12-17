import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes
import NeonBackend 1.0 // [QUAN TRỌNG]

Item {
    id: root

    function getClimateColor(isHeat, temp) {
            if (isHeat) {
                var ratio = (temp - 16) / 16.0; var hue = 0.08 - (ratio * 0.08); return Qt.hsla(hue, 1.0, 0.5, 1.0)
            } else {
                var ratio = (temp - 16) / 16.0; var hue = 0.6 - (ratio * 0.1); return Qt.hsla(hue, 1.0, 0.5, 1.0)
            }
        }

    readonly property color colorLeft: getClimateColor(VehicleData.heatLeft, VehicleData.tempLeft)
    readonly property color colorRight: getClimateColor(VehicleData.heatRight, VehicleData.tempRight)

    // -----------------------------------------------------------------
    // LOGIC THÔNG MINH (SMART CLIMATE LOGIC)
    // -----------------------------------------------------------------

    function toggleSync(forceOn) {
        if (forceOn !== undefined) VehicleData.isSync = forceOn
        else VehicleData.isSync = !VehicleData.isSync

        if (VehicleData.isSync) {
            VehicleData.heatRight = VehicleData.heatLeft
            VehicleData.coolRight = VehicleData.coolLeft
            VehicleData.tempRight = VehicleData.tempLeft

            // Tái tạo binding bằng Qt.binding
            passengerDial.value = Qt.binding(function() { return VehicleData.tempRight })
        }
    }

    function onPassengerTempChanged() {
        if (VehicleData.isSync) VehicleData.isSync = false
    }

    function toggleAuto() {
        VehicleData.isAuto = !VehicleData.isAuto
        if (VehicleData.isAuto) {
            VehicleData.isAC = true
            VehicleData.fanSpeed = 3
            VehicleData.recircMode = 1
            // root.toggleSync(true)

            if (VehicleData.tempLeft < 18 || VehicleData.tempLeft > 28) VehicleData.tempLeft = 22.0
        }
    }

    function toggleRecirc() {
        VehicleData.recircMode = (VehicleData.recircMode + 1) % 3
    }

    // 1. LỚP NỀN KỸ THUẬT
    Item {
        anchors.fill: parent; z: -1; opacity: 0.3
        Rectangle { width: parent.width * 0.8; height: 1; anchors.centerIn: parent; anchors.verticalCenterOffset: -20; color: "#00FFFF"; opacity: 0.5 }
        Rectangle { width: 1; height: 100; anchors.centerIn: parent; anchors.verticalCenterOffset: 30; color: "#00FFFF"; opacity: 0.5 }
        Shape { anchors.fill: parent
            ShapePath { strokeColor: "#00FFFF"; strokeWidth: 1; fillColor: "transparent"; startX: parent.width * 0.3; startY: parent.height * 0.2; PathLine { x: parent.width * 0.2; y: parent.height * 0.3 } }
            ShapePath { strokeColor: "#00FFFF"; strokeWidth: 1; fillColor: "transparent"; startX: parent.width * 0.7; startY: parent.height * 0.2; PathLine { x: parent.width * 0.8; y: parent.height * 0.3 } }
        }
    }

    // 2. LÕI NĂNG LƯỢNG TRUNG TÂM
    Item {
        id: centerReactor
        width: 120; height: 120
        anchors.centerIn: parent; anchors.verticalCenterOffset: -80

        Rectangle {
            anchors.fill: parent; radius: width/2
            color: "transparent"
            // Màu lõi là sự pha trộn hoặc lấy bên Driver làm chuẩn
            border.color: root.colorLeft
            border.width: 3
            opacity: VehicleData.isAC ? 1.0 : 0.3
            layer.enabled: VehicleData.isAC
            layer.effect: MultiEffect {
                shadowEnabled: true; shadowColor: root.colorLeft; shadowBlur: 1.0
                SequentialAnimation on shadowOpacity {
                    running: VehicleData.isAC; loops: Animation.Infinite
                    PropertyAnimation { to: 0.6; duration: 1500; easing.type: Easing.InOutSine }
                    PropertyAnimation { to: 1.0; duration: 1500; easing.type: Easing.InOutSine }
                }
            }
        }

        Text {
            // [THAY ĐỔI]: Kiểm tra nếu đang bật Heat (bên Driver) thì hiện Mặt trời, ngược lại hiện Bông tuyết
            text: VehicleData.heatLeft ? "☀" : "❄"

            font.pixelSize: VehicleData.heatLeft ? 40 : 50

            anchors.centerIn: parent

            color: root.colorLeft
            opacity: VehicleData.isAC ? 0.8 : 0.3

            RotationAnimation on rotation {
                running: VehicleData.isAC && VehicleData.fanSpeed > 0
                loops: Animation.Infinite
                from: 0; to: 360
                duration: 6000 - (VehicleData.fanSpeed * 800)
            }
        }
    }

    // 3. DÒNG CHẢY NĂNG LƯỢNG (TĨNH, CHỈ CÓ GRADIENT)
    EnergyConduit {
        anchors.right: centerReactor.left; anchors.verticalCenter: centerReactor.verticalCenter
        isLeft: true;
        flowColor: root.colorLeft // Màu động theo nhiệt độ trái
        isActive: VehicleData.isAC && VehicleData.fanSpeed > 0
    }
    EnergyConduit {
        anchors.left: centerReactor.right; anchors.verticalCenter: centerReactor.verticalCenter
        isLeft: false;
        flowColor: root.colorRight // Màu động theo nhiệt độ phải
        isActive: VehicleData.isAC && VehicleData.fanSpeed > 0
    }

    // 4. GIAO DIỆN ĐIỀU KHIỂN

    // --- CỘT TRÁI (DRIVER) ---
    Item { id: leftPanel; width: parent.width * 0.3; anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: bottomBar.top
        Column { anchors.centerIn: parent; spacing: 30
            NeonTempDial { width: 220; height: 220; anchors.horizontalCenter: parent.horizontalCenter; label: "DRIVER";
                value: VehicleData.tempLeft
                accentColor: root.colorLeft;
                onValueChanged: {
                    VehicleData.tempLeft = value;
                    if (VehicleData.isSync) {
                        VehicleData.tempRight = value
                        VehicleData.heatRight = VehicleData.heatLeft
                        VehicleData.coolRight = VehicleData.coolLeft
                    }
                }
            }
            Row { anchors.horizontalCenter: parent.horizontalCenter; spacing: 20
                ClimateBtn {
                    text: "HEAT";
                    colorCode: "#FF3333";
                    isActive: VehicleData.heatLeft;
                    onClicked: {
                        VehicleData.heatLeft = !VehicleData.heatLeft;
                        if(VehicleData.heatLeft)
                            VehicleData.coolLeft = false
                        else VehicleData.coolLeft = true
                        if(VehicleData.isSync) {
                            VehicleData.coolRight = VehicleData.coolLeft
                            VehicleData.heatRight = VehicleData.heatLeft
                        }
                    }
                }
                ClimateBtn {
                    text: "COOL";
                    colorCode: "#00FFFF";
                    isActive: VehicleData.coolLeft;
                    onClicked: {
                        VehicleData.coolLeft = !VehicleData.coolLeft;
                        if(VehicleData.coolLeft) VehicleData.heatLeft = false
                        else VehicleData.heatLeft = true
                        if(VehicleData.isSync) {
                            VehicleData.coolRight = VehicleData.coolLeft
                            VehicleData.heatRight = VehicleData.heatLeft
                        }
                    }
                }
            }
        }
    }

    // --- CỘT PHẢI (PASSENGER) ---
    Item { id: rightPanel; width: parent.width * 0.3; anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: bottomBar.top
        Column { anchors.centerIn: parent; spacing: 30
            NeonTempDial {
                id: passengerDial // [QUAN TRỌNG] Đặt ID để gọi trong hàm toggleSync
                width: 220; height: 220; anchors.horizontalCenter: parent.horizontalCenter
                label: "PASSENGER"

                // Binding ban đầu
                value: VehicleData.tempRight
                accentColor: root.colorRight

                onValueChanged: {
                    // [LOGIC CHẶN VÒNG LẶP]
                    // Chỉ khi giá trị thay đổi do NGƯỜI DÙNG xoay (khác với giá trị hệ thống đang lưu)
                    // thì mới cập nhật ngược lại và phá Sync
                    VehicleData.tempRight = value
                    if (VehicleData.isSync)
                        if (Math.abs(value - VehicleData.tempRight) > 0.1)
                            root.onPassengerTempChanged() // Phá vỡ Sync

                }
            }
            Row { anchors.horizontalCenter: parent.horizontalCenter; spacing: 20
                ClimateBtn {
                    text: "HEAT";
                    colorCode: "#FF3333";
                    isActive: VehicleData.heatRight
                    onClicked: {
                        VehicleData.heatRight = !VehicleData.heatRight
                        if(VehicleData.heatRight) VehicleData.coolRight = false
                        else VehicleData.coolRight = true
                        if (VehicleData.isSync) VehicleData.isSync = false
                    }
                }
                ClimateBtn {
                    text: "COOL";
                    colorCode: "#00FFFF";
                    isActive: VehicleData.coolRight
                    onClicked: {
                        VehicleData.coolRight =! VehicleData.coolRight
                        if(VehicleData.coolRight) VehicleData.heatRight = false
                        else VehicleData.heatRight = true
                        if (VehicleData.isSync) VehicleData.isSync = false
                    }
                }
            }
        }
    }

    // --- CỘT GIỮA (FAN CONTROL) ---
    Item {
        id: centerPanel
        anchors.left: leftPanel.right; anchors.right: rightPanel.left; anchors.top: parent.top; anchors.bottom: bottomBar.top

        Column {
            // [FIX ALIGN]: Căn giữa và set width cụ thể
            width: parent.width * 0.8
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 100
            spacing: 15

            Text {
                text: "FAN SPEED: " + VehicleData.fanSpeed
                color: VehicleData.isAC ? "#00FFFF" : "#666"
                font.bold: true; font.pixelSize: 14
                anchors.horizontalCenter: parent.horizontalCenter // Căn giữa theo cột
            }

            Slider {
                width: parent.width // Slider chiếm hết chiều rộng cột
                from: 0; to: 5; stepSize: 1
                value: VehicleData.fanSpeed
                enabled: VehicleData.isAC; opacity: VehicleData.isAC ? 1.0 : 0.5
                onMoved: VehicleData.fanSpeed = value

                // (Custom background giữ nguyên)
                background: Rectangle { x: parent.leftPadding; y: parent.topPadding + parent.availableHeight / 2 - height / 2; width: parent.availableWidth; height: 6; radius: 3; color: "#333"; Rectangle { width: parent.parent.visualPosition * parent.width; height: parent.height; color: VehicleData.isAC ? "#00FFFF" : "#555"; radius: 3; layer.enabled: VehicleData.isAC; layer.effect: MultiEffect { shadowEnabled: true; shadowColor: "#00FFFF"; shadowBlur: 0.8 } } }
                handle: Rectangle { x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width); y: parent.topPadding + parent.availableHeight / 2 - height / 2; width: 24; height: 24; radius: 12; color: "black"; border.color: VehicleData.isAC ? "#00FFFF" : "#555"; border.width: 2 }
            }
        }
    }

    // --- THANH TOGGLE DƯỚI CÙNG ---
    Item { id: bottomBar; height: 80; anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
        Row { anchors.centerIn: parent; spacing: 40
            ClimateBtn { text: "A/C"; width: 80; isActive: VehicleData.isAC; onClicked: { VehicleData.isAC = !VehicleData.isAC; if (!VehicleData.isAC) VehicleData.isAuto = false } }
            ClimateBtn { text: "AUTO"; width: 80; isActive: VehicleData.isAuto; onClicked: root.toggleAuto() }
            ClimateBtn { text: "SYNC"; width: 80; isActive: VehicleData.isSync; onClicked: root.toggleSync() }
            ClimateBtn { text: VehicleData.recircMode === 1 ? "AUTO ⟳" : (VehicleData.recircMode === 2 ? "MAN ⟳" : "FRESH ⤑"); width: 100; isActive: VehicleData.recircMode > 0; colorCode: VehicleData.recircMode === 2 ? "#00FFFF" : "#AAFFFF"; onClicked: root.toggleRecirc() }
        }
    }

    // --- COMPONENTS ---

    // [THAY ĐỔI] EnergyConduit chỉ còn là Gradient tĩnh (Đã xóa Animation Rectangle)
    component EnergyConduit : Item {
        property bool isLeft: true
        property color flowColor: "#00FFFF"
        property bool isActive: false
        width: 200; height: 40
        opacity: isActive ? 1.0 : 0.1
        Behavior on opacity { NumberAnimation { duration: 500 } }
        Behavior on flowColor { ColorAnimation { duration: 300 } } // Chuyển màu mượt mà

        Rectangle {
            anchors.fill: parent; radius: height/2
            gradient: Gradient {
                orientation: Gradient.Horizontal;
                GradientStop { position: isLeft ? 1.0 : 0.0; color: Qt.rgba(flowColor.r, flowColor.g, flowColor.b, 0.6) } // Mờ hơn chút cho sang
                GradientStop { position: isLeft ? 0.0 : 1.0; color: "transparent" }
            }
        }
    }

    component ClimateBtn : Rectangle {
        id: btnRoot; property string text: ""; property bool isActive: false; property color colorCode: "#00FFFF"; signal clicked()
        width: 100; height: 40; radius: 20; color: isActive ? Qt.rgba(colorCode.r, colorCode.g, colorCode.b, 0.15) : "transparent"; border.color: isActive ? colorCode : "#444"; border.width: isActive ? 2 : 1
        Text { anchors.centerIn: parent; text: btnRoot.text; color: btnRoot.isActive ? btnRoot.colorCode : "#666"; font.bold: true; font.pixelSize: 14 }
        MouseArea { anchors.fill: parent; onClicked: btnRoot.clicked(); onPressed: btnRoot.opacity = 0.7; onReleased: btnRoot.opacity = 1.0 }
        layer.enabled: isActive; layer.effect: MultiEffect { shadowEnabled: true; shadowColor: colorCode; shadowBlur: 0.6 }
        Behavior on color { ColorAnimation { duration: 200 } } Behavior on border.color { ColorAnimation { duration: 200 } }
    }
}
