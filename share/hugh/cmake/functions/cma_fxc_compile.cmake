# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# .rst:
# cma_fxc_compile(RESULT TYPE ENTRY SOURCES .. [INCLUDES ..] [DEPENDENCIES ..] [DEBUG])
#   RESULT       -
#   ENTRY        -
#   SOURCES      -
#   INCLUDES     -
#   DEPENDENCIES -
#   DEBUG        -
#
function(cma_fxc_compile FXC_RESULT FXC_TYPE FXC_ENTRY)
  if(NOT FXC)
    find_package(WindowsSDK 8.0 REQUIRED)
    find_program(FXC fxc HINTS ${WindowsSDK_ROOT_DIR}/${ARCH}/bin DOC "DirectX shader compiler")
    if(NOT FXC)
      message(SEND_ERROR "Error: unable to find DirectX shader compiler (fxc)")
    else()
      if(FXC_DEBUG OR VERBOSE)
	message(STATUS "Found DirectX shader compiler: ${FXC}")
      endif()
    endif()
  endif()

  include(CMakeParseArguments)

  set(OARGS DEBUG)
  set(SARGS)
  set(MARGS SOURCES INCLUDES DEPENDENCIES)
  cmake_parse_arguments(FXC "${OARGS}" "${SARGS}" "${MARGS}" ${ARGN})

  if(NOT FXC_SOURCES)
    message(SEND_ERROR "Error: cma_fxc_compile() called without any source files")
    return()
  endif()

  # note: fxc doesn't like spaces between options and arguments, i.e.
  #       '/X x' will not work, while '/Xx' is does

  set(FXC_FLAGS)

  list(APPEND FXC_FLAGS "/nologo")           # suppress copyright message
  list(APPEND FXC_FLAGS "/Cc")               # output color coded assembly listings
  list(APPEND FXC_FLAGS "/Ges")              # enable strict mode
  list(APPEND FXC_FLAGS "/Gis")              # force IEEE strictness
  list(APPEND FXC_FLAGS "/T${FXC_TYPE}_5_0") # target profile
  list(APPEND FXC_FLAGS "/Zpc")              # pack matrices in column-major order

  if("Release" STREQUAL "${CMAKE_BUILD_TYPE}")
    list(APPEND FXC_FLAGS "/O3")             # optimization level 0..3. 1 is default
    list(APPEND FXC_FLAGS "/Qstrip_debug")   # strip debug information from 4_0+ shader bytecode
    list(APPEND FXC_FLAGS "/Qstrip_priv")    # strip private data from 4_0+ shader bytecode
  else()
    list(APPEND FXC_FLAGS "/O2")             # optimization level 0..3. 1 is default
    list(APPEND FXC_FLAGS "/Zi")             # enable debugging information

    if("DEBUG" STREQUAL "${CMAKE_BUILD_TYPE}")
      list(APPEND FXC_FLAGS "/D_DEBUG=1")
      list(APPEND FXC_FLAGS "/DDEBUG=1")
    endif()
  endif()

  if(FXC_DEBUG)
    list(APPEND FXC_FLAGS "/Vi") # display details about the include process
  endif()

  foreach(path ${FXC_INCLUDES})
    if(NOT "" STREQUAL "${path}")
      list(APPEND FXC_FLAGS "/I${path}")
    endif()
  endforeach()  

  set(FXC_DEPENDENCIES_ABS)
  foreach(file ${FXC_DEPENDENCIES})
    get_filename_component(file_abs ${file} ABSOLUTE)
    list(APPEND FXC_DEPENDENCIES_ABS ${file_abs})
  endforeach()

  if(FXC_DEBUG OR VERBOSE)
    MESSAGE(STATUS "cma_fxc_compile(${FXC_RESULT};${FXC_TYPE};${FXC_ENTRY};${ARGN}) variable setup:\n"
      "   FXC_RESULT           = ${FXC_RESULT}\n"
      "   FXC_TYPE             = ${FXC_TYPE}\n"
      "   FXC_ENTRY            = ${FXC_ENTRY}\n"
      "   FXC_SOURCES          = ${FXC_SOURCES}\n"
      "   FXC_INCLUDES         = ${FXC_INCLUDES}\n"
      "   FXC_DEPENDENCIES     = ${FXC_DEPENDENCIES}\n"
      "   FXC_DEPENDENCIES_ABS = ${FXC_DEPENDENCIES_ABS}\n"
      "   FXC_FLAGS            = ${FXC_FLAGS}")
  endif()

  set(${FXC_RESULT})

  foreach(file ${FXC_SOURCES})
    get_filename_component(path    ${file} PATH)
    get_filename_component(src_rel ${file} NAME)
    get_filename_component(src_abs ${file} ABSOLUTE)
    get_filename_component(dst     ${file} NAME_WE)
    
    set(dst_name "${dst}_${FXC_TYPE}_${FXC_ENTRY}")
    set(dst_file "${dst_name}.inc")
    
    if(NOT "" STREQUAL "${path}")
      set(dst_file "${path}/${dst_file}")
    endif()

    list(APPEND ${FXC_RESULT} "${CMAKE_CURRENT_BINARY_DIR}/${dst_file}")
    
    add_custom_command(
      OUTPUT          "${CMAKE_CURRENT_BINARY_DIR}/${dst_file}"
      COMMAND          ${FXC}
      ARGS             ${FXC_FLAGS} /E${FXC_ENTRY} /Vn${dst_name} /Fh${dst_file} ${src_abs}
      MAIN_DEPENDENCY  ${src_abs}
      DEPENDS          ${FXC_DEPENDENCIES_ABS} ${FXC_DEPENDENCIES}
      COMMENT         "Compiling HLSL shader ${src_rel} (${FXC_TYPE},${FXC_ENTRY}) to ${dst_file}"
      VERBATIM)
  endforeach()
  
  set_source_files_properties(${${FXC_RESULT}} PROPERTIES GENERATED TRUE)
  set(${FXC_RESULT} ${${FXC_RESULT}} PARENT_SCOPE)
endfunction()
