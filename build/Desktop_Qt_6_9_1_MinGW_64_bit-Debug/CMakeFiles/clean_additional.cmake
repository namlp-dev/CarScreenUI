# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appNeonCarInfotainment_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appNeonCarInfotainment_autogen.dir\\ParseCache.txt"
  "appNeonCarInfotainment_autogen"
  )
endif()
