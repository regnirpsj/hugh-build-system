# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

if(VERBOSE)
  message(STATUS "Setting default install-component names")
endif()

set(${PROJECT_NAME}_APP_COMPONENT_NAME "app")
set(${PROJECT_NAME}_LIB_COMPONENT_NAME "lib")
set(${PROJECT_NAME}_HDR_COMPONENT_NAME "hdr")
set(${PROJECT_NAME}_DOC_COMPONENT_NAME "doc")

# Boost
if(VERBOSE)
  set(Boost_FIND_QUIETLY OFF)
else()
  set(Boost_FIND_QUIETLY ON)
endif()

# Cmake 'install'
if(VERBOSE)
  set(CMAKE_INSTALL_MESSAGE ALWAYS)
else()
  set(CMAKE_INSTALL_MESSAGE LAZY)
endif()

set(${PROJECT_NAME}_COVERAGE_EXCLUDE)
list(APPEND ${PROJECT_NAME}_COVERAGE_EXCLUDE "'test/*'")
list(APPEND ${PROJECT_NAME}_COVERAGE_EXCLUDE "'install/*'")

set(${PROJECT_NAME}_COVERAGE_INCLUDE)
list(APPEND ${PROJECT_NAME}_COVERAGE_INCLUDE "'${CMAKE_SOURCE_DIR}/*'")
