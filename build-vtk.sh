#!/usr/bin/env bash

set -ex

: ${SOURCE_ROOT:?} ${INSTALL_ROOT:?} ${GCC_VERSION:?} ${VTK_VERSION:?}

DIR_SRC=${SOURCE_ROOT}/vtk
#DIR_BUILD=${INSTALL_ROOT}/jemalloc/build
DIR_INSTALL=${INSTALL_ROOT}/vtk
FILE_MODULE=${INSTALL_ROOT}/modules/${VTK_VERSION::-2}/${VTK_VERSION}

DOWNLOAD_URL="https://www.vtk.org/files/release/9.1/VTK-${VTK_VERSION}.tar.gz"

if [[ ! -d ${DIR_INSTALL} ]]; then
    (
        mkdir -p ${DIR_SRC}
        cd ${DIR_SRC}
        wget ${DOWNLOAD_URL} 
        tar -xf VTK-${VTK_VERSION}.tar.gz
        #cd VTK-${VTK_VERSION}
        mkdir build
        cd build 
        ${CMAKE_COMMAND} \
        -DCMAKE_INSTALL_PREFIX=${DIR_INSTALL} \
        -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
        -DCMAKE_EXE_LINKER_FLAGS="${LDCXXFLAGS}" \
        -DCMAKE_SHARED_LINKER_FLAGS="${LDCXXFLAGS}" \
        -DVTK_REQUIRE_LARGE_FILE_SUPPORT=ON \
        ${DIR_SRC}/VTK-${VTK_VERSION}
        make -j${PARALLEL_BUILD}
        make install
    )
fi

mkdir -p $(dirname ${FILE_MODULE})
cat >${FILE_MODULE} <<EOF
#%Module
proc ModulesHelp { } {
  puts stderr {vtk}
}
module-whatis {vtk}
set root    ${DIR_INSTALL}
conflict    blaze
module load gcc/${GCC_VERSION}
prereq      gcc/${GCC_VERSION}
prepend-path    CPATH              \$root/include
prepend-path    PATH               \$root/bin
prepend-path    PATH               \$root/sbin
prepend-path    MANPATH            \$root/share/man
prepend-path    LD_LIBRARY_PATH    \$root/lib
prepend-path    LIBRARY_PATH       \$root/lib
prepend-path    PKG_CONFIG_PATH    \$root/lib/pkgconfig
setenv          vtk_ROOT      \$root
setenv          vtk_VERSION   ${VTK_VERSION}
EOF

