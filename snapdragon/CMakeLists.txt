cmake_minimum_required(VERSION 2.8)

set(OPENMP_KERNEL_SOURCES
    kernels/kernel.cl.openmp.c
   )

set(HEXAGON_KERNEL_SOURCES
    kernels/kernel.cl.hexagon.c
   )

set(APP_SOURCES
    saxpy.c
   )

set(APP_EXECUTABLE  saxpy)
set(HEXAGON_RELATIVE_STUB "stub_dsp")

project(IRISKernels)
include(GNUInstallDirs)

set(IRISKernels_VERSION_MAJOR 1)
set(IRISKernels_VERSION_MINOR 0)
set(IRISKernels_VERSION_PATCH 0)

set(IRISKernels_SRC_DIR ${PROJECT_SOURCE_DIR}/src)
set(IRISKernels_INC_DIR ${PROJECT_SOURCE_DIR}/include)
set(IRISKernels_BIN_DIR ${PROJECT_BINARY_DIR}/src)

option(CDSP_FLAG "Enable support for CDSP"     ON )
option(ADSP_FLAG "Enable support for ADSP"     OFF )
option(MDSP_FLAG "Enable support for MDSP"     OFF )
option(SLPI_FLAG "Enable support for SLPI"     OFF )
option(USE_PYTHON  "Enable support for Python" ON )
option(USE_FORTRAN "Enable support for Fortran 90" OFF)

option(USE_SIGHANDLER   "Enable signal handler" OFF)
option(USE_HUB          "Enable hub"            OFF)

set(STUB_FLAG "")
set(LIB_DSPRPC "cdsprpc")
if (CDSP_FLAG) 
set(LIB_DSPRPC cdsprpc)
set(STUB_FLAG "CDSP_FLAG=1")
endif()
if (ADSP_FLAG) 
set(LIB_DSPRPC adsprpc)
set(STUB_FLAG "ADSP_FLAG=1")
endif()
if (MDSP_FLAG) 
set(LIB_DSPRPC mdsprpc)
set(STUB_FLAG "MDSP_FLAG=1")
endif()
if (SLPI_FLAG) 
set(LIB_DSPRPC sdsprpc)
set(STUB_FLAG "SLPI_FLAG=1")
endif()
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wno-unused-parameter -Wno-unused-variable")
if (CMAKE_VERSION VERSION_LESS "3.1")
  set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
else()
  set(CMAKE_CXX_STANDARD 11)
endif()

set(HEXAGON_STUB ${PROJECT_SOURCE_DIR}/${HEXAGON_RELATIVE_STUB})
set(HEXAGON_STUB_LIBDIR "${PROJECT_SOURCE_DIR}/${HEXAGON_RELATIVE_STUB}/android_Release_aarch64")
set(HEXAGON_CORE_LIBDIR "${PROJECT_SOURCE_DIR}/${HEXAGON_RELATIVE_STUB}/hexagon_Release_dynamic_toolv83_v66")
set(IRISHXG "${HEXAGON_STUB_LIBDIR}/libbrisbanehxg.so")
set(OPENMP_FLAGS "-fopenmp -fPIC -I$ENV{IRIS}/include")
set(HEXAGON_FLAGS "-fPIC -I$ENV{IRIS}/include")
set(APP_FLAGS "-fPIC -I$ENV{IRIS}/include")
set(APP_LDFLAGS "-L$ENV{IRIS}/lib64 -L${HEXAGON_STUB_LIBDIR}")
set(HEXAGON_RPC "$ENV{HEXAGON_SDK_ROOT}/libs/common/rpcmem/android_Release_aarch64/ship/rpcmem.a")
add_library(kernel.openmp SHARED ${OPENMP_KERNEL_SOURCES})
set_target_properties(kernel.openmp PROPERTIES COMPILE_FLAGS ${OPENMP_FLAGS})
set_target_properties(kernel.openmp PROPERTIES LINK_FLAGS ${OPENMP_FLAGS})
set_target_properties(kernel.openmp PROPERTIES PREFIX "")

