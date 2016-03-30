# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# global

# see [http://athile.net/library/blog/?p=288]
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# project

include(CMakeAddons_DefaultOptions)
include(${PROJECT_NAME}_SetupOptions OPTIONAL RESULT_VARIABLE ${PROJECT_NAME}_FILE_SO)
if(${PROJECT_NAME}_FILE_SO)
  if(VERBOSE)
    file(RELATIVE_PATH ${PROJECT_NAME}_FILE_SO ${CMAKE_BINARY_DIR} ${${PROJECT_NAME}_FILE_SO})
    message(STATUS "Loaded project-specific options from ${${PROJECT_NAME}_FILE_SO}")
  endif()
endif()

include(CMakeAddons_DefaultPaths)
include(${PROJECT_NAME}_SetupPaths OPTIONAL RESULT_VARIABLE ${PROJECT_NAME}_FILE_SP)
if(${PROJECT_NAME}_FILE_SP)
  if(VERBOSE)
    file(RELATIVE_PATH ${PROJECT_NAME}_FILE_SP ${CMAKE_BINARY_DIR} ${${PROJECT_NAME}_FILE_SP})
    message(STATUS "Loaded project-specific paths from ${${PROJECT_NAME}_FILE_SP}")
  endif()
endif()

include(CMakeAddons_DefaultVariables)
include(${PROJECT_NAME}_SetupVariables OPTIONAL RESULT_VARIABLE ${PROJECT_NAME}_FILE_SV)
if(${PROJECT_NAME}_FILE_SV)
  if(VERBOSE)
    file(RELATIVE_PATH ${PROJECT_NAME}_FILE_SV ${CMAKE_BINARY_DIR} ${${PROJECT_NAME}_FILE_SV})
    message(STATUS "Loaded project-specific variables from ${${PROJECT_NAME}_FILE_SV}")
  endif()
endif()
