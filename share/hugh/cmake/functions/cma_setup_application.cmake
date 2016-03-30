# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# .rst:
# cma_setup_application(NAME SOURCES .. [DEPENDENCIES ..] [PREFIX <string>] [WINRT] [DEBUG])
#   NAME         -
#   SOURCES      -
#   DEPENDENCIES -
#   PREFIX       -
#   WINRT        -
#   DEBUG        -
#
function(cma_setup_application APP_NAME)
  include(CMakeParseArguments)
  include(functions/cma_utilities)
  
  set(OARGS WINRT DEBUG)
  set(SARGS PREFIX)
  set(MARGS SOURCES DEPENDENCIES)
  cmake_parse_arguments(APP "${OARGS}" "${SARGS}" "${MARGS}" ${ARGN})
  
  if(NOT APP_SOURCES)
    message(SEND_ERROR "Error: cma_setup_application() called without any source files")
    return()
  endif()

  file(GLOB_RECURSE HDRS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "${CMAKE_CURRENT_SOURCE_DIR}/*.hpp")
  list(APPEND APP_SOURCES ${INLS})
  file(GLOB_RECURSE INLS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "${CMAKE_CURRENT_SOURCE_DIR}/*.inl")
  list(APPEND APP_SOURCES ${HDRS})
  
  if(NOT APP_PREFIX)
    set(APP_PREFIX "app_")
  endif()

  set(APP_NAME "${APP_PREFIX}${APP_NAME}")

  if(APP_DEBUG OR VERBOSE)
    message(STATUS "cma_setup_application(${NAME};${ARGN}) variable setup:\n"
      "   APP_NAME         = ${APP_NAME}\n"
      "   APP_SOURCES      = ${APP_SOURCES}\n"
      "   APP_DEPENDENCIES = ${APP_DEPENDENCIES}"
      )
  endif()
  
  add_executable(${APP_NAME} ${APP_SOURCES})

  set_property(TARGET ${APP_NAME} PROPERTY FOLDER "Applications")

  if(APP_WINRT)
    cma_add_winrt_props(${APP_NAME})
  endif()

  source_group(Source          REGULAR_EXPRESSION ".+\\.cpp")
  source_group(Header\\Private REGULAR_EXPRESSION ".+\\.hpp")
  
  target_link_libraries(${APP_NAME} ${APP_DEPENDENCIES})

  install(TARGETS ${APP_NAME}
          RUNTIME
          DESTINATION ${${PROJECT_NAME}_RUNTIME_DIRECTORY}
	  COMPONENT   ${${PROJECT_NAME}_APP_COMPONENT_NAME})

  cma_add_target_to_list(${APP_NAME} CMAKE_TARGET_LIST)
endfunction()
