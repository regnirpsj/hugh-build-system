# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

# .rst:
# FindWindowsSDK
# ----------------
#
# Find Microsoft Windows SDK/Kit(s)
#
# Use this module by invoking find_package with the form::
#
#   find_package(WindowsSDK
#     [<version>]             - Required minimum version (defaults to 8.0).
#     [REQUIRED]              - Fail with error if Microsoft Windows Kit is not found.
#     )
#
# This module finds the root of the most recent or requested version of an installed Microsoft
# Windows Kit. Results are reported in variables::
#
#   WindowsSDK_FOUND          - True if Microsoft Windows Kit was found.
#   WindowsSDK_VERSION        - Version per registry entry.
#   WindowsSDK_VERSION_MAJOR  - Major version per registry entry.
#   WindowsSDK_VERSION_MINOR  - Minor version per registry entry.
#   WindowsSDK_ROOT_DIR       - Installation directory.
#   WindowsSDK_BIN_DIR        - Binary directory for the current compiler setup.
#   WindowsSDK_BIN_<A>_DIR    - Binary directory for x86/x64 compiler setups.
#   WindowsSDK_LIB_DIR        - Library directory for the current compiler setup.
#   WindowsSDK_LIB_<A>_DIR    - Library directory for x86/x64 compiler setups.
#   WindowsSDK_REDIST_DIR     - Redistributable directory for the current compiler setup.
#   WindowsSDK_REDIST_<A>_DIR - Redistributable directory for x86/x64 compiler setups.
#
# This module reads hints about search locations from variables::
#
#   WindowsSDK_ROOT_DIR - Preferred installation prefix
#                         this can be supplied before calling the module or as an environment
#                         variable.

# Some reading material::
# - 'What's up with D3DCompiler_xx.DLL?'
#    see [http://blogs.msdn.com/b/chuckw/archive/2010/04/22/what-s-up-with-d3dcompiler-xx-dll.aspx]
# - 'Where is the DirectX SDK?'
#    see [http://blogs.msdn.com/b/chuckw/archive/2012/03/22/where-is-the-directx-sdk.aspx]
# - 'HLSL, FXC, and D3DCompile'
#    see [http://blogs.msdn.com/b/chuckw/archive/2012/05/07/hlsl-fxc-and-d3dcompile.aspx]

if(NOT CMAKE_HOST_WIN32)
  if(VERBOSE)
    message(STATUS "Microsoft Windows SDK not confgurable on non-MSWindows platforms")
  endif()
  return()
endif()

# 1. DirectX SDK (June 2010) specifics; note: this sdk is deprecated in favour of the Windows SDK
# actually, it seems that the Windows (8) SDK does install over previously installed DirectX SDKs
# without deinstalling/removing them!
if(NOT "" STREQUAL "$ENV{DXSDK_DIR}")
  if(NOT VERBOSE)
    message(STATUS "Found DirectX SDK environment variable DXSDK_DIR!")
  else()
    if(EXISTS $ENV{DXSDK_DIR})
      message(AUTHOR_WARNING "Found DirectX SDK in '$ENV{DXSDK_DIR}'! (not used)")
    else()
      message(AUTHOR_WARNING "DXSDK_DIR set to '$ENV{DXSDK_DIR}', but path non-existent")
    endif()
  endif()
endif()

# 2. NVIDIA Graphics SDK 11
if(NOT "" STREQUAL "$ENV{NVSDK11D3D_ROOT}")
  if(NOT VERBOSE)
    message(STATUS "Found NVIDIA D3D11 SDK environment variable NVSDK11D3D_ROOT!")
  else()
    if(EXISTS $ENV{NVSDK11D3D_ROOT})
      message(AUTHOR_WARNING "Found NVIDIA D3D11 SDK in '$ENV{NVSDK11D3D_ROOT}'! (not used)")
    else()
      message(AUTHOR_WARNING "NVSDK11D3D_ROOT set to '$ENV{NVSDK11D3D_ROOT}', but path non-existent")
    endif()
  endif()
endif()

set(_mswk_ENV_ROOT_DIR "$ENV{WindowsSDK_ROOT_DIR}")

if(NOT WindowsSDK_ROOT_DIR AND _mswk_ENV_ROOT_DIR)
  set(WindowsSDK_ROOT_DIR "${_mswk_ENV_ROOT_DIR}")
endif()

set(WindowsSDK_VERSION_MAJOR "8")
set(WindowsSDK_VERSION_MINOR "0")
set(WindowsSDK_VERSION       "${WindowsSDK_VERSION_MAJOR}.${WindowsSDK_VERSION_MINOR}")
set(_mswk_KITS_ROOT "C:/Program Files (x86)/Windows Kits/${WindowsSDK_VERSION}/")

