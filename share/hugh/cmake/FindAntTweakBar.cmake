# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# .rst:
# FindAntTweakBar
# ----------------
#
# Find AntTweakBar header and library
#
# Use this module by invoking find_package with the form::
#
#   find_package(AntTweakBar
#     [<version>]             # required minimum version (defaults to 2.8.0)
#     [REQUIRED]              # Fail with error if AntTweakBar is not found
#     )
#
# This module finds the root of the most recent or requested version of installed AntTweakBar
# headers and library. Results are reported in variables::
#
#   AntTweakBar_FOUND         - True if AntTweakBar was found.
#   AntTweakBar_VERSION       - Version per gluGet(GLUT_VERSION).
#   AntTweakBar_VERSION_MAJOR - Major version per gluGet(GLUT_VERSION).
#   AntTweakBar_VERSION_MINOR - Minor version per gluGet(GLUT_VERSION).
#   AntTweakBar_ROOT_DIR      - Installation directory.
#   AntTweakBar_INCLUDE_DIR   - Include directory for <GL/freeglut*.h>.
#   AntTweakBar_LIBRARY       - AntTweakBar library.
#
# This module reads hints about search locations from variables::
#
#   AntTweakBar_ROOT_DIR - Preferred installation prefix
#                          this can be supplied before calling the module or as an environment
#                          variable.

set(_atb_HEADER_SEARCH_DIRS
    "/usr/include"
    "/usr/local/include")

set(_atb_LIBRARY_SEARCH_DIRS
    "/usr/lib"
    "/usr/local/lib")

set(_atb_ENV_ROOT_DIR "$ENV{AntTweakBar_ROOT_DIR}")

if(NOT AntTweakBar_ROOT_DIR AND _atb_ENV_ROOT_DIR)
  set(AntTweakBar_ROOT_DIR "${_atb_ENV_ROOT_DIR}")
endif()

if(AntTweakBar_ROOT_DIR)
  set(_atb_HEADER_SEARCH_DIRS
      "${AntTweakBar_ROOT_DIR}"
      "${AntTweakBar_ROOT_DIR}/include"
      ${_atb_HEADER_SEARCH_DIRS})
  set(_atb_LIBRARY_SEARCH_DIRS
      "${AntTweakBar_ROOT_DIR}"
      "${AntTweakBar_ROOT_DIR}/lib"
      "${AntTweakBar_ROOT_DIR}/bin"
       ${_atb_LIBRARY_SEARCH_DIRS})
endif()

find_path(AntTweakBar_INCLUDE_DIR
          NAMES "AntTweakBar.h"
          HINTS ${_atb_HEADER_SEARCH_DIRS}
          DOC   "The directory where <AntTweakBar.h> resides")

if(MSVC AND CMAKE_CL_64)
  set(_atb_LIBRARY_NAME AntTweakBar64)
else()
  set(_atb_LIBRARY_NAME AntTweakBar)
endif()

find_library(AntTweakBar_LIBRARY
             NAMES ${_atb_LIBRARY_NAME}
             PATHS ${_atb_LIBRARY_SEARCH_DIRS}
             DOC   "The AntTweakBar library")

set(AntTweakBar_VERSION_MAJOR "1")
set(AntTweakBar_VERSION_MINOR "10")
set(AntTweakBar_VERSION       "${AntTweakBar_VERSION_MAJOR}.${AntTweakBar_VERSION_MINOR}")

if(AntTweakBar_INCLUDE_DIR)
  set(_atb_HPP_VERSION_LINE "#define TW_VERSION.[ \t]+")
  file(STRINGS "${AntTweakBar_INCLUDE_DIR}/AntTweakBar.h" _atb_HPP_VERSION_CONTENTS
    REGEX ${_atb_HPP_VERSION_LINE})
  if("${_atb_HPP_VERSION_CONTENTS}" MATCHES ".*${_atb_HPP_VERSION_LINE}([0-9]+).*")
    set(AntTweakBar_VERSION "${CMAKE_MATCH_1}")
    math(EXPR AntTweakBar_VERSION_MAJOR "${AntTweakBar_VERSION} / 100")
    math(EXPR AntTweakBar_VERSION_MINOR "${AntTweakBar_VERSION} % 100")
    set(AntTweakBar_VERSION "${AntTweakBar_VERSION_MAJOR}.${AntTweakBar_VERSION_MINOR}")
  endif()
endif()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(AntTweakBar
                                  FOUND_VAR     AntTweakBar_FOUND
                                  REQUIRED_VARS AntTweakBar_INCLUDE_DIR
                                                AntTweakBar_LIBRARY
                                  VERSION_VAR   AntTweakBar_VERSION)

if(AntTweakBar_FOUND AND VERBOSE)
  message(STATUS "AntTweakBar setup:\n"
    "   AntTweakBar_ROOT_DIR      = ${AntTweakBar_ROOT_DIR}\n"
    "   AntTweakBar_VERSION       = ${AntTweakBar_VERSION}\n"
    "   AntTweakBar_VERSION_MAJOR = ${AntTweakBar_VERSION_MAJOR}\n"
    "   AntTweakBar_VERSION_MINOR = ${AntTweakBar_VERSION_MINOR}\n"
    "   AntTweakBar_INCLUDE_DIR   = ${AntTweakBar_INCLUDE_DIR}\n"
    "   AntTweakBar_LIBRARY       = ${AntTweakBar_LIBRARY}"
    )
endif()
