cmake_minimum_required(VERSION 3.30)
project(QtPDFxTMDPlotter VERSION 0.1.1 LANGUAGES CXX)

set(CMAKE_AUTORCC ON)  # Enable automatic resource compilation
set(CMAKE_AUTOMOC ON)  # Enable automatic MOC (meta-object compiler) for Qt

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2 Charts Network PrintSupport Concurrent)

qt_standard_project_setup(REQUIRES 6.5)

include(FetchContent)
FetchContent_Declare(
    pdfxtmd_lib
    GIT_REPOSITORY https://github.com/Raminkord92/PDFxTMD.git
    GIT_TAG adc9583d1d7d77bd34af78161b790c4cf3586f1a
    EXCLUDE_FROM_ALL
)
FetchContent_MakeAvailable(pdfxtmd_lib)

qt_add_executable(appQtPDFxTMDPlotter
    main.cpp
    app.rc
)

if(WIN32)
    set_property(TARGET appQtPDFxTMDPlotter PROPERTY WIN32_EXECUTABLE true)
endif()

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
        Settings/dialogs/SettingDialog.qml
        Settings/Views/AboutView.qml
        Settings/Views/PDFInfoView.qml
        Settings/wizard/DownloadProcessPage.qml
        Settings/wizard/PathSelectionPage.qml
        Settings/wizard/RepositorySelectionPage.qml
        ColorPickerButton.qml
        LineStyleSelector.qml
        GeneralComponents/ScrollableComboBox.qml
        GeneralComponents/LinkedLabel.qml
    SOURCES
        PlotModel.h PlotModel.cpp
        PDFSetProvider.h PDFSetProvider.cpp
        PDFInfoModel.h PDFInfoModel.cpp
        PDFInfo.h
        Utils.h Utils.cpp
        PDFDataProvider.h PDFDataProvider.cpp
        DownloadManager.h DownloadManager.cpp
        PlotExporter.h PlotExporter.cpp
        FileWriter.h FileWriter.cpp
        GenericPDFContainer.h GenericPDFContainer.cpp
        PDFInfo.cpp
    RESOURCES
        resources.qrc
)

target_include_directories(appQtPDFxTMDPlotter PRIVATE ${PROJECT_SOURCE_DIR}/PDFxTMD/include)

find_package(LibArchive REQUIRED)
target_link_libraries(appQtPDFxTMDPlotter PRIVATE
    Qt6::Quick
    Qt6::Charts
    Qt6::QuickControls2
    Qt6::PrintSupport
    Qt6::Network
    Qt6::Concurrent
    LibArchive::LibArchive
    PDFxTMDLib
)

# Installation rules for Windows
if(WIN32)

    install(TARGETS appQtPDFxTMDPlotter
            RUNTIME DESTINATION .
        )
        install(RUNTIME_DEPENDENCY_SET appQtPDFxTMDPlotter
            DESTINATION .
        )

        # Locate and use windeployqt to handle Qt dependencies
        find_package(Qt6 COMPONENTS Core)
        get_target_property(_qmake_executable Qt6::qmake IMPORTED_LOCATION)
        get_filename_component(_qt_bin_dir "${_qmake_executable}" DIRECTORY)
        find_program(WINDEPLOYQT_EXECUTABLE windeployqt HINTS "${_qt_bin_dir}")
        install(CODE "execute_process(COMMAND \"${WINDEPLOYQT_EXECUTABLE}\" --qmldir \"${CMAKE_CURRENT_SOURCE_DIR}\" \"\${CMAKE_INSTALL_PREFIX}/$<TARGET_FILE_NAME:appQtPDFxTMDPlotter>\")")
    # Install the executable

    # Copy all necessary files from the Release folder to the installation directory
    install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/Release/"
        DESTINATION .
        FILES_MATCHING PATTERN "*.dll"
    )
endif()

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.txt")
    install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.txt" DESTINATION .)
endif()
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/app.ico")
    install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/app.ico" DESTINATION .)
endif()

set(CPACK_PACKAGE_NAME "QtPDFxTMDPlotter")
set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
set(CPACK_PACKAGE_VENDOR "Ramin Kord")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Plotting app for cPDFs and TMDs distribution using PDFxTMDLib")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.txt")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "QtPDFxTMDPlotter")
set(CPACK_PACKAGE_FILE_NAME "QtPDFxTMDPlotter-${PROJECT_VERSION}")

if(WIN32)
  set(CPACK_GENERATOR "NSIS;ZIP")
  set(CPACK_NSIS_MODIFY_PATH ON)
  set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
  set(CPACK_NSIS_DISPLAY_NAME "QtPDFxTMDPlotter")
  set(CPACK_NSIS_PACKAGE_NAME "QtPDFxTMDPlotter")
  set(CPACK_NSIS_CREATE_ICONS_EXTRA "
    CreateShortCut '$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\QtPDFxTMDPlotter.lnk' '$INSTDIR\\\\appQtPDFxTMDPlotter.exe'
    CreateShortCut '$DESKTOP\\\\QtPDFxTMDPlotter.lnk' '$INSTDIR\\\\appQtPDFxTMDPlotter.exe'
  ")

  set(CPACK_NSIS_MUI_ICON "${CMAKE_CURRENT_SOURCE_DIR}/app.ico")  # Icon for installer
  set(CPACK_NSIS_INSTALLED_ICON_NAME "appQtPDFxTMDPlotter.exe")  # Icon for uninstaller
  set(CPACK_NSIS_URL_INFO_ABOUT "https://github.com/Raminkord92/QtPDFxTMDPlotter")  # Optional: About URL
  set(CPACK_NSIS_CONTACT "raminkord92l@gmail.com")  # Optional: Contact info
  set(CPACK_NSIS_HELP_LINK "https://github.com/Raminkord92/QtPDFxTMDPlotter/wiki")  # Optional: Help URL
endif()

include(CPack)
