# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

cma_print_current_directory()

set(SRC)
list(APPEND SRC index.html)

install(FILES ${SRC}
        DESTINATION ${${PROJECT_NAME}_SHARE_DIRECTORY}/doc/hugh/
	COMPONENT   ${${PROJECT_NAME}_HDR_COMPONENT_NAME})
