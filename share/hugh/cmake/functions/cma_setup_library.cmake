# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# .rst:
# cma_setup_library(NAME SOURCES .. [DEPENDENCIES ..] [INCDIR <string>] [PREFIX <string>] [WINRT]
#                   [DEBUG])
#   NAME         -
#   SOURCES      -
#   DEPENDENCIES -
#   INCDIR       -
#   PREFIX       -
#   WINRT        -
#   DEBUG        -
#
function(cma_setup_library LIB_NAME)
  include(CMakeParseArguments)
  include(functions/cma_utilities)
  
  set(OARGS WINRT DEBUG)
  set(SARGS INCDIR PREFIX)
  set(MARGS SOURCES DEPENDENCIES)
  cmake_parse_arguments(LIB "${OARGS}" "${SARGS}" "${MARGS}" ${ARGN})
  
  if(NOT LIB_SOURCES)
    message(SEND_ERROR "Error: cma_setup_library() called without any source files")
    return()
  endif()

  set(LIB_INCDIR_INSTALL ${LIB_INCDIR})

  if(NOT LIB_INCDIR)
    set(LIB_INCDIR "${PROJECT_SOURCE_DIR}/inc")
    
    if(LIB_PREFIX)
      set(LIB_INCDIR "${LIB_INCDIR}/${LIB_PREFIX}")
    endif()

    set(LIB_INCDIR "${LIB_INCDIR}/${LIB_NAME}")
  else()
    if(NOT IS_ABSOLUTE ${LIB_INCDIR})
      set(LIB_INCDIR "${PROJECT_SOURCE_DIR}/inc/${LIB_INCDIR}")
    endif()
  endif()

  file(GLOB TOPLVLHDR RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${LIB_INCDIR}*.hpp)
  list(APPEND LIB_SOURCES ${TOPLVLHDR})

  file(GLOB_RECURSE PUBHDRS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${LIB_INCDIR}/*.hpp)
  list(APPEND LIB_SOURCES ${PUBHDRS})

  file(GLOB_RECURSE PUBINLS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${LIB_INCDIR}/*.inl)
  list(APPEND LIB_SOURCES ${PUBINLS})

  file(GLOB_RECURSE PRVHDRS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
       ${CMAKE_CURRENT_SOURCE_DIR}/*.hpp)
  list(APPEND LIB_SOURCES ${PRVHDRS})

  file(GLOB_RECURSE PRVINLS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
       ${CMAKE_CURRENT_SOURCE_DIR}/*.inl)
  list(APPEND LIB_SOURCES ${PRVINLS})

  if(LIB_DEBUG OR VERBOSE)
    message(STATUS "cma_setup_library(${LIB_NAME};${ARGN}) variable setup:\n"
      "   LIB_NAME           = ${LIB_NAME}\n"
      "   LIB_SOURCES        = ${LIB_SOURCES}\n"
      "   LIB_DEPENDENCIES   = ${LIB_DEPENDENCIES}\n"
      "   LIB_INCDIR         = ${LIB_INCDIR}\n"
      "   LIB_INCDIR_INSTALL = ${LIB_INCDIR_INSTALL}")
  endif()
  
  add_library(${LIB_NAME} ${CMAKE_LIBRARY_TYPE} ${LIB_SOURCES})

  if(LIB_WINRT)
    cma_add_winrt_props(${LIB_NAME})
  endif()

  set_property(TARGET ${LIB_NAME} PROPERTY FOLDER "Libraries")
    
  source_group(Source          REGULAR_EXPRESSION ".+\\.cpp")
  source_group(Header\\Public  REGULAR_EXPRESSION ".+/${LIB_INCDIR}/.+\\.(hpp|inl)")
  source_group(Header\\Private REGULAR_EXPRESSION ".+\\.(hpp|inl)")

  target_link_libraries(${LIB_NAME} ${LIB_DEPENDENCIES})

  # 1. ARCHIVE|LIBRARY not pre-processed -> cannot be held in variable
  # 2. shared libs ARCHIVE section is for import lib files from .dlls
  if("SHARED" STREQUAL "${CMAKE_LIBRARY_TYPE}")    
    install(TARGETS             ${LIB_NAME}
            ARCHIVE DESTINATION ${${PROJECT_NAME}_LIBRARY_DIRECTORY}
            LIBRARY DESTINATION ${${PROJECT_NAME}_LIBRARY_DIRECTORY}
            COMPONENT           ${${PROJECT_NAME}_LIB_COMPONENT_NAME})
  else()
    install(TARGETS             ${LIB_NAME}
            ARCHIVE DESTINATION ${${PROJECT_NAME}_ARCHIVE_DIRECTORY}
            COMPONENT           ${${PROJECT_NAME}_LIB_COMPONENT_NAME})
  endif()
  
  if(EXISTS "${LIB_INCDIR}" AND IS_DIRECTORY "${LIB_INCDIR}")
    install(DIRECTORY   ${LIB_INCDIR}/
            DESTINATION ${${PROJECT_NAME}_HEADER_DIRECTORY}/${LIB_INCDIR_INSTALL}
            COMPONENT   ${${PROJECT_NAME}_HDR_COMPONENT_NAME}
            PATTERN "*~" EXCLUDE)
  endif()

  if (TOPLVLHDR)
    install(FILES       ${TOPLVLHDR}
            DESTINATION ${${PROJECT_NAME}_HEADER_DIRECTORY}/${LIB_INCDIR_INSTALL}/..
            COMPONENT   ${${PROJECT_NAME}_HDR_COMPONENT_NAME})
  endif()

  if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/version.hpp.in)
    configure_file(version.hpp.in version.hpp @ONLY)
    install(FILES       ${CMAKE_CURRENT_BINARY_DIR}/version.hpp
            DESTINATION ${${PROJECT_NAME}_HEADER_DIRECTORY}/${LIB_INCDIR_INSTALL}
            COMPONENT   ${${PROJECT_NAME}_HDR_COMPONENT_NAME})
  endif()

  cma_add_target_to_list(${LIB_NAME} CMAKE_TARGET_LIST)
endfunction()
