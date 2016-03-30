# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# .rst:
# FindGLEW
# ----------------
#
# Find GLEW header(s) and library
#
# Use this module by invoking find_package with the form::
#
#   find_package(GLEW
#     [REQUIRED]          # Fail with error if GLEW is not found
#     [COMPONENTS
#      [STATIC]?          # prefer static library over shared/dynamic library
#      [MX]?              # prefer multi-context init version
#     ]
#     )
#
# This module finds the root of the most recent or requested version of installed GLEW headers
# and library. Results are reported in variables::
#
#   GLEW_FOUND            - True if GLEW was found.
#   GLEW_ROOT_DIR         - Installation directory.
#   GLEW_DEFINITIONS      - Compile-time definitions necessary for default/STATIC/MX variants.
#   GLEW_INCLUDE_DIR      - Include directory for <GL/[w][gl][x]ew.h>.
#   GLEW_LIBRARY          - GLUT library.
#
# This module reads hints about search locations from variables::
#
#   GLEW_ROOT_DIR - Preferred installation prefix
#                   this can be supplied before calling the module or as an environment variable.

if (GLEW_FIND_COMPONENTS)
  string(REPLACE "COMPONENTS" ""  GLEW_FIND_COMPONENTS "${GLEW_FIND_COMPONENTS}")
  string(REPLACE " "          ";" GLEW_FIND_COMPONENTS "${GLEW_FIND_COMPONENTS}")
  foreach(component ${GLEW_FIND_COMPONENTS})
    string(TOUPPER ${component} component)
    set(GLEW_FIND_${component} TRUE)
  endforeach()
endif()

set(_glew_HEADER_SEARCH_DIRS
    "/usr/include"
    "/usr/local/include")

set(_glew_HEADER_NAMES
    "GL/glew.h"
    "GL/glxew.h"
    "GL/wglew.h")

set(_glew_LIBRARY_SEARCH_DIRS
    "/usr/lib64"
    "/usr/lib"
    "/usr/local/lib64"
    "/usr/local/lib")

set(_glew_LIBRARY_NAMES)
if(GLEW_FIND_STATIC)
  if(GLEW_FIND_MX)
    list(APPEND _glew_LIBRARY_NAMES "glew32mxs") # win32
  endif()
  list(APPEND _glew_LIBRARY_NAMES   "glew32s")   # win32
else()
  if(GLEW_FIND_MX)
    list(APPEND _glew_LIBRARY_NAMES "glew32mx")  # win32
  endif()
  list(APPEND _glew_LIBRARY_NAMES   "glew32")    # win32
endif()
list(APPEND _glew_LIBRARY_NAMES     "glew")      # win32, linux(?)
if(GLEW_FIND_MX)
  list(APPEND _glew_LIBRARY_NAMES   "GLEWmx")    # linux
endif()
list(APPEND _glew_LIBRARY_NAMES     "GLEW")      # linux

set(GLEW_DEFINITIONS)

if(GLEW_FIND_STATIC)
  set(GLEW_DEFINITIONS "${GLEW_DEFINITIONS} -DGLEW_STATIC")
endif()

if(GLEW_FIND_MX)
  set(GLEW_DEFINITIONS "${GLEW_DEFINITIONS} -DGLEW_MX")
endif()

set(_glew_ENV_ROOT_DIR "$ENV{GLEW_ROOT_DIR}")

if(NOT GLEW_ROOT_DIR AND _glew_ENV_ROOT_DIR)
  set(GLEW_ROOT_DIR "${_glew_ENV_ROOT_DIR}")
endif()

if(GLEW_ROOT_DIR)
  set(_glew_HEADER_SEARCH_DIRS
      "${GLEW_ROOT_DIR}"
      "${GLEW_ROOT_DIR}/include"
      ${_glew_HEADER_SEARCH_DIRS})
      
  set(_glew_LIBRARY_SEARCH_DIRS
      "${GLEW_ROOT_DIR}")
       
  if(CMAKE_HOST_WIN32)
    list(APPEND _glew_LIBRARY_SEARCH_DIRS "${GLEW_ROOT_DIR}/lib")
    
    set(DBG_DIR "Debug")
    set(REL_DIR "Release")
    
    if(GLEW_FIND_MX)
      set(DBG_DIR "${DBG_DIR} MX")
      set(REL_DIR "${REL_DIR} MX")
    endif()
    
    if(MSVC AND CMAKE_CL_64)
      list(APPEND _glew_LIBRARY_SEARCH_DIRS "${GLEW_ROOT_DIR}/lib/${DBG_DIR}/x64")
      list(APPEND _glew_LIBRARY_SEARCH_DIRS "${GLEW_ROOT_DIR}/lib/${REL_DIR}/x64")
    else()
      list(APPEND _glew_LIBRARY_SEARCH_DIRS "${GLEW_ROOT_DIR}/lib/${DBG_DIR}/x86")
      list(APPEND _glew_LIBRARY_SEARCH_DIRS "${GLEW_ROOT_DIR}/lib/${REL_DIR}/x86")
    endif()
    list(APPEND _glew_LIBRARY_SEARCH_DIRS "${GLEW_ROOT_DIR}/lib/${DBG_DIR}")
    list(APPEND _glew_LIBRARY_SEARCH_DIRS "${GLEW_ROOT_DIR}/lib/${REL_DIR}")
  else()
    list(APPEND _glew_LIBRARY_SEARCH_DIRS ${_glew_LIBRARY_SEARCH_DIRS})
  endif()
endif()

find_path(GLEW_INCLUDE_DIR
          NAMES ${_glew_HEADER_NAMES}
          HINTS ${_glew_HEADER_SEARCH_DIRS}
          DOC   "The directory where '${_glew_HEADER_NAMES}' reside(s)")

find_library(GLEW_LIBRARY
             NAMES ${_glew_LIBRARY_NAMES}
             PATHS ${_glew_LIBRARY_SEARCH_DIRS}
             DOC   "The GLEW library")

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(GLEW
                                  FOUND_VAR     GLEW_FOUND
                                  REQUIRED_VARS GLEW_INCLUDE_DIR
                                                GLEW_LIBRARY)

if(GLEW_FOUND AND VERBOSE)
  message(STATUS "GLEW setup:\n"
    "   GLEW_ROOT_DIR    = ${GLEW_ROOT_DIR}\n"
    "   GLEW_INCLUDE_DIR = ${GLEW_INCLUDE_DIR}\n"
    "   GLEW_LIBRARY     = ${GLEW_LIBRARY}\n"
    "   GLEW_DEFINITIONS = ${GLEW_DEFINITIONS}"
    )
endif()
