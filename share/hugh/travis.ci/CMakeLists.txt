# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

cma_print_current_directory()

set(SRC_SCRIPTS)
list(APPEND SRC_SCRIPTS "fetch-or-update-git-repo.sh")

install(PROGRAMS ${SRC_SCRIPTS}
        DESTINATION ${${PROJECT_NAME}_SHARE_DIRECTORY}/hugh/travis.ci
	COMPONENT   ${${PROJECT_NAME}_HDR_COMPONENT_NAME})
