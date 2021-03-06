# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# .rst
# cma_add_target_to_list(TARGET TARGET_LIST)
#   TARGET      -
#   TARGET_LIST -
#
function(cma_add_target_to_list TARGET TARGET_LIST)
  set(${TARGET_LIST} "${${TARGET_LIST}};${TARGET}" CACHE INTERNAL "Global list of targets")
endfunction()

# .rst
# cma_num_processors(NUM_CPUS)
#
function(cma_num_processors NUM_CPUS)
  include(ProcessorCount)
  processorcount(NUM_CPUS)
  if(NUM_CPUS EQUAL 0)
    set(NUM_CPUS 1)
  endif()
endfunction()

# .rst
# cma_print_current_directory()
#
function(cma_print_current_directory)
  if(VERBOSE OR CMA_TRACE)
    message(STATUS "Setting up: ${CMAKE_CURRENT_SOURCE_DIR}")
  endif()
endfunction()

# .rst
# cma_print_variable(VARIABLE [MODE <mode>] [PREFIX <string>)::
#   VARIABLE - variable name, its name and content will be printed
#   MODE     - [STATUS|WARNING|AUTHOR_WARNING|SEND_ERROR|FATAL_ERROR|DEPRECATION]
#   PREFIX   - Prefix message with a string; if set ": " will be inserted between the prefix string
#              and the variable display
#
function(cma_print_variable VARIABLE)
  include(CMakeParseArguments)

  set(OARGS)
  set(SARGS MODE PREFIX)
  set(MARGS)
  cmake_parse_arguments(CMA_PRINT "${OARGS}" "${SARGS}" "${MARGS}" ${ARGN})

  if(NOT CMA_PRINT_MODE)
    set(CMA_PRINT_MODE STATUS)
  endif()

  if(CMA_PRINT_PREFIX)
    set(CMA_PRINT_PREFIX "${CMA_PRINT_PREFIX}: ")
  endif()

  message(${CMA_PRINT_MODE} "${CMA_PRINT_PREFIX}${ARGV0} = ${${ARGV0}}")
endfunction()

# .rst
#
function(cma_add_winrt_props NAME)
  set_property(TARGET ${NAME} PROPERTY VS_WINRT_COMPONENT TRUE)

  # VS_DEPLOYMENT_CONTENT
  # VS_DEPLOYMENT_LOCATION
  
  add_definitions(-ZW)
  add_definitions(-EHsc)
endfunction()

# .rst
# cma_fetch_url(URL FILE)::
#   URL    - url to fetch
#   FILE   - file to safe to
#   ALWAYS - always fetch, do not check if already available
#
function(cma_fetch_url URL FILE)
  include(CMakeParseArguments)

  set(OARGS ALWAYS)
  set(SARGS)
  set(MARGS)
  cmake_parse_arguments(CMA_FETCH_URL "${OARGS}" "${SARGS}" "${MARGS}" ${ARGN})

  set(SRC ${URL})
  set(DST ${FILE})

  if(CMA_FETCH_URL_ALWAYS OR NOT EXISTS ${DST})
    if(VERBOSE)
      message(STATUS "Downloding '${SRC}' to '${DST}'")
    else()
      message(STATUS "Downloding '${SRC}'")
    endif()
    file(DOWNLOAD ${SRC} ${DST} STATUS RESULT)
    list(GET RESULT 0 RESULT0)
    if(NOT 0 EQUAL ${RESULT0})
      list(GET RESULT 1 RESULT1) 
      message(FATAL_ERROR "Download failed: ${RESULT1} (${RESULT0})")
      file(REMOVE ${DST})
    else()
      if(VERBOSE)
	message(STATUS "Downloaded '${SRC}' to '${DST}'")
      endif()
    endif()
  endif()
endfunction()
