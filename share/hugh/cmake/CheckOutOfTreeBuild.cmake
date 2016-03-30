# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# disallow in-source build
if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
  message(FATAL_ERROR [=[
    \n
    Project ${PROECT_NAME} requires an out-of-source-tree build.
    Please create a separate build directory and run CMake there.
    ]=])
endif()
