: ${POWERTIGER_ROOT:?} ${BUILD_TYPE:?}

export INSTALL_ROOT=${POWERTIGER_ROOT}/build
export SOURCE_ROOT=${POWERTIGER_ROOT}/src

################################################################################
# Package Configuration
################################################################################
# BLAZE
export BLAZE_VERSION=3.8

# BLAZE Iterative
export BLAZE_ITERATIVE_VERSION=master

# YAML-CPP
export YAMLCPP_VERSION=0.6.3

# CMAKE
export CMAKE_VERSION=3.24.0

# HWLOC
export HWLOC_VERSION=2.2.0

# BOOST 
export BOOST_VERSION=1.80.0
export BOOST_ROOT=${INSTALL_ROOT}/boost
export BOOST_BUILD_TYPE=$(echo ${BUILD_TYPE/%WithDebInfo/ease} | tr '[:upper:]' '[:lower:]')

# Jemalloc
export JEMALLOC_VERSION=5.2.0

# GCC
export GCC_VERSION=13.0

# HPX
export HPX_VERSION=1.9.1

# VTK 
export VTK_VERSION=9.1.0

#GMSH
export GMSH_VERSION=4.9.1

export PERIHPX=main

# Max number of parallel jobs
export PARALLEL_BUILD=$(grep -c ^processor /proc/cpuinfo)
