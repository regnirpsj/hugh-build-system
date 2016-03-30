# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

set(CMAKE_LIBRARY_TYPE "SHARED")

set(GLOBAL_COMPILER_FLAGS)
set(GLOBAL_COMPILER_FLAGS "${GLOBAL_COMPILER_FLAGS} -pipe")
set(GLOBAL_COMPILER_FLAGS "${GLOBAL_COMPILER_FLAGS} -Wall -Wextra")
set(GLOBAL_COMPILER_FLAGS "${GLOBAL_COMPILER_FLAGS} -Wpointer-arith")
set(GLOBAL_COMPILER_FLAGS "${GLOBAL_COMPILER_FLAGS} -fmessage-length=0")

if(${PROJECT_NAME}_COVERAGE)
  set(GLOBAL_COMPILER_FLAGS     "${GLOBAL_COMPILER_FLAGS} --coverage")
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} --coverage")
endif()

if(${PROJECT_NAME}_PROFILE)
  set(GLOBAL_COMPILER_FLAGS     "${GLOBAL_COMPILER_FLAGS} -pg")
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -pg")
endif()

# [http://stackoverflow.com/questions/17150075]
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--no-as-needed")

# linker flags
if("Release" STREQUAL "${CMAKE_BUILD_TYPE}")
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-O1")
endif()

set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--demangle")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--fatal-warnings")
