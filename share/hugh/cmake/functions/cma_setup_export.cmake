# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# .rst:
# cma_setup_export(NAME [FILE <string>] [PATH <string>] [PREFIX <string>] [DEBUG])
#   NAME   -
#   FILE   - file name
#   PATH   - relative install path
#   PREFIX - 
#   DEBUG  -
#
# see also [http://www.cmake.org/Wiki/BuildingWinDLL]
#
function(cma_setup_export EXP_TARGET)
  include(CMakeParseArguments)
  include(GenerateExportHeader)

  set(OARGS DEBUG)
  set(SARGS FILE PATH PREFIX)
  SET(MARGS)
  cmake_parse_arguments(EXP "${OARGS}" "${SARGS}" "${MARGS}" ${ARGN})

  if(NOT EXP_FILE)
    set(EXP_FILE "export.h")
  endif()

  if(NOT EXP_PATH)
    set(EXP_PATH ${EXP_TARGET})
    string(REPLACE "_" "/" EXP_PATH ${EXP_PATH})
  endif()

  set(dir "${PROJECT_BINARY_DIR}/exports")
  include_directories(${dir})
  get_filename_component(file ${EXP_FILE} NAME)
  set(EXP_FILE "${dir}/${EXP_PATH}/${file}")

  if(EXP_DEBUG OR VERBOSE)
    message(STATUS "cma_setup_export(${EXP_TARGET};${ARGN}) variable setup:\n"
      "   EXP_PREFIX = ${EXP_PREFIX}\n"
      "   EXP_TARGET = ${EXP_TARGET}\n"
      "   EXP_FILE   = ${EXP_FILE}\n"
      "   EXP_PATH   = ${EXP_PATH}")
  endif()
  
  generate_export_header(${EXP_TARGET} EXPORT_FILE_NAME ${EXP_FILE} PREFIX_NAME ${EXP_PREFIX})

  install(FILES ${EXP_FILE}
          DESTINATION ${${PROJECT_NAME}_HEADER_DIRECTORY}/${EXP_PATH}
	  COMPONENT   ${${PROJECT_NAME}_HDR_COMPONENT_NAME})
endfunction()
