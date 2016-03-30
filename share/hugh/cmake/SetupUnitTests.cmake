# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

if(${PROJECT_NAME}_BLD_UTEST)
  if(VERBOSE)
    message(STATUS "Enabling unit-test building")
  endif()

  if(${PROJECT_NAME}_RUN_CTEST)
    if(VERBOSE)
      message(STATUS "Enabling CTest unit-test execution")
    endif()
    enable_testing()
    set(FNAME "CTestConfig.cmake.in")
    if(NOT EXISTS "cmake/${FNAME}")
      set(FNAME "${CMAKE_CURRENT_LIST_DIR}/${FNAME}")
    else()
      set(FNAME "cmake/${FNAME}")
    endif()
    configure_file(${FNAME} ${PROJECT_BINARY_DIR}/CTestConfig.cmake @ONLY)
  elseif(${PROJECT_NAME}_RUN_UTEST)
    if(VERBOSE)
      message(STATUS "Enabling unit-test execution")
    endif()
  else()
    if(VERBOSE)
      message(STATUS "Disabling unit-test execution")
    endif()
  endif()  

  if(NOT TARGET test_libs)
    add_custom_target(test_libs)
  endif()

  if(NOT TARGET test_all)
    add_custom_target(test_all)
    add_dependencies(test_all test_libs)
  endif()
else()
  if(VERBOSE)
    message(STATUS "Disabling unit-test building")
  endif()
endif()

if(${PROJECT_NAME}_BLD_UTEST AND ${PROJECT_NAME}_COVERAGE)
  if(NOT LCOV)
    set(LCOV $ENV{LCOV})
    if(NOT LCOV)
      find_program(LCOV lcov DOC "GCOV front-end")
    endif()
    if(NOT LCOV)
      message(SEND_ERROR "Error: unable to find GCOV front-end (lcov)")
    endif()
  endif()
  
  if(LCOV)
    add_custom_target(test_coverage_zero)
    add_custom_target(test_coverage_collect)
    add_custom_target(test_coverage)

    add_dependencies(test_coverage         test_coverage_zero test_all test_coverage_collect)
    add_dependencies(test_all              test_coverage_zero)
    add_dependencies(test_coverage_collect test_all)

    set(LCOV_ARGS $ENV{LCOV_ARGS})
    
    if(NOT VERBOSE)
      list(APPEND LCOV_ARGS "--quiet")
    endif()
    
    #list(APPEND LCOV_ARGS "--debug")
    #list(APPEND LCOV_ARGS "--rc lcov_branch_coverage=1")
    #list(APPEND LCOV_ARGS "--rc lcov_function_coverage=1")

    if(VERBOSE)
      message(STATUS "Found GCOV front-end: ${LCOV} ${LCOV_ARGS}")
    endif()
    
    # see [https://cmake.org/pipermail/cmake/2005-October/007343.html]
    separate_arguments(LCOV_ARGS)
    separate_arguments(${PROJECT_NAME}_COVERAGE_EXCLUDE)
    separate_arguments(${PROJECT_NAME}_COVERAGE_INCLUDE)

    set(CAPTURE_FNAME "coverage.info")

    #add_custom_command(TARGET test_coverage_zero POST_BUILD
    #  COMMAND ${LCOV} ${LCOV_ARGS} --zerocounters --directory .
    #  COMMAND ${CMAKE_COMMAND} -E remove ${CAPTURE_FNAME}
    #  COMMENT "Cleaning coverage data"
    #  WORKING_DIRECTORY ${CMAKE_BINARY_DIR})

    list(APPEND LCOV_ARGS "--output-file ${CAPTURE_FNAME}")
    separate_arguments(LCOV_ARGS)

    add_custom_command(TARGET test_coverage_collect POST_BUILD
      COMMAND ${LCOV}   ${LCOV_ARGS} --directory . --capture
      COMMAND ${LCOV}   ${LCOV_ARGS} --extract ${CAPTURE_FNAME} ${${PROJECT_NAME}_COVERAGE_INCLUDE}
      COMMAND ${LCOV}   ${LCOV_ARGS} --remove ${CAPTURE_FNAME} ${${PROJECT_NAME}_COVERAGE_EXCLUDE}
      COMMAND ${LCOV}   ${LCOV_ARGS} --list ${CAPTURE_FNAME}
      BYPRODUCTS        ${CAPTURE_FNAME}
      COMMENT "Collecting coverage data"
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
  endif()
endif()
