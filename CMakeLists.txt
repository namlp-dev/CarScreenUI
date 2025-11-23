cmake_minimum_required(VERSION 3.16)

project(CarScreenUI VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 QuickEffects)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appCarScreenUI
    main.cpp
)

qt_add_qml_module(appCarScreenUI
    URI CarScreenUI
    QML_FILES
        Main.qml
        components/NeonButton.qml
        components/NeonGauge.qml
        components/TopBar.qml
        components/SideMenu.qml
        components/BottomBar.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appCarScreenUI PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appCarScreenUI
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appCarScreenUI
    PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::QuickEffects
)

include(GNUInstallDirs)
install(TARGETS appCarScreenUI
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
