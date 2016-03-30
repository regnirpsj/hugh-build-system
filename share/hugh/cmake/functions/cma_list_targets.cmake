# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

if(FALSE)
  message(STATUS "CMAKE_ARGC = ${CMAKE_ARGC}")
  math(EXPR argc "${CMAKE_ARGC} - 1")
  foreach(i RANGE 0 ${argc})
    message(STATUS "CMAKE_ARGV${i} = ${CMAKE_ARGV${i}}")
  endforeach()
endif()

message(STATUS "Available targets:")

foreach(t ${CMAKE_TARGET_LIST})
  #if(TARGET ${t})
    message(STATUS "${t}")
  #else()
  #  message(STATUS "Not a target: ${t}")
  #endif()
endforeach()
