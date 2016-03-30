# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# .rst:
# FindFreeGLUT
# ----------------
#
# Find FreeGLUT header(s) and library
#
# Use this module by invoking find_package with the form::
#
#   find_package(FreeGLUT
#     [<version>]             # required minimum version (defaults to 2.8.0)
#     [REQUIRED]              # Fail with error if FreeGLUT is not found
#     )
#
# This module finds the root of the most recent or requested version of installed FreeGLUT headers
# and library. Results are reported in variables::
#
#   FreeGLUT_FOUND            - True if FreeGLUT was found.
#   FreeGLUT_VERSION          - Version per gluGet(GLUT_VERSION).
#   FreeGLUT_VERSION_MAJOR    - Major version per gluGet(GLUT_VERSION).
#   FreeGLUT_VERSION_MINOR    - Minor version per gluGet(GLUT_VERSION).
#   FreeGLUT_VERSION_SUBMINOR - Minor version per gluGet(GLUT_VERSION).
#   FreeGLUT_ROOT_DIR         - Installation directory.
#   FreeGLUT_INCLUDE_DIR      - Include directory for <GL/freeglut*.h>.
#   FreeGLUT_LIBRARY          - GLUT library.
#
# This module reads hints about search locations from variables::
#
#   FreeGLUT_ROOT_DIR - Preferred installation prefix
#                       this can be supplied before calling the module or as an environment
#                       variable.

set(_fg_HEADER_SEARCH_DIRS
    "/usr/include"
    "/usr/local/include")

set(_fg_HEADER_NAMES
    "GL/freeglut.h"
    "GL/freeglut_std.h"
    "GL/freeglut_ext.h")

set(_fg_LIBRARY_SEARCH_DIRS
    "/usr/lib"
    "/usr/local/lib")

set(_fg_LIBRARY_NAMES
    "freeglut_static"
    "freeglut"
    "glut")

set(_fg_ENV_ROOT_DIR "$ENV{FreeGLUT_ROOT_DIR}")

if(NOT FreeGLUT_ROOT_DIR AND _fg_ENV_ROOT_DIR)
  set(FreeGLUT_ROOT_DIR "${_fg_ENV_ROOT_DIR}")
endif()

if(FreeGLUT_ROOT_DIR)
  set(_fg_HEADER_SEARCH_DIRS
      "${FreeGLUT_ROOT_DIR}"
      "${FreeGLUT_ROOT_DIR}/include"
      ${_fg_HEADER_SEARCH_DIRS})
  set(_fg_LIBRARY_SEARCH_DIRS
      "${FreeGLUT_ROOT_DIR}"
      "${FreeGLUT_ROOT_DIR}/lib"
      "${FreeGLUT_ROOT_DIR}/bin"
       ${_fg_LIBRARY_SEARCH_DIRS})
endif()

find_path(FreeGLUT_INCLUDE_DIR
          NAMES ${_fg_HEADER_NAMES}
          HINTS ${_fg_HEADER_SEARCH_DIRS}
          DOC   "The directory where '${_fg_HEADER_NAMES}' reside(s)")

find_library(FreeGLUT_LIBRARY
             NAMES ${_fg_LIBRARY_NAMES}
             PATHS ${_fg_LIBRARY_SEARCH_DIRS}
             DOC   "The FreeGLUT library")

set(FreeGLUT_VERSION_MAJOR    "2")
set(FreeGLUT_VERSION_MINOR    "8")
set(FreeGLUT_VERSION_SUBMINOR "0")
set(FreeGLUT_VERSION          "${FreeGLUT_VERSION_MAJOR}.${FreeGLUT_VERSION_MINOR}.${FreeGLUT_VERSION_SUBMINOR}")

if(FreeGLUT_INCLUDE_DIR AND FreeGLUT_LIBRARY)
  file(WRITE ${PROJECT_BINARY_DIR}/CMakeTmp/determineFreeGLUTversion.c "
#include <GL/freeglut.h>
#include <stdio.h>
#include <stdlib.h>
int main(int argc, char* argv[]) {
  glutInit(&argc, argv);
  printf(\"%u\", glutGet(GLUT_VERSION));
  return EXIT_SUCCESS;
}
")
  try_run(_fg_VERSION_RUN_RESULT _fg_VERSION_COMPILE_RESULT
    ${PROJECT_BINARY_DIR}/CMakeTmp
    ${PROJECT_BINARY_DIR}/CMakeTmp/determineFreeGLUTversion.c
    CMAKE_FLAGS
      -DINCLUDE_DIRECTORIES:STRING=${FreeGLUT_INCLUDE_DIR}
      -DLINK_LIBRARIES:STRING=${FreeGLUT_LIBRARY}
    COMPILE_DEFINITIONS "-DFREEGLUT_STATIC -DFREEGLUT_LIB_PRAGMAS=0"
    RUN_OUTPUT_VARIABLE     _fg_VERSION_RUN_OUTPUT
    COMPILE_OUTPUT_VARIABLE _fg_VERSION_COMPILE_OUTPUT)
  
  if (NOT "${_fg_VERSION_RUN_RESULT}" AND "${_fg_VERSION_COMPILE_RESULT}")
    math(EXPR FreeGLUT_VERSION_MAJOR    "${_fg_VERSION_RUN_OUTPUT} / 10000")
    math(EXPR FreeGLUT_VERSION_MINOR    "${_fg_VERSION_RUN_OUTPUT} / 100 % 100")
    math(EXPR FreeGLUT_VERSION_SUBMINOR "${_fg_VERSION_RUN_OUTPUT} % 100")
    set(FreeGLUT_VERSION "${FreeGLUT_VERSION_MAJOR}.${FreeGLUT_VERSION_MINOR}.${FreeGLUT_VERSION_SUBMINOR}")
  endif()
endif()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(FreeGLUT
                                  FOUND_VAR     FreeGLUT_FOUND
                                  REQUIRED_VARS FreeGLUT_INCLUDE_DIR
                                                FreeGLUT_LIBRARY
                                  VERSION_VAR   FreeGLUT_VERSION)

if(FreeGLUT_FOUND AND VERBOSE)
  message(STATUS "FreeGLUT setup:\n"
    "   FreeGLUT_ROOT_DIR         = ${FreeGLUT_ROOT_DIR}\n"
    "   FreeGLUT_VERSION          = ${FreeGLUT_VERSION}\n"
    "   FreeGLUT_VERSION_MAJOR    = ${FreeGLUT_VERSION_MAJOR}\n"
    "   FreeGLUT_VERSION_MINOR    = ${FreeGLUT_VERSION_MINOR}\n"
    "   FreeGLUT_VERSION_SUBMINOR = ${FreeGLUT_VERSION_SUBMINOR}\n"
    "   FreeGLUT_INCLUDE_DIR      = ${FreeGLUT_INCLUDE_DIR}\n"
    "   FreeGLUT_LIBRARY          = ${FreeGLUT_LIBRARY}"
    )
endif()
