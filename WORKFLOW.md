# Project Workflow: Neon Car Infotainment

Tài liệu này mô tả luồng hoạt động (Workflow) và kiến trúc dữ liệu của hệ thống Neon Car Infotainment.

## 1. Kiến trúc Tổng quan (System Architecture)

Hệ thống sử dụng mô hình **Model-View-ViewModel (MVVM)** biến thể, với:
* **Backend (Model/ViewModel):** Viết bằng C++ (Qt Core), xử lý logic nghiệp vụ, quản lý trạng thái xe và truy cập hệ thống file.
* **Frontend (View):** Viết bằng QML (Qt Quick), chịu trách nhiệm hiển thị giao diện và hiệu ứng động.

Giao tiếp giữa C++ và QML được thực hiện thông qua hệ thống **Signals & Slots** và **Qt Properties**.

---

## 2. Quy trình Khởi tạo (Initialization Workflow)

Quy trình diễn ra khi ứng dụng bắt đầu chạy (`main.cpp`):

1.  **Khởi tạo `QGuiApplication`**: Thiết lập môi trường ứng dụng Qt.
2.  **Đăng ký Backend (Singleton):**
    * Class `VehicleData` được khởi tạo dưới dạng **Singleton Instance**.
    * Đăng ký với QML engine dưới tên module `NeonBackend` để toàn bộ file QML có thể truy cập dữ liệu xe mọi lúc.
3.  **Đăng ký Utilities:**
    * Class `FileScanner` được đăng ký dạng `qmlRegisterType` để tạo instance mới khi cần quét file media.
4.  **Load Giao diện:**
    * Load `Main.qml`: Cửa sổ chính của màn hình xe.
    * Load `ControllerWindow.qml`: Cửa sổ điều khiển (giả lập tín hiệu xe) chạy song song.

---

## 3. Luồng Dữ liệu Xe (Vehicle Data Flow)

Đây là luồng cốt lõi giúp đồng bộ dữ liệu giữa màn hình hiển thị và bộ điều khiển giả lập.

1.  **Nguồn dữ liệu:** Người dùng thao tác trên `ControllerWindow.qml` (ví dụ: kéo thanh trượt tốc độ).
2.  **Cập nhật Backend:**
    * `ControllerWindow` gọi trực tiếp vào `VehicleData.speed = value`.
    * Setter trong C++ (`VehicleData::setSpeed`) cập nhật biến `m_speed`.
3.  **Thông báo thay đổi (Notify):**
    * C++ phát ra tín hiệu `speedChanged()`.
4.  **Cập nhật Giao diện:**
    * Các thành phần trong `DashboardScreen.qml` (như `NeonGauge`) đang bind với `VehicleData.speed` sẽ tự động nhận tín hiệu và vẽ lại giao diện mới ngay lập tức.

---

## 4. Các Luồng Tính năng Chi tiết (Feature Workflows)

### 4.1. Hệ thống Media (Music & Video)
Luồng xử lý khi người dùng muốn nghe nhạc hoặc xem video:

1.  **Yêu cầu quét file:** Người dùng nhấn nút "Browse Media" hoặc dấu "+" trên `MediaScreen`.
2.  **Xử lý tại Backend:**
    * QML gọi `fileScanner.scanForMediaFiles(folderUrl)`.
    * C++ (`filescanner.cpp`) chuyển đổi URL sang đường dẫn cục bộ, quét các file đuôi `.mp3`, `.wav`, `.mp4` và trả về danh sách `QStringList`.
3.  **Phát Media:**
    * `MediaScreen` nhận danh sách, cập nhật `songList` tại `Main.qml`.
    * Khi chọn bài, hệ thống kiểm tra đuôi file:
        * **Audio:** Hiển thị giao diện nghe nhạc, ảnh bìa album.
        * **Video:** Chuyển sang `VideoOutput`, hiển thị nút Fullscreen.
4.  **Logic Next/Prev:** Hàm `nextSong()` trong `Main.qml` sẽ tự động bỏ qua các file không phù hợp với chế độ hiện tại (ví dụ: đang ở chế độ Video sẽ bỏ qua file mp3).

### 4.2. Hệ thống Điều hòa (Climate Control)
Luồng xử lý logic thông minh của điều hòa 2 vùng:

1.  **Điều chỉnh nhiệt độ:** Người dùng xoay `NeonTempDial`.
2.  **Logic Đồng bộ (SYNC):**
    * Nếu chế độ `SYNC` đang bật: Thay đổi nhiệt độ bên Tài (Driver) sẽ tự động gán giá trị đó cho bên Phụ (Passenger) thông qua `VehicleData`.
    * Nếu người dùng xoay núm bên Phụ: Hệ thống tự động tắt chế độ `SYNC`.
3.  **Logic Màu sắc:**
    * Hàm `getClimateColor` tính toán màu (Xanh/Đỏ) dựa trên nhiệt độ và chế độ (Cool/Heat) để cập nhật màu đèn LED nền.

### 4.3. Cảnh báo Áp suất lốp (TPMS)
1.  **Giám sát:** `DashboardScreen` liên tục lắng nghe giá trị `VehicleData.tireFL`, `tireFR`, v.v.
2.  **Kích hoạt cảnh báo:**
    * Nếu giá trị áp suất < 30 PSI, thuộc tính `isError` trong `WheelView` trở thành `true`.
    * Giao diện kích hoạt hiệu ứng `MultiEffect` (Glow màu đỏ) và animation nhấp nháy tại vị trí bánh xe bị lỗi.

---

## 5. Cấu trúc Điều hướng (Navigation)

* **NavBar:** Thanh điều hướng bên trái, quản lý `StackView`. Khi chọn icon, nó gọi `replace()` để thay đổi màn hình chính mà không phá hủy trạng thái của `Main.qml`.
* **TopBar:** Luôn hiển thị, cập nhật thời gian thực và thời tiết (qua API) độc lập với màn hình nội dung bên dưới.