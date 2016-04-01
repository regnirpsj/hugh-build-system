# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

cma_print_current_directory()

set(SRC)
list(APPEND SRC base.dev.doxygen.cfg.in)
list(APPEND SRC base.usr.doxygen.cfg.in)
list(APPEND SRC common.doxygen.cfg.in)

install(FILES ${SRC}
        DESTINATION ${${PROJECT_NAME}_SHARE_DIRECTORY}/hugh/doxygen
	COMPONENT   ${${PROJECT_NAME}_HDR_COMPONENT_NAME})
