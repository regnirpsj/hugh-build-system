# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

if(DEFINED ENV{HUGH_INSTALL_PREFIX})
  set(HUGH_INSTALL_PREFIX $ENV{HUGH_INSTALL_PREFIX} CACHE INTERNAL "HUGH Installation Root")
endif()

if(NOT HUGH_INSTALL_PREFIX)
  set(HUGH_INSTALL_PREFIX ${CMAKE_SOURCE_DIR}/install CACHE INTERNAL "HUGH Installation Root")
endif()

set(CMAKE_INSTALL_PREFIX ${HUGH_INSTALL_PREFIX})

if(TRUE OR VERBOSE)
  message(STATUS "CMAKE_INSTALL_PREFIX set to '" ${CMAKE_INSTALL_PREFIX} "'")
endif()
