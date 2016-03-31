# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

cma_print_current_directory()

set(SRC)
LIST(APPEND SRC dummy.cpp)

set(LIB hugh_dummy)

cma_setup_library(${LIB} SOURCES ${SRC} DEPENDENCIES ${LIBS} ${LIBS} INCDIR hugh/support NOINSTALL)
cma_setup_export(${LIB} NOINSTALL)

add_subdirectory(test EXCLUDE_FROM_ALL)

find_package(AntTweakBar)
find_package(Boost      ${BOOST_MINIMUM_VERSION})
find_package(FreeGLUT)
find_package(GLEW)
find_package(GLI        ${GLI_MINIMUM_VERSION})
find_package(GLM        ${GLM_MINIMUM_VERSION})
find_package(HUGH)
find_package(OGLplus)
find_package(WindowsSDK)
find_package(XSDCXX)
