# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# .rst:
# FindXSDCXX
# ----------
#
# .. _CodeSynthesis: http://codesynthesis.com/
#
# Find `CodeSynthesis`_ xml-schema-to-c++ compiler, headers, and libraries
#
# Use this module by invoking find_package with the form::
#
#   find_package(XSDCXX
#     [REQUIRED]         # Fail with error if OGLplus is not found
#     )
#
# This module finds the root of the most recent or requested version of installed OGLplus
# headers and library. Results are reported in variables::
#
#   XSDCXX_FOUND        - True if OGLplus was found.
#   XSDCXX_ROOT_DIR     - Installation directory.
#   XSDCXX_COMPILER     - 
#   XSDCXX_INCLUDE_DIRS - Include directories for <oglplus/buffer.[h|i]pp>.
#
# This module reads hints about search locations from variables::
#
#   XSDCXX_ROOT_DIR - Preferred installation prefix
#                     this can be supplied before calling the module or as an environment variable.

set(_xsdcxx_ENV_ROOT_DIR "$ENV{XSDCXX_ROOT_DIR}")

if(NOT XSDCXX_ROOT_DIR AND _xsdcxx_ENV_ROOT_DIR)
  set(XSDCXX_ROOT_DIR "${_xsdcxx_ENV_ROOT_DIR}")
endif()

set(_xsdcxx_COMPILER_NAMES
  "xsdcxx"
  "xsd"
  )

set(_xsdcxx_COMPILER_PATHS
  "/usr/bin"
  "usr/local/bin"
  "${XSDCXX_ROOT_DIR}/bin"
  )

find_program(XSDCXX_COMPILER
             NAMES ${_xsdcxx_COMPILER_NAMES}
	     HINTS ${_xsdcxx_COMPILER_PATHS}
	     DOC   "The location of the xsd-to-cxx xompiler")

set(_xsdcxx_HEADER_SEARCH_DIRS
    "/usr/include"
    "/usr/local/include"
    "${XSDCXX_ROOT_DIR}/include")

find_path(XSDCXX_INCLUDE_DIRS
          NAMES "xsd/cxx/config.hxx"
          HINTS ${_xsdcxx_HEADER_SEARCH_DIRS}
          DOC   "The directory where <xsd/cxx/config.hxx> resides")
list(REMOVE_DUPLICATES XSDCXX_INCLUDE_DIRS)

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(XSDCXX
                                  FOUND_VAR     XSDCXX_FOUND
                                  REQUIRED_VARS XSDCXX_COMPILER XSDCXX_INCLUDE_DIRS)

if(XSDCXX_FOUND AND VERBOSE)
  message(STATUS "XSDCXX setup:\n"
    "   XSDCXX_ROOT_DIR     = ${XSDCXX_ROOT_DIR}\n"
    "   XSDCXX_COMPILER     = ${XSDCXX_COMPILER}\n"
    "   XSDCXX_INCLUDE_DIRS = ${XSDCXX_INCLUDE_DIRS}"
    )
endif()

# .rst:
# xsd_compile(CXX_SRC CXX_INC SOURCES .. [OUTPUTDIR ..] [OPTIONS ..] [DEBUG])
#   CXX_SRC   -
#   CXX_INC   -
#   SOURCES   -
#   OUTPUTDIR -
#   OPTIONS   -
#   DEBUG     -
#
function(xsd_compile CXX_SRC CXX_INC)
  if(NOT XSDCXX_FOUND)
    message(SEND_ERROR "Error: xsd-to-c++ compiler not found/configured")
    return()
  endif()

  include(CMakeParseArguments)

  set(OARGS DEBUG)
  set(SARGS OUTPUTDIR)
  set(MARGS SOURCES OPTIONS)
  cmake_parse_arguments(XSD "${OARGS}" "${SARGS}" "${MARGS}" ${ARGN})

  if(NOT XSD_SOURCES)
    message(SEND_ERROR "Error: xsd_compile() called without any source files")
    return()
  endif()

  list(APPEND XSD_OPTIONS --std c++11)
  list(APPEND XSD_OPTIONS --cxx-suffix .cpp)
  list(APPEND XSD_OPTIONS --hxx-suffix .hpp)

  set(${CXX_SRC})
  set(${CXX_INC} "${CMAKE_CURRENT_BINARY_DIR}")

  foreach(file_xsd ${XSD_SOURCES})
    get_filename_component(path_xsd     ${file_xsd} PATH)
    get_filename_component(base_xsd     ${file_xsd} NAME_WE)
    get_filename_component(file_xsd_abs ${file_xsd} ABSOLUTE)

    set(file_cxx "${CMAKE_CURRENT_BINARY_DIR}/${base_xsd}.cpp")
    set(file_hxx "${CMAKE_CURRENT_BINARY_DIR}/${base_xsd}.hpp")

    list(APPEND ${CXX_SRC} "${file_cxx}")

    add_custom_command(
      OUTPUT   "${file_cxx}" "${file_hxx}"
      COMMAND  ${XSDCXX_COMPILER}
      ARGS     ${XSD_OPTIONS} ${file_xsd_abs}
      DEPENDS  ${file_xsd}
      COMMENT  "${file_xsd_abs} -> ${file_cxx} + ${file_hxx}"
      VERBATIM
      )

    set_source_files_properties(${file_cxx} PROPERTIES GENERATED TRUE)
    set_source_files_properties(${file_hxx} PROPERTIES GENERATED TRUE)
  endforeach()

  if(XSD_DEBUG OR VERBOSE)
    message(STATUS "xsd_compile(${CXX_SRC};${CXX_INC};${ARGN}) variable setup:\n"
      "   ${CXX_SRC}    = ${${CXX_SRC}}\n"
      "   ${CXX_INC}    = ${${CXX_INC}}\n"
      "   XSD_SOURCES   = ${XSD_SOURCES}\n"
      "   XSD_OUTPUTDIR = ${XSD_OUTPUTDIR}\n"
      "   XSD_OPTIONS   = ${XSD_OPTIONS}")
  endif()

  set(${CXX_SRC} ${${CXX_SRC}} PARENT_SCOPE)
  set(${CXX_INC} ${${CXX_INC}} PARENT_SCOPE)
endfunction()
