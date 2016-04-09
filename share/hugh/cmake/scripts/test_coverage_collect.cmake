# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

if(DEBUG)
  foreach(i RANGE ${CMAKE_ARGC})
    message(STATUS "test_coverage_collect.cmake: CMAKE_ARGV${i} = ${CMAKE_ARGV${i}}")
  endforeach()
endif()

separate_arguments(LCOV             UNIX_COMMAND "${CMAKE_ARGV3}")
separate_arguments(LCOV_ARGS        UNIX_COMMAND "${CMAKE_ARGV4}")
separate_arguments(CAPTURE_FNAME    UNIX_COMMAND "${CMAKE_ARGV5}")
separate_arguments(COVERAGE_INCLUDE UNIX_COMMAND "${CMAKE_ARGV6}")
separate_arguments(COVERAGE_EXCLUDE UNIX_COMMAND "${CMAKE_ARGV7}")

if(VERBOSE)
  message(STATUS "test_coverage_collect.cmake:\n"
    "LCOV             = ${LCOV}\n"
    "LCOV_ARGS        = ${LCOV_ARGS}\n"
    "CAPTURE_FNAME    = ${CAPTURE_FNAME}\n"
    "COVERAGE_INCLUDE = ${COVERAGE_INCLUDE}\n"
    "COVERAGE_EXCLUDE = ${COVERAGE_EXCLUDE}")
endif()

execute_process(COMMAND ${LCOV} ${LCOV_ARGS} --capture --directory .
                RESULT_VARIABLE RESULT
		ERROR_QUIET)

if(NOT RESULT)
  execute_process(COMMAND ${LCOV} ${LCOV_ARGS} --extract ${CAPTURE_FNAME} ${COVERAGE_INCLUDE})
  execute_process(COMMAND ${LCOV} ${LCOV_ARGS} --remove ${CAPTURE_FNAME} ${COVERAGE_EXCLUDE})
  execute_process(COMMAND ${LCOV} ${LCOV_ARGS} --list ${CAPTURE_FNAME})
  execute_process(COMMAND ${CMAKE_COMMAND} -E echo "")
endif()
