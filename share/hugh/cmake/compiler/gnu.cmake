# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

set(GLOBAL_COMPILER_FLAGS)
set(GLOBAL_LINKER_FLAGS)

if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 4.6)
  list(APPEND GLOBAL_COMPILER_FLAGS -std=c++11)
else()
  list(APPEND GLOBAL_COMPILER_FLAGS -std=c++0x)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/common-clang-gnu.cmake)

list(APPEND GLOBAL_COMPILER_FLAGS -Wno-unknown-pragmas)
list(APPEND GLOBAL_COMPILER_FLAGS -fdiagnostics-show-location=once)
list(APPEND GLOBAL_COMPILER_FLAGS -fdiagnostics-show-option)

if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 4.8)
  list(APPEND GLOBAL_COMPILER_FLAGS -fdiagnostics-color=auto)
  list(APPEND GLOBAL_COMPILER_FLAGS -fmax-errors=5)
endif()

if("Release" STREQUAL "${CMAKE_BUILD_TYPE}")
else()
endif()

if(FALSE)
  if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 4.8)
    message(STATUS "Enabling runtime address-sanitation support")
    list(APPEND GLOBAL_COMPILER_FLAGS -fsanitize=address)
    list(APPEND GLOBAL_COMPILER_FLAGS -fno-omit-frame-pointer)
  endif()
endif()

if(${PROJECT_NAME}_GLIBCXX_PARALLEL)
  list(APPEND GLOBAL_COMPILER_FLAGS -fopenmp)
  add_definitions(-D_GLIBCXX_PARALLEL)
endif()
