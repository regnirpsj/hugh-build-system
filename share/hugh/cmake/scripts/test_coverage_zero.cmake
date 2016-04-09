# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

separate_arguments(LCOV      UNIX_COMMAND "${CMAKE_ARGV3}")
separate_arguments(LCOV_ARGS UNIX_COMMAND "${CMAKE_ARGV4}")

if(VERBOSE)
  message(STATUS "test_coverage_zero.cmake:\n"
    "LCOV      = ${LCOV}\n"
    "LCOV_ARGS = ${LCOV_ARGS}")
endif()

execute_process(COMMAND ${LCOV} ${LCOV_ARGS} --zerocounters --directory .)
