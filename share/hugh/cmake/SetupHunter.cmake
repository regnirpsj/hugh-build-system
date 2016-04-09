# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

include(${CMAKE_CURRENT_LIST_DIR}/HunterGate.cmake)

option(HUNTER_ENABLED "Enable Hunter package manager" OFF)

if(VERBOSE)
  set(HUNTER_STATUS_PRINT ON)
endif()

if(DEBUG)
  set(HUNTER_STATUS_DEBUG)
endif()

HunterGate(URL  "https://github.com/ruslo/hunter/archive/v0.14.1.tar.gz"
           SHA1 "d073cc04d59a01782385799568afce78066a8cec"
	   LOCAL)
