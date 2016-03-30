# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# .rst:
# cma_setup_file_target(NAME SOURCES <list> DESTINATION <string> [SOURCE_BASE <string>] [DEBUG])
#   NAME        -
#   SOURCES     -
#   DESTINATION -
#   SOURCE_BASE -
#   DEBUG       -
#
# see also [http://www.cmake.org/pipermail/cmake/2010-March/035621.html]
#
function(cma_setup_file_target FT_NAME)
  include(CMakeParseArguments)

  set(OARGS DEBUG)
  set(SARGS DESTINATION SOURCE_BASE)
  SET(MARGS SOURCES)
  cmake_parse_arguments(FT "${OARGS}" "${SARGS}" "${MARGS}" ${ARGN})

  if(NOT FT_SOURCES)
    message(SEND_ERROR "Error: cma_setup_file_target called without any source files")
    return()
  endif()

  if(NOT FT_DESTINATION)
    message(SEND_ERROR "Error: cma_setup_file_target called without destination directory")
    return()
  endif()

  if(NOT FT_SOURCE_BASE)
    set(FT_SOURCE_BASE ${CMAKE_CURRENT_SOURCE_DIR})
  endif()
  
  if(FT_DEBUG OR VERBOSE)
    message(STATUS "cma_setup_file_target(${FT_NAME};${ARGN}) variable setup:\n"
      "   FT_NAME        = ${FT_NAME}\n"
      "   FT_SOURCES     = ${FT_SOURCES}\n"
      "   FT_DESTINATION = ${FT_DESTINATION}\n"
      "   FT_SOURCE_BASE = ${FT_SOURCE_BASE}")
  endif()

  if(NOT TARGET ${FT_NAME})
    add_custom_target(${FT_NAME})
  endif()

  foreach(file ${FT_SOURCES})
    get_filename_component(src_file ${file} NAME)
    get_filename_component(src_path ${file} DIRECTORY)

    if(NOT EXISTS " ${FT_DESTINATION}/${src_path}")
      file(MAKE_DIRECTORY "${FT_DESTINATION}/${src_path}")
    endif()

    add_custom_command(
      OUTPUT          "${FT_DESTINATION}/${src_path}/${src_file}"
      COMMAND         ${CMAKE_COMMAND}
      ARGS            -E copy "${FT_SOURCE_BASE}/${src_path}/${src_file}"
                              "${FT_DESTINATION}/${src_path}/${src_file}"
      MAIN_DEPENDENCY "${file}"
      COMMENT         "Copying '${FT_SOURCE_BASE}/${src_path}/${src_file}' -> '${FT_DESTINATION}/${src_path}/${src_file}'")

    string(REPLACE "${CMAKE_BINARY_DIR}" "" target "${FT_DESTINATION}/${src_path}/${src_file}")
    string(REPLACE "/" "_"  target "${target}")
    string(REPLACE "." "_"  target "${target}")
    string(REPLACE "__" "_" target "${target}")
    add_custom_target(${target} DEPENDS "${FT_DESTINATION}/${src_path}/${src_file}")
    add_dependencies(${FT_NAME} ${target})

    cma_add_target_to_list(${target} CMAKE_TARGET_LIST)
  endforeach()
endfunction()
