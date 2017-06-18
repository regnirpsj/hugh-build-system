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
  include(${CMAKE_CURRENT_LIST_DIR}/compiler/${FNAME}.cmake)
endif()

list(APPEND CMAKE_CXX_FLAGS           ${GLOBAL_COMPILER_FLAGS})
list(APPEND CMAKE_SHARED_LINKER_FLAGS ${GLOBAL_LINKER_FLAGS})

string(REPLACE ";" " " CMAKE_CXX_FLAGS           "${CMAKE_CXX_FLAGS}")
string(REPLACE ";" " " CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS}")

if(VERBOSE)
  cma_print_variable(CMAKE_CXX_FLAGS)
  cma_print_variable(CMAKE_SHARED_LINKER_FLAGS)
endif()

if(NOT VERBOSE)
  # disable "Performing Test VARIABLE" message from 'Check*Source*.cmake'
  set(CMAKE_REQUIRED_QUIET ON)
endif()
