#-------------------------------------------------------------------------------
#   rpi.toolchain.cmake
#   Fips cmake toolchain file for cross-compiling to Raspberry Pi.
#-------------------------------------------------------------------------------

message("Target Platform: Raspberry Pi")

if (${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Linux")
    set(RPI_TOOLS_DIRNAME "../fips-sdks/linux/rpi/tools")
    set(RPI_FIRMWARE_DIRNAME "../fips-sdks/linux/rpi/firmware")
endif()

set(FIPS_PLATFORM RPI)
set(FIPS_PLATFORM_NAME "rpi")
set(FIPS_RPI 1)
set(FIPS_POSIX 1)

# exceptions on/off?
if (FIPS_EXCEPTIONS)
    message("C++ exceptions are enabled")
    set(FIPS_RPI_EXCEPTION_FLAGS "")
else()
    message("C++ exceptions are disabled")
    set(FIPS_RPI_EXCEPTION_FLAGS "-fno-exceptions")
endif()

# RTTI on/off?
if (FIPS_RTTI)
    message("C++ RTTI is enabled")
    set(FIPS_RPI_RTTI_FLAGS "")
else()
    message("C++ RTTI is disabled")
    set(FIPS_RPI_RTTI_FLAGS "-fno-rtti")
endif()

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_VERSION 1)
set(COMPILING on)
set(CMAKE_CROSSCOMPILING TRUE)

get_filename_component(RPI_TOOLS_PATH "${RPI_TOOLS_DIRNAME}" ABSOLUTE)
message("Using Raspberry Pi tools at: ${RPI_TOOLS_PATH}")

get_filename_component(RPI_FIRMWARE_PATH "${RPI_FIRMWARE_DIRNAME}" ABSOLUTE)
message("Using Raspberry Pi firmware at: ${RPI_FIRMWARE_PATH}")

# paths
set(RPI_TOOLCHAIN_ROOT_PATH "${RPI_TOOLS_PATH}/arm-bcm2708/arm-bcm2708hardfp-linux-gnueabi")
set(RPI_GCC_PREFIX "arm-bcm2708hardfp-linux-gnueabi")
set(RPI_TOOLCHAIN_SYSROOT "${RPI_TOOLCHAIN_ROOT_PATH}/${RPI_GCC_PREFIX}/sysroot")
set(RPI_TOOLCHAIN_BIN "${RPI_TOOLCHAIN_ROOT_PATH}/bin")

# disable compiler detection
include(CMakeForceCompiler)
CMAKE_FORCE_C_COMPILER("${CMAKE_C_COMPILER}" GNU)
CMAKE_FORCE_CXX_COMPILER("${CMAKE_CXX_COMPILER}" GNU)

# define configurations
set(CMAKE_CONFIGURATION_TYPES Debug Release)

# specify cross-compilers
set(CMAKE_C_COMPILER "${RPI_TOOLCHAIN_BIN}/${RPI_GCC_PREFIX}-gcc" CACHE PATH "gcc" FORCE)
set(CMAKE_CXX_COMPILER "${RPI_TOOLCHAIN_BIN}/${RPI_GCC_PREFIX}-g++" CACHE PATH "g++" FORCE)
set(CMAKE_AR "${RPI_TOOLCHAIN_BIN}/${RPI_GCC_PREFIX}-ar" CACHE PATH "archive" FORCE)
set(CMAKE_LINKER "${RPI_TOOLCHAIN_BIN}/${RPI_GCC_PREFIX}-g++" CACHE PATH "linker" FORCE)
set(CMAKE_RANLIB "${RPI_TOOLCHAIN_BIN}/${RPI_GCC_PREFIX}-ranlib" CACHE PATH "ranlib" FORCE)

# only search for libraries and includes in the toolchain
set(CMAKE_FIND_ROOT_PATH ${RPI_TOOLCHAIN_SYSROOT})
set(CMAKE_SYSTEM_PROGRAM_PATH ${RPI_TOOLCHAIN_BIN})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# update cache variables for cmake gui
set(CMAKE_CONFIGURATION_TYPES "${CMAKE_CONFIGURATION_TYPES}" CACHE STRING "Config Type" FORCE)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}" CACHE STRING "Generic C++ Compiler Flags" FORCE)
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}" CACHE STRING "C++ Debug Compiler Flags" FORCE)
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}" CACHE STRING "C++ Release Compiler Flags" FORCE)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "Generic C Compiler Flags" FORCE)
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}" CACHE STRING "C Debug Compiler Flags" FORCE)
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}" CACHE STRING "C Release Compiler Flags" FORCE)
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}" CACHE STRING "Generic Linker Flags" FORCE)
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG}" CACHE STRING "Debug Linker Flags" FORCE)
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE}" CACHE STRING "Release Linker Flags" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS}" CACHE STRING "Generic Shared Linker Flags" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS_DEBUG "${CMAKE_SHARED_LINKER_FLAGS_DEBUG}" CACHE STRING "Debug Shared Linker Flags" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE}" CACHE STRING "Release Shared Linker Flags" FORCE)

# set the build type to use
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Compile Type" FORCE)
endif()
set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS Debug Release)
