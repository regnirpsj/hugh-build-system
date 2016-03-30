# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# .rst:
# FindGLI
# ----------------
#
# Find GLI headers
#
# Use this module by invoking find_package with the form::
#
#   find_package(GLI
#     [<version>]     # required minimum version (defaults to 0.6.0)
#     [REQUIRED]      # Fail with error if GLI is not found
#     )
#
# This module finds the root of the most recent or requested version of installed GLI
# headers and library. Results are reported in variables::
#
#   GLI_FOUND         - True if GLI was found.
#   GLI_VERSION       - Complete version string.
#   GLI_VERSION_MAJOR - Major version.
#   GLI_VERSION_MINOR - Minor version.
#   GLI_VERSION_PATCH - Patch version.
#   GLI_ROOT_DIR      - Installation directory.
#   GLI_INCLUDE_DIR   - Include directory for <gli/gli.h>.
#
# This module reads hints about search locations from variables::
#
#   GLI_ROOT_DIR - Preferred installation prefix
#                  this can be supplied before calling the module or as an environment variable.

set(_gli_HEADER_SEARCH_DIRS
    "/usr/include"
    "/usr/local/include")

set(_gli_ENV_ROOT_DIR "$ENV{GLI_ROOT_DIR}")

if(NOT GLI_ROOT_DIR AND _gli_ENV_ROOT_DIR)
  set(GLI_ROOT_DIR "${_gli_ENV_ROOT_DIR}")
endif()

if(GLI_ROOT_DIR)
  set(_gli_HEADER_SEARCH_DIRS
      "${GLI_ROOT_DIR}"
      "${GLI_ROOT_DIR}/include"
       ${_gli_HEADER_SEARCH_DIRS})
endif()

find_path(GLI_INCLUDE_DIR
          NAMES "gli/gli.hpp"
          HINTS ${_gli_HEADER_SEARCH_DIRS}
          DOC   "The directory where <gli/gli.hpp> resides")

set(GLI_VERSION_MAJOR "0")
set(GLI_VERSION_MINOR "6")
set(GLI_VERSION_PATCH "0")
set(GLI_VERSION       "${GLI_VERSION_MAJOR}.${GLI_VERSION_MINOR}.${GLI_VERSION_PATCH}")

if(GLI_INCLUDE_DIR)
  foreach(ver "MAJOR" "MINOR" "PATCH")
    set(_gli_HPP_VERSION_${ver}_LINE "#define GLI_VERSION_${ver}.[ \t]+")
    file(STRINGS "${GLI_INCLUDE_DIR}/gli/gli.hpp"
      _gli_HPP_VERSION_${ver}_CONTENTS REGEX ${_gli_HPP_VERSION_${ver}_LINE})
    if("${_gli_HPP_VERSION_${ver}_CONTENTS}" MATCHES ".*${_gli_HPP_VERSION_${ver}_LINE}([0-9]+).*")
      set(GLI_VERSION_${ver} "${CMAKE_MATCH_1}")
    endif()
  endforeach()
  set(GLI_VERSION "${GLI_VERSION_MAJOR}.${GLI_VERSION_MINOR}.${GLI_VERSION_PATCH}")
endif()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(GLI
                                  FOUND_VAR     GLI_FOUND
                                  REQUIRED_VARS GLI_INCLUDE_DIR
                                  VERSION_VAR   GLI_VERSION)

if(GLI_FOUND AND VERBOSE)
  message(STATUS "GLI setup:\n"
    "   GLI_ROOT_DIR      = ${GLI_ROOT_DIR}\n"
    "   GLI_VERSION       = ${GLI_VERSION}\n"
    "   GLI_VERSION_MAJOR = ${GLI_VERSION_MAJOR}\n"
    "   GLI_VERSION_MINOR = ${GLI_VERSION_MINOR}\n"
    "   GLI_VERSION_PATCH = ${GLI_VERSION_PATCH}\n"
    "   GLI_INCLUDE_DIR   = ${GLI_INCLUDE_DIR}"
    )
endif()
