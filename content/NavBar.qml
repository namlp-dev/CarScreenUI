import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import QtQuick.Layouts


Rectangle {
    id: root
    width: 100
    color: "#080808" // Nền đen sâu
    z: 100 // Đảm bảo nằm trên nội dung nếu có đè

    signal pageSelected(string pageUrl)

    // Dữ liệu Icon (Đã cập nhật icon Climate hình Cánh Quạt/Gió)
    ListModel {
        id: navModel
        ListElement {
            name: "Dashboard";
            iconPath: "M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z";
            page: "DashboardScreen.qml"
        }
        ListElement {
            name: "Climate";
            // Icon hình cánh quạt (Fan)
            iconPath: "M4 6h7c.83 0 1.5.67 1.5 1.5S11.83 9 11 9H4V6zm0 5h10c.83 0 1.5.67 1.5 1.5S14.83 14 14 14H4v-3zm0 5h13c.83 0 1.5.67 1.5 1.5S17.83 19 17 19H4v-3z"
            page: "ClimateScreen.qml"
        }
        ListElement {
            name: "Media";
            iconPath: "M12 3v9.28c-.47-.17-.97-.28-1.5-.28-2.49 0-4.5 2.01-4.5 4.5S8.01 21 10.5 21c2.31 0 4.2-1.75 4.45-4H15V6h4V3h-7z";
            page: "MediaScreen.qml"
        }
    }

    property int selectedIndex: 0

    Column {
        anchors.centerIn: parent
        spacing: 35 // Khoảng cách rộng thoáng hơn

        Repeater {
            model: navModel
            delegate: Item {
                // Khung chứa nút bấm (Hit Box)
                width: 64; height: 64

                property bool isSelected: index === root.selectedIndex

                // 1. Nền nút (Background) - Chỉ hiện viền và glow nhẹ khi chọn
                Rectangle {
                    anchors.fill: parent
                    radius: 16
                    color: isSelected ? "#1A1A1A" : "transparent"
                    border.color: isSelected ? "#00FFFF" : "transparent"
                    border.width: 1.5

                    // Hiệu ứng Glow cho viền nút
                    layer.enabled: isSelected
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: "#00FFFF"
                        shadowBlur: 0.8
                        shadowOpacity: 0.8
                    }

                    // Animation chuyển trạng thái mượt mà
                    Behavior on color { ColorAnimation { duration: 200 } }
                    Behavior on border.color { ColorAnimation { duration: 200 } }
                }

                // 2. Icon Container - Để căn giữa tuyệt đối
                Item {
                    width: 24; height: 24 // Kích thước chuẩn của SVG Icon
                    anchors.centerIn: parent // LUÔN LUÔN CĂN GIỮA KHUNG

                    Shape {
                        anchors.fill: parent
                        // Nếu icon gốc nhỏ, ta scale Shape lên ở đây mà không mất tâm
                        scale: 1.2

                        ShapePath {
                            strokeWidth: 0
                            // Màu icon: Cyan nếu chọn, Xám đậm nếu không
                            fillColor: isSelected ? "#00FFFF" : "#555555"
                            PathSvg { path: model.iconPath }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.selectedIndex = index
                        root.pageSelected(model.page)
                    }
                }
            }
        }
    }

    // --- ĐƯỜNG KẺ NGĂN CÁCH (SEPARATOR) ---
        Rectangle {
            width: 1
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            // SỬA LỖI: Dùng Gradient trực tiếp của Rectangle
            gradient: Gradient {
                orientation: Gradient.Vertical // Quan trọng: Chỉnh hướng dọc

                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.2; color: "#333333" }
                GradientStop { position: 0.5; color: "#00FFFF" } // Cyan sáng ở giữa
                GradientStop { position: 0.8; color: "#333333" }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }
}
