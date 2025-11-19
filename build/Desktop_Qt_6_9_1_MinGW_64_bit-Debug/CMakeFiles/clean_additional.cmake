# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appCarScreenUI_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appCarScreenUI_autogen.dir\\ParseCache.txt"
  "appCarScreenUI_autogen"
  )
endif()
