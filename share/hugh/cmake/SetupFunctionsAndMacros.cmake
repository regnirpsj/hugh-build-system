# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

set(CMAKE_TARGET_LIST "target_help" CACHE INTERNAL "Global list of targets" FORCE)
#message(STATUS "initial setup: CMAKE_TARGET_LIST = ${CMAKE_TARGET_LIST}")

include(functions/cma_fxc_compile)
include(functions/cma_setup_application)
include(functions/cma_setup_export)
include(functions/cma_setup_file_target)
include(functions/cma_setup_library)
include(functions/cma_setup_test)
include(functions/cma_utilities)
