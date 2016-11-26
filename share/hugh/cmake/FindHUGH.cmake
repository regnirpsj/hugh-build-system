# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# .rst:
# FindHUGH
# --------
#
# Find Hull University Graphics Helper (HUGH) headers, and libraries
#
# Use this module by invoking find_package with the form::
#
#   find_package(HUGH
#     [REQUIRED]             # Fail with error if OGLplus is not found
#     [COMPONENTS <libs>...] # HUGH libraries by their canonical name
#     )                      # (e.g., "support" for "libhugh_support")
#
# This module finds the root of the most recent or requested version of installed HUGH
# headers and library. Results are reported in variables::
#
#   HUGH_FOUND        - True if HUGH was found.
#   HUGH_ROOT_DIR     - Installation directory.
#   HUGH_INCLUDE_DIRS - Include directories
#   HUGH_LIBRARIES    - HUGH component libraries to be linked
#
# This module reads hints about search locations from variables::
#
#   HUGH_INSTALL_PREFIX - Preferred installation prefix
#                         this can be supplied before calling the module or as an environment
#                         variable.

if(DEFINED ENV{HUGH_INSTALL_PREFIX})
  get_filename_component(dir $ENV{HUGH_INSTALL_PREFIX} ABSOLUTE BASE_DIR ${CMAKE_BINARY_DIR})
  set(HUGH_ROOT_DIR ${dir})
elseif(HUGH_INSTALL_PREFIX)
  get_filename_component(dir ${HUGH_INSTALL_PREFIX} ABSOLUTE BASE_DIR ${CMAKE_BINARY_DIR})
  set(HUGH_ROOT_DIR ${dir})
endif()

if(FALSE AND VERBOSE)
  message(STATUS "ENV{HUGH_INSTALL_PREFIX} = $ENV{HUGH_INSTALL_PREFIX}")
  message(STATUS "HUGH_INSTALL_PREFIX      = ${HUGH_INSTALL_PREFIX}")
  message(STATUS "HUGH_ROOT_DIR            = ${HUGH_ROOT_DIR}")
endif()

set(_hugh_HEADER_SEARCH_DIRS
  /usr/include
  /usr/local/include
  ${HUGH_ROOT_DIR}/include
  )

set(_hugh_LIBRARY_SEARCH_DIRS
  /usr/lib
  /usr/local/include
  ${HUGH_ROOT_DIR}/lib
  )

find_path(HUGH_INCLUDE_DIRS
          NAMES hugh/support.hpp
          HINTS ${_hugh_HEADER_SEARCH_DIRS}
          DOC   "The directory where <hugh/support.hpp> resides")

if(HUGH_INCLUDE_DIRS)
  list(REMOVE_DUPLICATES HUGH_INCLUDE_DIRS)
endif()

foreach(lib ${HUGH_FIND_COMPONENTS})
  find_library(HUGH_${lib}_LIBRARY
               NAMES hugh_${lib}
               PATHS ${_hugh_LIBRARY_SEARCH_DIRS}
               DOC   "The HUGH ${lib} library")
  if(HUGH_${lib}_LIBRARY)
    list(APPEND HUGH_LIBRARIES ${HUGH_${lib}_LIBRARY})
    set(HUGH_${lib}_FOUND TRUE)
  endif()
endforeach()

if(HUGH_LIBRARIES)
  list(REMOVE_DUPLICATES HUGH_LIBRARIES)
endif()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(HUGH
                                  FOUND_VAR     HUGH_FOUND
                                  REQUIRED_VARS HUGH_ROOT_DIR HUGH_INCLUDE_DIRS HUGH_LIBRARIES
				  HANDLE_COMPONENTS)

if(HUGH_FOUND AND VERBOSE)
  message(STATUS "HUGH setup:\n"
    "   HUGH_ROOT_DIR     = ${HUGH_ROOT_DIR}\n"
    "   HUGH_INCLUDE_DIRS = ${HUGH_INCLUDE_DIRS}\n"
    "   HUGH_LIBRARIES    = ${HUGH_LIBRARIES}")
endif()
