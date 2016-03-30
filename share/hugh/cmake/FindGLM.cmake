# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# .rst:
# FindGLM
# ----------------
#
# Find GLM headers
#
# Use this module by invoking find_package with the form::
#
#   find_package(GLM
#     [<version>]     # required minimum version (defaults to 0.9.5)
#     [REQUIRED]      # Fail with error if GLM is not found
#     )
#
# This module finds the root of the most recent or requested version of installed GLM
# headers and library. Results are reported in variables::
#
#   GLM_FOUND         - True if GLM was found.
#   GLM_VERSION       - Complete version string.
#   GLM_VERSION_MAJOR - Major version.
#   GLM_VERSION_MINOR - Minor version.
#   GLM_VERSION_PATCH - Patch version.
#   GLM_ROOT_DIR      - Installation directory.
#   GLM_INCLUDE_DIR   - Include directory for <glm/glm.h>.
#
# This module reads hints about search locations from variables::
#
#   GLM_ROOT_DIR - Preferred installation prefix
#                  this can be supplied before calling the module or as an environment variable.

set(_glm_HEADER_SEARCH_DIRS
    "/usr/include"
    "/usr/local/include")

set(_glm_ENV_ROOT_DIR "$ENV{GLM_ROOT_DIR}")

if(NOT GLM_ROOT_DIR AND _glm_ENV_ROOT_DIR)
  set(GLM_ROOT_DIR "${_glm_ENV_ROOT_DIR}")
endif()

if(GLM_ROOT_DIR)
  set(_glm_HEADER_SEARCH_DIRS
      "${GLM_ROOT_DIR}"
      "${GLM_ROOT_DIR}/include"
       ${_glm_HEADER_SEARCH_DIRS})
endif()

find_path(GLM_INCLUDE_DIR
          NAMES "glm/glm.hpp"
          HINTS ${_glm_HEADER_SEARCH_DIRS}
          DOC   "The directory where <glm/glm.hpp> resides")

set(GLM_VERSION_MAJOR "0")
set(GLM_VERSION_MINOR "9")
set(GLM_VERSION_PATCH "5")
set(GLM_VERSION       "${GLM_VERSION_MAJOR}.${GLM_VERSION_MINOR}.${GLM_VERSION_PATCH}")

if(GLM_INCLUDE_DIR)
  foreach(ver "MAJOR" "MINOR" "PATCH")
    set(_glm_HPP_VERSION_${ver}_LINE "#define GLM_VERSION_${ver}.[ \t]+")
    file(STRINGS "${GLM_INCLUDE_DIR}/glm/detail/setup.hpp"
      _glm_HPP_VERSION_${ver}_CONTENTS REGEX ${_glm_HPP_VERSION_${ver}_LINE})
    if("${_glm_HPP_VERSION_${ver}_CONTENTS}" MATCHES ".*${_glm_HPP_VERSION_${ver}_LINE}([0-9]+).*")
      set(GLM_VERSION_${ver} "${CMAKE_MATCH_1}")
    endif()
  endforeach()
  set(GLM_VERSION "${GLM_VERSION_MAJOR}.${GLM_VERSION_MINOR}.${GLM_VERSION_PATCH}")
endif()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(GLM
                                  FOUND_VAR     GLM_FOUND
                                  REQUIRED_VARS GLM_INCLUDE_DIR
                                  VERSION_VAR   GLM_VERSION)

if(GLM_FOUND AND VERBOSE)
  message(STATUS "GLM setup:\n"
    "   GLM_ROOT_DIR      = ${GLM_ROOT_DIR}\n"
    "   GLM_VERSION       = ${GLM_VERSION}\n"
    "   GLM_VERSION_MAJOR = ${GLM_VERSION_MAJOR}\n"
    "   GLM_VERSION_MINOR = ${GLM_VERSION_MINOR}\n"
    "   GLM_VERSION_PATCH = ${GLM_VERSION_PATCH}\n"
    "   GLM_INCLUDE_DIR   = ${GLM_INCLUDE_DIR}"
    )
endif()
