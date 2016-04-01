# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

cma_print_current_directory()

set(SRC)
list(APPEND SRC proto.CMakeLists.txt)
list(APPEND SRC proto.class.cpp)
list(APPEND SRC proto.class.hpp)
list(APPEND SRC proto.class.inl)
list(APPEND SRC proto.html)
list(APPEND SRC proto.module.c)
list(APPEND SRC proto.module.cmake)
list(APPEND SRC proto.module.h)
list(APPEND SRC proto.shader.glsl)
list(APPEND SRC proto.shader.hlsl)
list(APPEND SRC proto.test.cpp)

install(FILES ${SRC}
        DESTINATION ${${PROJECT_NAME}_SHARE_DIRECTORY}/hugh/proto
	COMPONENT   ${${PROJECT_NAME}_HDR_COMPONENT_NAME})
