cmake_minimum_required(VERSION 3.16)

project(NeonCarInfotainment VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Multimedia Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appNeonCarInfotainment
    main.cpp
    src/FileScanner.h
    src/FileScanner.cpp
    src/VehicleData.h
    src/VehicleData.cpp

)

qt_add_qml_module(appNeonCarInfotainment
    URI "NeonUI"
    VERSION 1.0
    QML_FILES
        content/Main.qml
        content/NavBar.qml
        content/TopBar.qml
        content/DashboardScreen.qml
        content/ClimateScreen.qml
        content/MediaScreen.qml
        content/NeonGauge.qml
        content/NeonBackground.qml
        content/NeonTempDial.qml
        content/ControllerWindow.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appNeonCarInfotainment PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appNeonCarInfotainment
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appNeonCarInfotainment
    PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::Multimedia Qt6::Core
)

include(GNUInstallDirs)
install(TARGETS appNeonCarInfotainment
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
