# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

if(DEFINED ENV{HUGH_INSTALL_PREFIX})
  get_filename_component(dir $ENV{HUGH_INSTALL_PREFIX} ABSOLUTE BASE_DIR ${CMAKE_BINARY_DIR})
  set(HUGH_INSTALL_PREFIX ${dir} CACHE INTERNAL "HUGH Installation Root" FORCE)
endif()

if(NOT HUGH_INSTALL_PREFIX)
  set(HUGH_INSTALL_PREFIX ${CMAKE_SOURCE_DIR}/install CACHE INTERNAL "HUGH Installation Root" FORCE)
endif()

set(CMAKE_INSTALL_PREFIX ${HUGH_INSTALL_PREFIX} CACHE INTERNAL "" FORCE)

if(TRUE OR VERBOSE)
  message(STATUS "CMAKE_INSTALL_PREFIX set to '" ${CMAKE_INSTALL_PREFIX} "'")
endif()
