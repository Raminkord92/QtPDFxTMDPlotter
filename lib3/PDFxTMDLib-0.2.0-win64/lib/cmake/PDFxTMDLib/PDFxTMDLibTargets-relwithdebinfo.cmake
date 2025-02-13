#----------------------------------------------------------------
# Generated CMake target import file for configuration "RelWithDebInfo".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "PDFxTMDLib::PDFxTMDLib" for configuration "RelWithDebInfo"
set_property(TARGET PDFxTMDLib::PDFxTMDLib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
set_target_properties(PDFxTMDLib::PDFxTMDLib PROPERTIES
  IMPORTED_IMPLIB_RELWITHDEBINFO "${_IMPORT_PREFIX}/lib/PDFxTMDLib.lib"
  IMPORTED_LOCATION_RELWITHDEBINFO "${_IMPORT_PREFIX}/bin/PDFxTMDLib.dll"
  )

list(APPEND _cmake_import_check_targets PDFxTMDLib::PDFxTMDLib )
list(APPEND _cmake_import_check_files_for_PDFxTMDLib::PDFxTMDLib "${_IMPORT_PREFIX}/lib/PDFxTMDLib.lib" "${_IMPORT_PREFIX}/bin/PDFxTMDLib.dll" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
