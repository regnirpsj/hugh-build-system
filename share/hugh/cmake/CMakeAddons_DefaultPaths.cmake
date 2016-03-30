# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

if(VERBOSE)
  message(STATUS "Setting default paths prefixed with '${PROJECT_NAME}_'")
endif()

# sub directories, relative to CMAKE_BINARY_DIR or CMAKE_INSTALL_PREFIX
# depending on if they are used during build or install
set(${PROJECT_NAME}_CPACK_DIRECTORY   cpack)
set(${PROJECT_NAME}_RUNTIME_DIRECTORY bin)
set(${PROJECT_NAME}_ARCHIVE_DIRECTORY lib)
set(${PROJECT_NAME}_LIBRARY_DIRECTORY lib)

if(CMAKE_HOST_WIN32)
  set(${PROJECT_NAME}_LIBRARY_DIRECTORY ${${PROJECT_NAME}_RUNTIME_DIRECTORY})
endif()

set(${PROJECT_NAME}_HEADER_DIRECTORY  include)
set(${PROJECT_NAME}_SHARE_DIRECTORY   share)
set(${PROJECT_NAME}_DOC_DIRECTORY     ${${PROJECT_NAME}_SHARE_DIRECTORY}/doc)
set(${PROJECT_NAME}_EXTRA_DIRECTORY   ${${PROJECT_NAME}_SHARE_DIRECTORY}/extra)
set(${PROJECT_NAME}_SHADER_DIRECTORY  ${${PROJECT_NAME}_SHARE_DIRECTORY}/shader)

if(VERBOSE)
  message(STATUS "Setting default paths prefixed with 'CMAKE_'")
endif()

# output directories, overwrite
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${${PROJECT_NAME}_LIBRARY_DIRECTORY})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${${PROJECT_NAME}_ARCHIVE_DIRECTORY})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${${PROJECT_NAME}_RUNTIME_DIRECTORY})
# output directories, project specific
set(CMAKE_DOC_OUTPUT_DIRECTORY     ${CMAKE_BINARY_DIR}/${${PROJECT_NAME}_DOC_DIRECTORY})
set(CMAKE_EXTRA_OUTPUT_DIRECTORY   ${CMAKE_BINARY_DIR}/${${PROJECT_NAME}_EXTRA_DIRECTORY})
set(CMAKE_SHADER_OUTPUT_DIRECTORY  ${CMAKE_BINARY_DIR}/${${PROJECT_NAME}_SHADER_DIRECTORY})
