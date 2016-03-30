# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

set(CMAKE_LIBRARY_TYPE "LIBRARY_TYPE_UNDEFINED")

message(STATUS "Setting defaults for: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")

include(${PROJECT_NAME}_SetupCompiler OPTIONAL RESULT_VARIABLE ${PROJECT_NAME}_FILE_SC)

if(${PROJECT_NAME}_FILE_SC)
  if(VERBOSE)
    file(RELATIVE_PATH ${PROJECT_NAME}_FILE_SC ${CMAKE_BINARY_DIR} ${${PROJECT_NAME}_FILE_SC})
    message(STATUS "Loaded project-specific options from ${${PROJECT_NAME}_FILE_SC}")
  endif()
else()
  string(TOLOWER ${CMAKE_CXX_COMPILER_ID} FNAME)
  include(compiler/${FNAME})
endif()
