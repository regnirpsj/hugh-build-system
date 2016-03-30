# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

if(CMAKE_HOST_WIN32)
  if(NOT TARGET target_help)    
    find_file(TARGET_LIST_SCRIPT "functions/cma_list_targets.cmake" HINTS ${CMAKE_MODULE_PATH})
    if(TARGET_LIST_SCRIPT-NOTFOUND)
      message(FATAL_ERROR "Unable to find script for custom target 'target_help'")
    else()
      add_custom_target(target_help
        ${CMAKE_COMMAND} "-DCMAKE_TARGET_LIST:LIST=${CMAKE_TARGET_LIST}" -P ${TARGET_LIST_SCRIPT}
        DEPENDS ${TARGET_LIST_SCRIPT})
    endif()
  endif()
endif()

if(VERBOSE OR SUMMARY)
  include(FeatureSummary)
  feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES)
endif()

#cma_print_variable(CMAKE_SHARED_LINKER_FLAGS)
#cma_print_variable(CMAKE_MODULE_LINKER_FLAGS)
#cma_print_variable(CMAKE_EXE_LINKER_FLAGS)
#cma_print_variable(CMAKE_MSVCIDE_RUN_PATH)

#cma_print_variable(CMAKE_TARGET_LIST)

#cma_print_variable(CMAKE_GENERATOR_TOOLSET)
#cma_print_variable(CMAKE_VS_PLATFORM_TOOLSET)
