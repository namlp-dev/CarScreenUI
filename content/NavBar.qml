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
            iconPath: "M12,11c-1.1,0-2,0.9-2,2s0.9,2,2,2s2-0.9,2-2S13.1,11,12,11z M12,2C6.48,2,2,6.48,2,12s4.48,10,10,10s10-4.48,10-10 S17.52,2,12,2z M12,20c-4.41,0-8-4-8-8s4-8,8-8s8,4,8,8S16.41,20,12,20z M12.89,6.04c0.55-0.12,1.09,0.22,1.21,0.78 c0.37,1.75,1.52,3.22,3.13,4.02c0.5,0.25,0.7,0.85,0.45,1.35s-0.85,0.7-1.35,0.45c-2.14-1.06-3.66-3.01-4.16-5.34 C12.04,6.75,12.33,6.17,12.89,6.04z M7.79,9.49c1.61-0.8,2.76-2.27,3.13-4.02c0.12-0.55,0.68-0.9,1.23-0.78 c0.55,0.12,0.9,0.68,0.78,1.23c-0.5,2.33-2.03,4.28-4.16,5.34c-0.16,0.08-0.32,0.12-0.49,0.12c-0.34,0-0.67-0.18-0.86-0.48 C7.17,10.45,7.29,9.74,7.79,9.49z";
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
