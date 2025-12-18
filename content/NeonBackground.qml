import QtQuick

Rectangle {
    id: root
    anchors.fill: parent

    // Gradient chéo để tạo chiều sâu
    gradient: Gradient {
        orientation: Gradient.Vertical // Hoặc chéo nếu bạn xoay Rectangle, nhưng Vertical tối ưu hơn

        // Điểm đầu (Trên cùng): Đen sâu
        GradientStop { position: 0.0; color: "#050505" }

        // Điểm giữa (Ánh sáng Neon mờ): Sẽ thay đổi màu
        GradientStop {
            id: midStop
            position: 0.6
            color: "#0a0a1a" // Màu khởi điểm
        }

        // Điểm cuối (Dưới cùng): Đen sâu
        GradientStop { position: 1.0; color: "#020202" }
    }

    // Animation thay đổi màu điểm giữa (Ambient Pulse)
    SequentialAnimation {
        running: true
        loops: Animation.Infinite

        // Chuyển sang Xanh Cyan tối
        ColorAnimation { target: midStop; property: "color"; to: "#051515"; duration: 8000; easing.type: Easing.InOutSine }
        // Chuyển sang Tím than tối
        ColorAnimation { target: midStop; property: "color"; to: "#150515"; duration: 8000; easing.type: Easing.InOutSine }
        // Quay về Xanh dương tối
        ColorAnimation { target: midStop; property: "color"; to: "#050515"; duration: 8000; easing.type: Easing.InOutSine }
        // Quay về gốc
        ColorAnimation { target: midStop; property: "color"; to: "#0a0a1a"; duration: 8000; easing.type: Easing.InOutSine }
    }
}
