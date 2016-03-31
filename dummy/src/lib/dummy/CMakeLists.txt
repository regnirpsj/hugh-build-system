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
