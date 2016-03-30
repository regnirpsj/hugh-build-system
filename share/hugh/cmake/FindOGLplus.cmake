# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# .rst:
# FindOGLplus
# ----------------
#
# Find OGLplus headers
#
# Use this module by invoking find_package with the form::
#
#   find_package(OGLplus
#     [REQUIRED]         # Fail with error if OGLplus is not found
#     )
#
# This module finds the root of the most recent or requested version of installed OGLplus
# headers and library. Results are reported in variables::
#
#   OGLplus_FOUND        - True if OGLplus was found.
#   OGLplus_ROOT_DIR     - Installation directory.
#   OGLplus_INCLUDE_DIRS - Include directories for <oglplus/buffer.[h|i]pp>.
#
# This module reads hints about search locations from variables::
#
#   OGLplus_ROOT_DIR - Preferred installation prefix
#                      this can be supplied before calling the module or as an environment variable.

set(_oglplus_HEADER_SEARCH_DIRS
    "/usr/include"
    "/usr/local/include")

set(_oglplus_ENV_ROOT_DIR "$ENV{OGLplus_ROOT_DIR}")

if(NOT OGLplus_ROOT_DIR AND _oglplus_ENV_ROOT_DIR)
  set(OGLplus_ROOT_DIR "${_oglplus_ENV_ROOT_DIR}")
endif()

if(OGLplus_ROOT_DIR)
  set(_oglplus_HEADER_SEARCH_DIRS
      "${OGLplus_ROOT_DIR}"
      "${OGLplus_ROOT_DIR}/include"
      "${OGLplus_ROOT_DIR}/implement"
       ${_oglplus_HEADER_SEARCH_DIRS})
endif()

# non-installed build-only locations will have .hpp/.ipp files in different directories;
# in case of an installed location, i.e. .hpp/.ipp in the same place, the following
# 'LIST(REMOVE_DUPLICATES ...)' takes care of duplicates
find_path(OGLplus_HPP_DIR
          NAMES "oglplus/buffer.hpp"
          HINTS ${_oglplus_HEADER_SEARCH_DIRS}
          DOC   "The directory where <oglplus/buffer.[h|i]pp> resides")
find_path(OGLplus_IPP_DIR
          NAMES "oglplus/buffer.ipp"
          HINTS ${_oglplus_HEADER_SEARCH_DIRS}
          DOC   "The directory where <oglplus/buffer.ipp> resides")
set(OGLplus_INCLUDE_DIRS "${OGLplus_HPP_DIR};${OGLplus_IPP_DIR}")
list(REMOVE_DUPLICATES OGLplus_INCLUDE_DIRS)

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(OGLplus
                                  FOUND_VAR     OGLplus_FOUND
                                  REQUIRED_VARS OGLplus_INCLUDE_DIRS)

if(OGLplus_FOUND AND VERBOSE)
  message(STATUS "OGLplus setup:\n"
    "   OGLplus_ROOT_DIR     = ${OGLplus_ROOT_DIR}\n"
    "   OGLplus_INCLUDE_DIRS = ${OGLplus_INCLUDE_DIRS}"
    )
endif()
