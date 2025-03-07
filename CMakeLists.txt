

cmake_minimum_required(VERSION 3.16)
project(QtPDFxTMDPlotter VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 20)

# Find Qt6 packages (vcpkg provides these)
find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2 Charts network )
find_package(GSL REQUIRED)
find_package(LibArchive REQUIRED)
find_package(CURL REQUIRED)
 find_package(Qt6 REQUIRED COMPONENTS PrintSupport)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appQtPDFxTMDPlotter
    main.cpp
)

set_source_files_properties(GlobalContext.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(appQtPDFxTMDPlotter
    URI QtPDFxTMDPlotter
    VERSION 1.0
    QML_FILES
        Main.qml
        PlotArea.qml
        PDFObjectItem.qml
        TopSection.qml
        PDFDialog.qml
        GlobalContext.qml
        SettingDialog.qml
        ColorPickerButton.qml
        LineStyleSelector.qml
    SOURCES
        PlotModel.h PlotModel.cpp
        PDFSetProvider.h PDFSetProvider.cpp
        PDFInfoModel.h PDFInfoModel.cpp
        PDFInfo.h
        Utils.h Utils.cpp
        PDFDataProvider.h PDFDataProvider.cpp
    RESOURCES
        resources.qrc
        QML_FILES
        QML_FILES
        SOURCES DownloadManager.h DownloadManager.cpp
        SOURCES PlotExporter.h PlotExporter.cpp
        SOURCES FileWriter.h FileWriter.cpp
)

set_target_properties(appQtPDFxTMDPlotter PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appQtPDFxTMDPlotter
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# Custom library includes (not managed by vcpkg)
target_include_directories(appQtPDFxTMDPlotter PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/lib3/PDFxTMDLib-0.2.0-win64/include"
)

# Link custom library based on build type
if(CMAKE_BUILD_TYPE MATCHES "Release")
    target_link_libraries(appQtPDFxTMDPlotter PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/lib3/PDFxTMDLib-0.2.0-win64/lib/Release/PDFxTMDLibStatic.lib"
    )
else()
    target_link_libraries(appQtPDFxTMDPlotter PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/lib3/PDFxTMDLib-0.2.0-win64/lib/Debug/PDFxTMDLibStatic.lib"
    )
    set(CMAKE_LIBRARY_PATH "${CMAKE_LIBRARY_PATH};${CMAKE_CURRENT_SOURCE_DIR}/lib3/PDFxTMDLib-0.2.0-win64/lib/Debug/")
    message(STATUS "CMAKE_LIBRARY_PATH: ${CMAKE_LIBRARY_PATH}")
endif()

# Link Qt6 libraries (provided by vcpkg)
target_link_libraries(appQtPDFxTMDPlotter PRIVATE
    Qt6::Quick
    Qt6::Charts
    Qt6::QuickControls2
    Qt6::PrintSupport
    GSL::gsl
    GSL::gslcblas
    ${CURL_LIBRARIES}
    ${LibArchive_LIBRARIES}
)

include(GNUInstallDirs)
install(TARGETS appQtPDFxTMDPlotter
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
