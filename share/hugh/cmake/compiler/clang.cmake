# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016-2017 University of Hull                                                       #
#                                                                                                  #
####################################################################################################

set(GLOBAL_COMPILER_FLAGS)
set(GLOBAL_LINKER_FLAGS)

if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 3.8)
  list(APPEND GLOBAL_COMPILER_FLAGS -std=c++14)
elseif(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 3.0)
  list(APPEND GLOBAL_COMPILER_FLAGS -std=c++11)
else()
  list(APPEND GLOBAL_COMPILER_FLAGS -std=c++0x)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/common-clang-gnu.cmake)

list(APPEND GLOBAL_COMPILER_FLAGS -fdiagnostics-show-option)
list(APPEND GLOBAL_COMPILER_FLAGS -ferror-limit=5)
list(APPEND GLOBAL_COMPILER_FLAGS -Wno-missing-braces)
list(APPEND GLOBAL_COMPILER_FLAGS -ffp-contract=fast)

if("Release" STREQUAL "${CMAKE_BUILD_TYPE}")
else()
endif()

if(FALSE)
  if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 3.0)
    message(STATUS "Enabling runtime address-sanitation support")
    list(APPEND GLOBAL_COMPILER_FLAGS -fsanitize=address)
    list(APPEND GLOBAL_COMPILER_FLAGS -fno-omit-frame-pointer)
  endif()
endif()

