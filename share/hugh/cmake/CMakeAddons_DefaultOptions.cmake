# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

if(VERBOSE)
  message(STATUS "Setting default options prefixed with '${PROJECT_NAME}_'")
endif()

# doxygen docs
option(${PROJECT_NAME}_DOC_DEV   "Enable generation of developer documentation"      OFF)
option(${PROJECT_NAME}_DOC_USR   "Enable generation of user documentation"           OFF)

# unit testing
option(${PROJECT_NAME}_BLD_UTEST "Enable unit-test building"                          ON)
option(${PROJECT_NAME}_RUN_CTEST "Enable unit-test execution using CTest"             ON)
option(${PROJECT_NAME}_RUN_UTEST "Enable unit-test execution using the build system" OFF)

# coverage testing
option(${PROJECT_NAME}_COVERAGE  "Enable support for coverage testing"               OFF)

# profiling
option(${PROJECT_NAME}_PROFILE   "Enable support for profiling support"              OFF)

# runt-time tracing
option(${PROJECT_NAME}_TRACE_ALL "Enable support for run-time tracing"               OFF)
