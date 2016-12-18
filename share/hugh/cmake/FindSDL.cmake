# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# .rst:
# FindSDL
# ----------------
#
# Find SDL header(s) and library
#
# Use this module by invoking find_package with the form::
#
#   find_package(SDL
#     [<version>]             # required minimum version (defaults to 2.8.0)
#     [REQUIRED]              # Fail with error if SDL is not found
#     )
#
# This module finds the root of the most recent or requested version of installed SDL headers
# and library. Results are reported in variables::
#
#   SDL_FOUND            - True if SDL was found.
#   SDL_VERSION          - Version per gluGet(GLUT_VERSION).
#   SDL_VERSION_MAJOR    - Major version per gluGet(GLUT_VERSION).
#   SDL_VERSION_MINOR    - Minor version per gluGet(GLUT_VERSION).
#   SDL_VERSION_SUBMINOR - Minor version per gluGet(GLUT_VERSION).
#   SDL_ROOT_DIR         - Installation directory.
#   SDL_INCLUDE_DIR      - Include directory for <SDL.h>.
#   SDL_LIBRARY          - SDL library.
#
# This module reads hints about search locations from variables::
#
#   SDL_ROOT_DIR - Preferred installation prefix
#                       this can be supplied before calling the module or as an environment
#                       variable.

set(_sdl_HEADER_SEARCH_DIRS
    "/usr/include"
    "/usr/local/include"
    "/usr/include/SDL2"
    "/usr/local/include/SDL2")

set(_sdl_HEADER_NAMES
    "SDL.h")

set(_sdl_LIBRARY_SEARCH_DIRS
    "/usr/lib"
    "/usr/local/lib")

set(_sdl_LIBRARY_NAMES
    "SDL2")

set(_sdl_ENV_ROOT_DIR "$ENV{SDL_ROOT_DIR}")

if(NOT SDL_ROOT_DIR AND _sdl_ENV_ROOT_DIR)
  set(SDL_ROOT_DIR "${_sdl_ENV_ROOT_DIR}")
endif()

if(SDL_ROOT_DIR)
  set(_sdl_HEADER_SEARCH_DIRS
      ${SDL_ROOT_DIR}
      ${SDL_ROOT_DIR}/include
      ${_sdl_HEADER_SEARCH_DIRS})
      
  set(_sdl_LIBRARY_SEARCH_DIRS
      ${SDL_ROOT_DIR})
       
  if(CMAKE_HOST_WIN32)
    list(APPEND _sdl_LIBRARY_SEARCH_DIRS ${SDL_ROOT_DIR}/lib)
    
    if(MSVC AND CMAKE_CL_64)
      list(APPEND _sdl_LIBRARY_SEARCH_DIRS ${SDL_ROOT_DIR}/lib/x64)
    else()
      list(APPEND _sdl_LIBRARY_SEARCH_DIRS ${SDL_ROOT_DIR}/lib/x86)
    endif()
  else()
    list(APPEND _sdl_LIBRARY_SEARCH_DIRS ${_sdl_LIBRARY_SEARCH_DIRS})
  endif()
endif()

find_path(SDL_INCLUDE_DIR
          NAMES ${_sdl_HEADER_NAMES}
          HINTS ${_sdl_HEADER_SEARCH_DIRS}
          DOC   "The directory where '${_sdl_HEADER_NAMES}' reside(s)")

find_library(SDL_LIBRARY
             NAMES ${_sdl_LIBRARY_NAMES}
             PATHS ${_sdl_LIBRARY_SEARCH_DIRS}
             DOC   "The SDL library")

set(SDL_VERSION_MAJOR    "0")
set(SDL_VERSION_MINOR    "0")
set(SDL_VERSION_SUBMINOR "0")
set(SDL_VERSION          "${SDL_VERSION_MAJOR}.${SDL_VERSION_MINOR}.${SDL_VERSION_SUBMINOR}")

if(SDL_INCLUDE_DIR AND SDL_LIBRARY)
  file(WRITE ${PROJECT_BINARY_DIR}/CMakeTmp/determineSDLversion.c "
#include <SDL_version.h>
#include <stdio.h>
#include <stdlib.h>
int main(int argc, char* argv[]) {
  printf(\"%u.%u.%u\", SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_PATCHLEVEL);
  return EXIT_SUCCESS;
}
")
  try_run(_sdl_VERSION_RUN_RESULT _sdl_VERSION_COMPILE_RESULT
    ${PROJECT_BINARY_DIR}/CMakeTmp
    ${PROJECT_BINARY_DIR}/CMakeTmp/determineSDLversion.c
    CMAKE_FLAGS
      -DINCLUDE_DIRECTORIES:STRING=${SDL_INCLUDE_DIR}
      -DLINK_LIBRARIES:STRING=${SDL_LIBRARY}
    RUN_OUTPUT_VARIABLE     _sdl_VERSION_RUN_OUTPUT
    COMPILE_OUTPUT_VARIABLE _sdl_VERSION_COMPILE_OUTPUT)
  
  if (NOT "${_sdl_VERSION_RUN_RESULT}" AND "${_sdl_VERSION_COMPILE_RESULT}")
    string(REPLACE "." ";" VERSION_LIST ${_sdl_VERSION_RUN_OUTPUT})
    list(GET VERSION_LIST 0 SDL_VERSION_MAJOR)
    list(GET VERSION_LIST 1 SDL_VERSION_MINOR)
    list(GET VERSION_LIST 2 SDL_VERSION_SUBMINOR)
    set(SDL_VERSION "${SDL_VERSION_MAJOR}.${SDL_VERSION_MINOR}.${SDL_VERSION_SUBMINOR}")
  endif()
endif()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(SDL
                                  FOUND_VAR     SDL_FOUND
                                  REQUIRED_VARS SDL_INCLUDE_DIR
                                                SDL_LIBRARY
                                  VERSION_VAR   SDL_VERSION)

if(SDL_FOUND AND VERBOSE)
  message(STATUS "SDL setup:\n"
    "   SDL_ROOT_DIR         = ${SDL_ROOT_DIR}\n"
    "   SDL_VERSION          = ${SDL_VERSION}\n"
    "   SDL_VERSION_MAJOR    = ${SDL_VERSION_MAJOR}\n"
    "   SDL_VERSION_MINOR    = ${SDL_VERSION_MINOR}\n"
    "   SDL_VERSION_SUBMINOR = ${SDL_VERSION_SUBMINOR}\n"
    "   SDL_INCLUDE_DIR      = ${SDL_INCLUDE_DIR}\n"
    "   SDL_LIBRARY          = ${SDL_LIBRARY}"
    )
endif()
