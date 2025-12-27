# Neon Car Infotainment System

Hệ thống thông tin giải trí trên ô tô (IVI) hiện đại với phong cách thiết kế Neon, được xây dựng bằng **Qt 6 (C++ & QML)**. Dự án mô phỏng các chức năng cốt lõi của bảng điều khiển xe điện, bao gồm giám sát thông số vận hành, điều khiển khí hậu 2 vùng và trình phát đa phương tiện.

## 🚀 Tính năng nổi bật

* **Dashboard (Bảng đồng hồ):**
    * Đồng hồ tốc độ Neon thời gian thực.
    * Mô hình xe trực quan hóa trạng thái lốp (TPMS) và cảnh báo lỗi.
    * Hiển thị hộp số (P, R, N, D), pin và xi-nhan.
* **Climate Control (Điều hòa):**
    * Điều khiển 2 vùng độc lập (Driver/Passenger).
    * Chế độ SYNC (đồng bộ), AUTO và lấy gió trong/ngoài.
    * Giao diện núm xoay (`NeonTempDial`) và hiệu ứng dòng chảy năng lượng.
* **Media Player:**
    * Hỗ trợ quét file từ bộ nhớ máy (`.mp3`, `.wav`, `.mp4`).
    * Tự động phân loại nhạc và video.
    * Chế độ xem video Fullscreen với tính năng tự động ẩn điều khiển.
* **Simulator (Controller Window):**
    * Cửa sổ riêng biệt dành cho Dev/Tester để giả lập tín hiệu xe (tăng tốc, xả pin, xi-nhan, thay đổi áp suất lốp) mà không cần kết nối phần cứng thật.

## 🛠 Công nghệ sử dụng

* **Framework:** Qt 6.8.
* **Ngôn ngữ:**
    * **C++17:** Xử lý Backend, Singleton Data, File System.
    * **QML & JavaScript:** Xử lý giao diện (UI), Hiệu ứng (Animations) và Logic hiển thị.
* **Build System:** CMake.
* **API:** GeoJS (Location) & Open-Meteo (Weather).

## 📂 Cấu trúc dự án

```text
├── CMakeLists.txt       # Cấu hình build dự án
├── main.cpp             # Entry point, đăng ký C++ Types
├── src/                 # Source code C++ (Backend)
│   ├── vehicledata.h/cpp    # Singleton quản lý trạng thái xe
│   └── filescanner.h/cpp    # Xử lý quét file hệ thống
├── content/             # Source code QML (Frontend)
│   ├── Main.qml             # Màn hình chính
│   ├── DashboardScreen.qml  # Màn hình đồng hồ
│   ├── ClimateScreen.qml    # Màn hình điều hòa
│   ├── MediaScreen.qml      # Màn hình giải trí
│   ├── ControllerWindow.qml # Cửa sổ giả lập (Simulator)
│   └── Components...        # (NeonGauge, NavBar, TopBar...)