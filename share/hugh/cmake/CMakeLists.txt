# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

cma_print_current_directory()

set(SRC)
list(APPEND SRC CMakeAddons_DefaultOptions.cmake)
list(APPEND SRC CMakeAddons_DefaultPaths.cmake)
list(APPEND SRC CMakeAddons_DefaultVariables.cmake)
list(APPEND SRC CMakeAddons_SetupOptions.cmake)
list(APPEND SRC CMakeAddons_SetupPaths.cmake)
list(APPEND SRC CMakeAddons_SetupVariables.cmake)
list(APPEND SRC CTestConfig.cmake.in)
list(APPEND SRC CheckOutOfTreeBuild.cmake)
list(APPEND SRC FindAntTweakBar.cmake)
list(APPEND SRC FindFreeGLUT.cmake)
list(APPEND SRC FindGLEW.cmake)
list(APPEND SRC FindGLI.cmake)
list(APPEND SRC FindGLM.cmake)
list(APPEND SRC FindHUGH.cmake)
list(APPEND SRC FindOGLplus.cmake)
list(APPEND SRC FindVulkan.cmake)
list(APPEND SRC FindWindowsSDK.cmake)
list(APPEND SRC FindXSDCXX.cmake)
list(APPEND SRC HunterGate.cmake)
list(APPEND SRC SetupBuildType.cmake)
list(APPEND SRC SetupCompilerDefaults.cmake)
list(APPEND SRC SetupDocumentation.cmake)
list(APPEND SRC SetupFunctionsAndMacros.cmake)
list(APPEND SRC SetupHunter.cmake)
list(APPEND SRC SetupInitialCache.cmake)
list(APPEND SRC SetupInstallPrefix.cmake)
list(APPEND SRC SetupPackaging.cmake)
list(APPEND SRC SetupPlatformAndArchitecture.cmake)
list(APPEND SRC SetupProjectDefaults.cmake)
list(APPEND SRC SetupUnitTests.cmake)
list(APPEND SRC ShowConfigSummary.cmake)
list(APPEND SRC compiler/clang.cmake)
list(APPEND SRC compiler/common-clang-gnu.cmake)
list(APPEND SRC compiler/gnu.cmake)
list(APPEND SRC compiler/msvc.cmake)
list(APPEND SRC functions/cma_fxc_compile.cmake)
list(APPEND SRC functions/cma_list_targets.cmake)
list(APPEND SRC functions/cma_setup_application.cmake)
list(APPEND SRC functions/cma_setup_export.cmake)
list(APPEND SRC functions/cma_setup_file_target.cmake)
list(APPEND SRC functions/cma_setup_library.cmake)
list(APPEND SRC functions/cma_setup_test.cmake)
list(APPEND SRC functions/cma_utilities.cmake)
list(APPEND SRC scripts/test_coverage_collect.cmake)
list(APPEND SRC scripts/test_coverage_zero.cmake)

foreach(file ${SRC})
  get_filename_component(dir ${file} DIRECTORY)
  install(FILES       ${file}
          DESTINATION ${${PROJECT_NAME}_SHARE_DIRECTORY}/hugh/cmake/${dir}
	  COMPONENT   ${${PROJECT_NAME}_HDR_COMPONENT_NAME})
endforeach()

