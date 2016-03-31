# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

cma_print_current_directory()

set(SRC)
list(APPEND SRC main.cpp)

set(LIBS)
list(APPEND LIBS hugh_dummy)

set(APP hugh_dummy)

cma_setup_application(${APP} SOURCES ${SRC} DEPENDENCIES ${LIBS} NOINSTALL)