if(NOT WindowsSDK_ROOT_DIR)
  # 3. find reg.exe
  if(NOT REG)
    find_program(REG reg HINTS "C:/Windows/system32/reg.exe" DOC "Registry console tool")
    if(NOT REG)
      message(SEND_ERROR "Error: unable to find registry console tool (reg)")
    else()
      if(VERBOSE)
        message(STATUS "Found registry console tool: ${REG}")
      endif()
    endif()
  endif()

  # .rst:
  # recursively (/s) search for any case-sensitive (/c) occurrence of 'KitsRoot*' under
  # 'HKLM\Software\Microsoft\Windows Kits'::
  #
  #   'reg query "HKLM\Software\Microsoft\Windows Kits" /f KitsRoot /s /c'
  #
  # alternatively,::
  #
  #   'reg query "HKLM\Software\Microsoft\Windows Kits\Installed Roots" /v KitsRoot'
  #
  # can be used (prior to win10) but 'KitsRoot' needs to be adapted for different version

  execute_process(COMMAND ${REG} query "HKLM\\Software\\Microsoft\\Windows Kits" /f KitsRoot /s /c
    RESULT_VARIABLE QUERY_RESULT OUTPUT_VARIABLE QUERY_OUTPUT ERROR_VARIABLE QUERY_ERROR)
  
  if(NOT QUERY_RESULT AND NOT "" STREQUAL "${QUERY_OUTPUT}")
    string(REGEX REPLACE "\\\\"   "/" QUERY_OUTPUT "${QUERY_OUTPUT}") # "\"      -> "/"
    string(REGEX REPLACE "REG_SZ" ";" QUERY_OUTPUT "${QUERY_OUTPUT}") # "REG_SZ" -> ";"
    string(REGEX REPLACE "\n"     ";" QUERY_OUTPUT "${QUERY_OUTPUT}") # "\n"     -> ";"
    
    list(REMOVE_AT QUERY_OUTPUT -1 -2 -3 0 1)
    
    list(LENGTH QUERY_OUTPUT total)
    math(EXPR total ${total}-1)
    
    foreach(index RANGE ${total} 0 -2)
      list(GET QUERY_OUTPUT ${index} value)
      string(STRIP ${value} value)
      if(EXISTS ${value})
	set(_mswk_KITS_ROOT ${value})
	break()
      endif()
    endforeach()
  endif()
endif(NOT WindowsSDK_ROOT_DIR)

if(EXISTS ${_mswk_KITS_ROOT})
  string(REGEX REPLACE "/+$" "" _mswk_KITS_ROOT "${_mswk_KITS_ROOT}")
  string(REPLACE "/" ";" VERSION_LIST ${_mswk_KITS_ROOT})
  list(GET VERSION_LIST -1 WindowsSDK_VERSION)
  string(REPLACE "." ";" VERSION_LIST ${WindowsSDK_VERSION})
  list(GET VERSION_LIST 0 WindowsSDK_VERSION_MAJOR)
  list(LENGTH VERSION_LIST len)
  if("2" EQUAL ${len})
    list(GET VERSION_LIST 1 WindowsSDK_VERSION_MINOR)
  else()
    string(CONCAT WindowsSDK_VERSION ${WindowsSDK_VERSION} ".0")
  endif()
endif()

set(WindowsSDK_ROOT_DIR           "${_mswk_KITS_ROOT}")
set(WindowsSDK_BIN_DIR            ${WindowsSDK_ROOT_DIR}/bin)
set(WindowsSDK_BIN_${ARCH}_DIR    ${WindowsSDK_ROOT_DIR}/bin/${ARCH})
set(WindowsSDK_LIB_DIR            ${WindowsSDK_ROOT_DIR}/Lib)
set(WindowsSDK_LIB_${ARCH}_DIR    ${WindowsSDK_ROOT_DIR}/Lib/${ARCH})
set(WindowsSDK_REDIST_DIR         ${WindowsSDK_ROOT_DIR}/Redist)
set(WindowsSDK_REDIST_${ARCH}_DIR ${WindowsSDK_ROOT_DIR}/Redist/${ARCH})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(WindowsSDK
                                  FOUND_VAR     WindowsSDK_FOUND
                                  REQUIRED_VARS WindowsSDK_ROOT_DIR
                                                WindowsSDK_BIN_DIR    WindowsSDK_BIN_${ARCH}_DIR
                                                WindowsSDK_LIB_DIR    WindowsSDK_LIB_${ARCH}_DIR
                                                WindowsSDK_REDIST_DIR WindowsSDK_REDIST_${ARCH}_DIR
                                  VERSION_VAR   WindowsSDK_VERSION)

if(WindowsSDK_FOUND AND VERBOSE)
  message(STATUS "Microsoft WindowsSDK setup:\n"
    "   WindowsSDK_ROOT_DIR       = ${WindowsSDK_ROOT_DIR}\n"
    "   WindowsSDK_VERSION        = ${WindowsSDK_VERSION}\n"
    "   WindowsSDK_VERSION_MAJOR  = ${WindowsSDK_VERSION_MAJOR}\n"
    "   WindowsSDK_VERSION_MINOR  = ${WindowsSDK_VERSION_MINOR}\n"
    "   WindowsSDK_BIN_DIR        = ${WindowsSDK_BIN_DIR}\n"
    "   WindowsSDK_BIN_${ARCH}_DIR    = ${WindowsSDK_BIN_${ARCH}_DIR}\n"
    "   WindowsSDK_LIB_DIR        = ${WindowsSDK_LIB_DIR}\n"
    "   WindowsSDK_LIB_${ARCH}_DIR    = ${WindowsSDK_LIB_${ARCH}_DIR}\n"
    "   WindowsSDK_REDIST_DIR     = ${WindowsSDK_REDIST_DIR}\n"
    "   WindowsSDK_REDIST_${ARCH}_DIR = ${WindowsSDK_REDIST_${ARCH}_DIR}"
    )
endif()
