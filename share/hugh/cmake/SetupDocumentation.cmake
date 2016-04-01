# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

if(NOT DOXYGEN_FOUND AND (${PROJECT_NAME}_DOC_DEV OR ${PROJECT_NAME}_DOC_USR))
  find_package(Doxygen)

  if(DOXYGEN_FOUND)
    cma_fetch_url(http://upload.cppreference.com/mwiki/images/f/f8/cppreference-doxygen-web.tag.xml
      ${CMAKE_CURRENT_BINARY_DIR}/cppreference-doxygen-web.tag.xml)

    string(TOLOWER ${CMAKE_PROJECT_NAME} PROJECT_NAME_LC)
    string(REPLACE "_" "/" DOC_INSTALL_DIR ${PROJECT_NAME_LC})

  set(COMMON_CFG_FILE common.doxygen.cfg)

  configure_file(${CMAKE_INSTALL_PREFIX}/${${PROJECT_NAME}_SHARE_DIRECTORY}/hugh/doxygen/${COMMON_CFG_FILE}.in
                 ${CMAKE_CURRENT_BINARY_DIR}/${COMMON_CFG_FILE}
		 @ONLY IMMEDIATE)
    
  endif()
endif()

if(DOXYGEN_FOUND AND ${PROJECT_NAME}_DOC_DEV)
  if(VERBOSE)
    message(STATUS "Generation of developer documentation enabled")
  endif()
  
  set(BASE_CFG_FILE base.dev.doxygen.cfg)

  configure_file(${CMAKE_INSTALL_PREFIX}/${${PROJECT_NAME}_SHARE_DIRECTORY}/hugh/doxygen/${BASE_CFG_FILE}.in
                 ${CMAKE_CURRENT_BINARY_DIR}/${BASE_CFG_FILE}
		 @ONLY IMMEDIATE)

  set(${PROJECT_NAME}_CFG_FILE ${PROJECT_NAME_LC}.dev.doxygen.cfg)

  configure_file(${${PROJECT_NAME}_CFG_FILE}.in
                 ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_CFG_FILE}
		 @ONLY IMMEDIATE)

  add_custom_target(devdoc
    COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_CFG_FILE}
    SOURCES ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_CFG_FILE}
            ${CMAKE_CURRENT_BINARY_DIR}/${CFG_FILE_NAME})

  # build before install
  install(CODE "execute_process(COMMAND \"${CMAKE_COMMAND}\" --build . --target devdoc)")

  install(DIRECTORY   ${CMAKE_CURRENT_BINARY_DIR}/dev
          DESTINATION ${${PROJECT_NAME}_DOC_DIRECTORY}/${DOC_INSTALL_DIR}
	  COMPONENT   ${${PROJECT_NAME}_DOC_COMPONENT_NAME})
  install(FILES       ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME_LC}.dev.tag.xml
          DESTINATION ${${PROJECT_NAME}_DOC_DIRECTORY}/${DOC_INSTALL_DIR}
	  COMPONENT   ${${PROJECT_NAME}_DOC_COMPONENT_NAME})
else()
  if(VERBOSE)
    message(STATUS "Generation of developer documentation disabled")
  endif()
endif()

if(DOXYGEN_FOUND AND ${PROJECT_NAME}_DOC_USR)
  if(VERBOSE)
    message(STATUS "Generation of user documentation enabled")
  endif()
  
  set(BASE_CFG_FILE base.usr.doxygen.cfg)

  configure_file(${CMAKE_INSTALL_PREFIX}/${${PROJECT_NAME}_SHARE_DIRECTORY}/hugh/doxygen/${BASE_CFG_FILE}.in
                 ${CMAKE_CURRENT_BINARY_DIR}/${BASE_CFG_FILE}
		 @ONLY IMMEDIATE)

  set(${PROJECT_NAME}_CFG_FILE ${PROJECT_NAME_LC}.usr.doxygen.cfg)

  configure_file(${${PROJECT_NAME}_CFG_FILE}.in
                 ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_CFG_FILE}
		 @ONLY IMMEDIATE)

  add_custom_target(usrdoc
    COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_CFG_FILE}
    SOURCES ${CMAKE_CURRENT_BINARY_DIR}/${${PROJECT_NAME}_CFG_FILE}
            ${CMAKE_CURRENT_BINARY_DIR}/${CFG_FILE_NAME})

  # build before install
  install(CODE "execute_process(COMMAND \"${CMAKE_COMMAND}\" --build . --target usrdoc)")

  install(DIRECTORY   ${CMAKE_CURRENT_BINARY_DIR}/usr
          DESTINATION ${${PROJECT_NAME}_DOC_DIRECTORY}/${DOC_INSTALL_DIR}
	  COMPONENT   ${${PROJECT_NAME}_DOC_COMPONENT_NAME})
  install(FILES       ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME_LC}.usr.tag.xml
          DESTINATION ${${PROJECT_NAME}_DOC_DIRECTORY}/${DOC_INSTALL_DIR}
	  COMPONENT   ${${PROJECT_NAME}_DOC_COMPONENT_NAME})
else()
  if(VERBOSE)
    message(STATUS "Generation of user documentation disabled")
  endif()
endif()