add_library(kernel.hexagon SHARED ${HEXAGON_KERNEL_SOURCES})
set_target_properties(kernel.hexagon PROPERTIES COMPILE_FLAGS ${HEXAGON_FLAGS})
set_target_properties(kernel.hexagon PROPERTIES PREFIX "")
target_link_libraries(kernel.hexagon ${HEXAGON_RPC} log)
install(TARGETS kernel.openmp DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
install(TARGETS kernel.openmp DESTINATION ${PROJECT_SOURCE_DIR}/ship)
install(TARGETS kernel.hexagon DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
install(TARGETS kernel.hexagon DESTINATION ${PROJECT_SOURCE_DIR}/ship)

add_custom_command(
  OUTPUT ${IRISHXG}
  WORKING_DIRECTORY ${HEXAGON_STUB} 
  COMMAND make tree V=android_Release_aarch64 ${STUB_FLAG} IRIS=$ENV{IRIS} VERBOSE=1 API_LEVEL=28 
  COMMAND make tree V=hexagon_Release_dynamic_toolv83_v66 IRIS=$ENV{IRIS} VERBOSE=1 API_LEVEL=28 
  )
add_custom_command(
  OUTPUT setup.source
  COMMAND echo 'y' | python $ENV{HEXAGON_SDK_ROOT}/tools/elfsigner/elfsigner.py -zz -t 0x15bd6ed 
  COMMAND echo 'y' | python $ENV{HEXAGON_SDK_ROOT}/tools/elfsigner/elfsigner.py -zz -t 0x4061ec60
  COMMAND echo "export PATH=\\$$PWD:\\$$PWD/bin:/system/bin:\\$$PATH" > setup.source 
  COMMAND echo "export LD_LIBRARY_PATH=.:\\$$PWD:\\$$PWD/lib:\\$$LD_LIBRARY_PATH" >> setup.source 
  )
#printf "0x%x\n" `adb shell cat /sys/devices/soc0/serial_number` > serial
install(FILES ${PROJECT_BINARY_DIR}/setup.source DESTINATION ${CMAKE_INSTALL_PREFIX}/)
install(FILES ${PROJECT_BINARY_DIR}/setup.source DESTINATION ${PROJECT_SOURCE_DIR}/ship)
install(FILES ${PROJECT_BINARY_DIR}/output/testsig-0x15bd6ed.so DESTINATION ${CMAKE_INSTALL_PREFIX}/)
install(FILES ${PROJECT_BINARY_DIR}/output/testsig-0x15bd6ed.so DESTINATION ${PROJECT_SOURCE_DIR}/ship)
install(FILES ${PROJECT_BINARY_DIR}/output/testsig-0x4061ec60.so DESTINATION ${CMAKE_INSTALL_PREFIX}/)
install(FILES ${PROJECT_BINARY_DIR}/output/testsig-0x4061ec60.so DESTINATION ${PROJECT_SOURCE_DIR}/ship)
install(DIRECTORY ${PROJECT_SOURCE_DIR}/kernels DESTINATION ${CMAKE_INSTALL_PREFIX}/ FILES_MATCHING PATTERN "*.cl")
install(DIRECTORY ${PROJECT_SOURCE_DIR}/kernels DESTINATION ${PROJECT_SOURCE_DIR}/ship FILES_MATCHING PATTERN "*.cl")
if (APP_SOURCES)
add_executable(${APP_EXECUTABLE} ${APP_SOURCES})
add_custom_target(irishxg DEPENDS ${IRISHXG})
add_custom_target(setup DEPENDS setup.source)
add_dependencies(${APP_EXECUTABLE} irishxg setup)
set_target_properties(${APP_EXECUTABLE} PROPERTIES COMPILE_FLAGS ${APP_FLAGS})
set_target_properties(${APP_EXECUTABLE} PROPERTIES LINK_FLAGS ${APP_LDFLAGS})
target_link_libraries(${APP_EXECUTABLE} brisbane) 
#brisbanehxg ${LIB_DSPRPC} log)
install(FILES ${HEXAGON_CORE_LIBDIR}/libbrisbanehxg_skel.so DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
install(FILES ${HEXAGON_CORE_LIBDIR}/libbrisbanehxg_skel.so DESTINATION ${PROJECT_SOURCE_DIR}/ship)
install(FILES ${HEXAGON_STUB_LIBDIR}/libbrisbanehxg.so DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
install(FILES ${HEXAGON_STUB_LIBDIR}/libbrisbanehxg.so DESTINATION ${PROJECT_SOURCE_DIR}/ship)
install(FILES ${HEXAGON_STUB_LIBDIR}/lib${LIB_DSPRPC}.so DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
install(FILES ${HEXAGON_STUB_LIBDIR}/lib${LIB_DSPRPC}.so DESTINATION ${PROJECT_SOURCE_DIR}/ship)
install(TARGETS ${APP_EXECUTABLE} DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
install(TARGETS ${APP_EXECUTABLE} DESTINATION ${PROJECT_SOURCE_DIR}/ship)
endif()
install(FILES $ENV{BRISBANE}/lib64/libbrisbane.so DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
install(FILES $ENV{BRISBANE}/lib64/libbrisbane.so DESTINATION ${PROJECT_SOURCE_DIR}/ship)

#add_subdirectory(include)
#add_subdirectory(src)

