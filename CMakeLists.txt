cmake_minimum_required(VERSION 3.16)
project(QtPDFxTMDPlotter VERSION 0.1 LANGUAGES CXX)

# Set vcpkg toolchain (modify path to your vcpkg installation)
set(CMAKE_TOOLCHAIN_FILE "C:/vcpkg/scripts/buildsystems/vcpkg.cmake" CACHE STRING "Vcpkg toolchain file")

set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find Qt components
find_package(Qt6 6.5 REQUIRED COMPONENTS
    Quick
    QuickControls2
    Charts
    Network
    PrintSupport
    concurrent
)

# Find vcpkg-provided dependencies
find_package(GSL REQUIRED)
find_package(LibArchive REQUIRED)
find_package(CURL REQUIRED)

qt_standard_project_setup(REQUIRES 6.5)

add_subdirectory(PDFxTMD)

# Application executable
qt_add_executable(appQtPDFxTMDPlotter
    main.cpp
)

# QML module setup
set_source_files_properties(GlobalContext.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

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
        ScrollableComboBox.qml
    SOURCES
        PlotModel.h PlotModel.cpp
        PDFSetProvider.h PDFSetProvider.cpp
        PDFInfoModel.h PDFInfoModel.cpp
        PDFInfo.h
        Utils.h Utils.cpp
        PDFDataProvider.h PDFDataProvider.cpp
    RESOURCES
        resources.qrc
    SOURCES
        DownloadManager.h DownloadManager.cpp
        PlotExporter.h PlotExporter.cpp
        FileWriter.h FileWriter.cpp
        GenericPDFContainer.h GenericPDFContainer.cpp
        PDFInfo.cpp
)
target_include_directories(appQtPDFxTMDPlotter PRIVATE ${PROJECT_SOURCE_DIR}/PDFxTMD/include)

# Link dependencies
target_link_libraries(appQtPDFxTMDPlotter PRIVATE
    Qt6::Quick
    Qt6::Charts
    Qt6::QuickControls2
    Qt6::PrintSupport
    Qt6::Network
    GSL::gsl
    GSL::gslcblas
    ${CURL_LIBRARIES}
    ${LibArchive_LIBRARIES}
    PDFxTMDLibStatic
)

# Installation rules
install(TARGETS appQtPDFxTMDPlotter
    RUNTIME DESTINATION bin
    BUNDLE DESTINATION .
    LIBRARY DESTINATION lib
)

# Install Qt plugins and QML modules needed by the application
if(WIN32)
    # Find windeployqt
    find_package(Qt6 COMPONENTS Core)
    get_target_property(_qmake_executable Qt6::qmake IMPORTED_LOCATION)
    get_filename_component(_qt_bin_dir "${_qmake_executable}" DIRECTORY)
    find_program(WINDEPLOYQT_EXECUTABLE windeployqt HINTS "${_qt_bin_dir}")

    # Run windeployqt as a post-build step
    add_custom_command(TARGET appQtPDFxTMDPlotter POST_BUILD
        COMMAND "${CMAKE_COMMAND}" -E
            env PATH="${_qt_bin_dir}" "${WINDEPLOYQT_EXECUTABLE}"
            --qmldir "${CMAKE_CURRENT_SOURCE_DIR}"
            "$<TARGET_FILE:appQtPDFxTMDPlotter>"
        COMMENT "Running windeployqt..."
    )

    # Fix for multi-configuration generators (like Visual Studio)
    # We need to explicitly list what to install rather than using directory install
    if(MSVC)
        # Install the executable and dependencies
        install(FILES 
            "$<TARGET_FILE:appQtPDFxTMDPlotter>"
            DESTINATION bin
        )

        # Install DLLs deployed by windeployqt - use a glob expression
        file(GLOB_RECURSE QT_DEPLOYED_FILES
            LIST_DIRECTORIES false
            "${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG>/*.dll"
            "${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG>/*.qm"
            "${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG>/qml/*"
            "${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG>/plugins/*"
        )

        foreach(FILE ${QT_DEPLOYED_FILES})
            get_filename_component(DIR_PATH ${FILE} DIRECTORY)
            file(RELATIVE_PATH REL_DIR ${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG> ${DIR_PATH})
            install(FILES ${FILE} DESTINATION bin/${REL_DIR})
        endforeach()
    else()
        # For non-MSVC generators
        install(
            DIRECTORY "$<TARGET_FILE_DIR:appQtPDFxTMDPlotter>/"
            DESTINATION bin
            PATTERN "*.pdb" EXCLUDE
            PATTERN "CMakeFiles" EXCLUDE
            PATTERN "cmake_install.cmake" EXCLUDE
            PATTERN "CPackConfig.cmake" EXCLUDE
            PATTERN "CPackSourceConfig.cmake" EXCLUDE
            PATTERN "CMakeCache.txt" EXCLUDE
            PATTERN "Makefile" EXCLUDE
            PATTERN "*.vcxproj*" EXCLUDE
            PATTERN "*.sln" EXCLUDE
        )
    endif()

    # Install runtime dependencies for third-party libraries
    if(CMAKE_VERSION VERSION_GREATER_EQUAL "3.21")
        install(RUNTIME_DEPENDENCY_SET appQtPDFxTMDPlotter
            DESTINATION bin
        )
    endif()
endif()

# Install additional required files
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.txt")
    install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.txt" DESTINATION .)
endif()

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/app.ico")
    install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/app.ico" DESTINATION .)
endif()

# CPack configuration (NSIS)
set(CPACK_PACKAGE_NAME "QtPDFxTMDPlotter")
set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
set(CPACK_PACKAGE_VENDOR "Your Company")
set(CPACK_PACKAGE_DESCRIPTION "PDF xTMD Plotter Application")
set(CPACK_NSIS_MODIFY_PATH ON)
set(CPACK_NSIS_MUI_ICON "${CMAKE_CURRENT_SOURCE_DIR}/app.ico")
set(CPACK_NSIS_MUI_UNIICON "${CMAKE_CURRENT_SOURCE_DIR}/app.ico")
set(CPACK_CREATE_DESKTOP_LINKS "appQtPDFxTMDPlotter")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.txt")

include(CPack)
