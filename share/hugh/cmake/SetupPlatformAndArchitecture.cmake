# -*- Mode:cmake -*-

####################################################################################################
#                                                                                                  #
# Copyright (C) 2016 University of Hull                                                            #
#                                                                                                  #
####################################################################################################

set(ARCH "unknown")

if(UNIX)
  execute_process(COMMAND uname -m OUTPUT_VARIABLE ARCH OUTPUT_STRIP_TRAILING_WHITESPACE)
endif()

# 32-bit vs. 64-bit platform
# unfortunatly, M$ are completely inconsistent in how they name directories (e.g., x64 vs. amd64),
# which is why no architecture variable is set here as well
if(MSVC AND CMAKE_CL_64)
  set(WIN64 1)
else()
  set(WIN64 0)
endif()

if(WIN32 OR WIN64)
  set(ARCH x86)
  if(WIN64)
    set(ARCH x64)
  endif()
endif()
