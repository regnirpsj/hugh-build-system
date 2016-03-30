# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# initial cache to make life easier on window$ (if we ever get there ;)
if(NOT ${PROJECT_NAME}INITCACHELOADED AND EXISTS ${CMAKE_SOURCE_DIR}/CMakeCacheInitial.txt)
  include(${CMAKE_SOURCE_DIR}/CMakeCacheInitial.txt)
  set(${PROJECT_NAME}INITCACHELOADED TRUE CACHE INTERNAL "")
endif()

if(VERBOSE)
  if(${PROJECT_NAME}INITCACHELOADED)
    message(STATUS "Initial cache set up.")
  endif()
endif()
