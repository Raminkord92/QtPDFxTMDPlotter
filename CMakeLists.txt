cmake_minimum_required(VERSION 3.16)

project(QtPDFxTMDPlotter VERSION 0.1 LANGUAGES CXX)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 20)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2)
find_package(Qt6 REQUIRED COMPONENTS Charts)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appQtPDFxTMDPlotter
    main.cpp
)


set_source_files_properties(GlobalContext.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
qt_add_qml_module(appQtPDFxTMDPlotter
    URI QtPDFxTMDPlotter
    VERSION 1.0
    QML_FILES
        Main.qml
        SOURCES
        SOURCES
        SOURCES PlotModel.h
        SOURCES PlotModel.cpp
        QML_FILES PlotArea.qml
        QML_FILES
        QML_FILES
        QML_FILES PDFObject.qml
        QML_FILES TopSection.qml
        QML_FILES
        QML_FILES PDFDialog.qml
        QML_FILES GlobalContext.qml
        SOURCES
        RESOURCES resources.qrc
        SOURCES
        QML_FILES SettingDialog.qml
        SOURCES PDFSetProvider.h PDFSetProvider.cpp
        SOURCES PDFInfo.h
        SOURCES PDFInfoModel.h PDFInfoModel.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appQtPDFxTMDPlotter PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appQtPDFxTMDPlotter
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_include_directories(appQtPDFxTMDPlotter PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/lib3/PDFxTMDLib-0.2.0-win64/include"
)
if(CMAKE_BUILD_TYPE MATCHES "Release")
target_link_libraries(appQtPDFxTMDPlotter PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/lib3/PDFxTMDLib-0.2.0-win64/lib/Release/PDFxTMDLibStatic.lib"
)
else()
    target_link_libraries(appQtPDFxTMDPlotter PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/lib3/PDFxTMDLib-0.2.0-win64/lib/Debug/PDFxTMDLibStatic.lib"
    )
endif()


target_link_libraries(appQtPDFxTMDPlotter
    PRIVATE Qt6::Quick
    Qt6::Charts
    Qt6::Widgets
    Qt6::Charts
    Qt6::QuickControls2
)

include(GNUInstallDirs)
install(TARGETS appQtPDFxTMDPlotter
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
