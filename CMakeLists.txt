# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

cmake_minimum_required(VERSION 3.0 FATAL_ERROR)

include(${CMAKE_SOURCE_DIR}/share/hugh/cmake/SetupHunter.cmake)

project(HUGH_BUILD_SYSTEM VERSION 0.1.0 LANGUAGES NONE)

add_subdirectory(dummy)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/share/hugh/cmake)

include(CheckOutOfTreeBuild)
include(SetupInitialCache)
include(SetupBuildType)
include(SetupInstallPrefix)
include(SetupPlatformAndArchitecture)
include(SetupFunctionsAndMacros)

cma_print_current_directory()

#include(SetupCompilerDefaults)
include(SetupProjectDefaults)
#include(SetupUnitTests)

add_subdirectory(share)

include(ShowConfigSummary)
# keep last
include(SetupPackaging)
