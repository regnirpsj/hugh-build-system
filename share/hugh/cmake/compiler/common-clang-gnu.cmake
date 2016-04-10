# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

set(CMAKE_LIBRARY_TYPE "SHARED")

list(APPEND GLOBAL_COMPILER_FLAGS -pipe)
list(APPEND GLOBAL_COMPILER_FLAGS -Wall -Wextra)
list(APPEND GLOBAL_COMPILER_FLAGS -Wpointer-arith)
list(APPEND GLOBAL_COMPILER_FLAGS -fmessage-length=0)

if(${PROJECT_NAME}_COVERAGE)
  list(APPEND GLOBAL_COMPILER_FLAGS --coverage)
  list(APPEND GLOBAL_LINKER_FLAGS --coverage)
endif()

if(${PROJECT_NAME}_PROFILE)
  set(GLOBAL_COMPILER_FLAGS -pg)
  list(APPEND GLOBAL_LINKER_FLAGS -pg)
endif()

# [http://stackoverflow.com/questions/17150075]
list(APPEND GLOBAL_LINKER_FLAGS -Wl,--no-as-needed)

# linker flags
if("Release" STREQUAL "${CMAKE_BUILD_TYPE}")
  list(APPEND GLOBAL_LINKER_FLAGS -Wl,-O1)
endif()

list(APPEND GLOBAL_LINKER_FLAGS -Wl,--demangle)
list(APPEND GLOBAL_LINKER_FLAGS -Wl,--fatal-warnings)
