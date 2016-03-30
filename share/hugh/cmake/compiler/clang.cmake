# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

include(compiler/common-clang-gnu)

set(GLOBAL_COMPILER_FLAGS "${GLOBAL_COMPILER_FLAGS} -fdiagnostics-show-option")
set(GLOBAL_COMPILER_FLAGS "${GLOBAL_COMPILER_FLAGS} -ferror-limit=5")
set(GLOBAL_COMPILER_FLAGS "${GLOBAL_COMPILER_FLAGS} -Wno-missing-braces")

if(${CMAKE_CXX_COMPILER_VERSION} VERSION_GREATER "3.0")
  set(GLOBAL_COMPILER_FLAGS "-std=c++11 ${GLOBAL_COMPILER_FLAGS}")
else()
  set(GLOBAL_COMPILER_FLAGS "-std=c++0x ${GLOBAL_COMPILER_FLAGS}")
endif()

if("Release" STREQUAL "${CMAKE_BUILD_TYPE}")
else()
endif()

if(FALSE)
  if(${CMAKE_CXX_COMPILER_VERSION} VERSION_GREATER "3.0")
    message(STATUS "Enabling runtime address-sanitation support")
    set(GLOBAL_COMPILER_FLAGS "${GLOBAL_COMPILER_FLAGS} -fsanitize=address")
    set(GLOBAL_COMPILER_FLAGS "${GLOBAL_COMPILER_FLAGS} -fno-omit-frame-pointer")
  endif()
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${GLOBAL_COMPILER_FLAGS}")
