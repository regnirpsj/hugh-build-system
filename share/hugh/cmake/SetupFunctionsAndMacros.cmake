# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

set(CMAKE_TARGET_LIST "target_help" CACHE INTERNAL "Global list of targets" FORCE)
#message(STATUS "initial setup: CMAKE_TARGET_LIST = ${CMAKE_TARGET_LIST}")

include(${CMAKE_CURRENT_LIST_DIR}/functions/cma_fxc_compile.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/functions/cma_setup_application.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/functions/cma_setup_export.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/functions/cma_setup_file_target.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/functions/cma_setup_library.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/functions/cma_setup_test.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/functions/cma_utilities.cmake)
