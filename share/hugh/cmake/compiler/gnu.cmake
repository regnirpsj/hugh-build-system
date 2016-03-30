# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

include(compiler/common-clang-gnu)

set(GLOBAL_COMPILER_FLAGS "${GLOBAL_COMPILER_FLAGS} -Wno-unknown-pragmas")
set(GLOBAL_COMPILER_FLAGS "${GLOBAL_COMPILER_FLAGS} -fdiagnostics-show-location=once")
set(GLOBAL_COMPILER_FLAGS "${GLOBAL_COMPILER_FLAGS} -fdiagnostics-show-option")

if(${CMAKE_CXX_COMPILER_VERSION} VERSION_GREATER "4.6")
  set(GLOBAL_COMPILER_FLAGS "-std=c++11 ${GLOBAL_COMPILER_FLAGS}")
else()
  set(GLOBAL_COMPILER_FLAGS "-std=c++0x ${GLOBAL_COMPILER_FLAGS}")
endif()

if(${CMAKE_CXX_COMPILER_VERSION} VERSION_GREATER "4.8")
  set(GLOBAL_COMPILER_FLAGS "${GLOBAL_COMPILER_FLAGS} -fdiagnostics-color=auto")
  set(GLOBAL_COMPILER_FLAGS "${GLOBAL_COMPILER_FLAGS} -fmax-errors=5")
endif()

if("Release" STREQUAL "${CMAKE_BUILD_TYPE}")
else()
endif()

if(FALSE)
  if(${CMAKE_CXX_COMPILER_VERSION} VERSION_GREATER "4.8")
    message(STATUS "Enabling runtime address-sanitation support")
    set(GLOBAL_COMPILER_FLAGS "${GLOBAL_COMPILER_FLAGS} -fsanitize=address")
    set(GLOBAL_COMPILER_FLAGS "${GLOBAL_COMPILER_FLAGS} -fno-omit-frame-pointer")
  endif()
endif()

if(${PROJECT_NAME}_GLIBCXX_PARALLEL)
  set(GLOBAL_COMPILER_FLAGS "${GLOBAL_COMPILER_FLAGS} -fopenmp")
  add_definitions("-D_GLIBCXX_PARALLEL")
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${GLOBAL_COMPILER_FLAGS}")
