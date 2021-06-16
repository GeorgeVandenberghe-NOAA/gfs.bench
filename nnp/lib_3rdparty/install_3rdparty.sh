#!/bin/bash
set -eux

if [[ $# != 1 ]]; then
  echo "Usage: $0 | intel | intel.cray"
  exit 1
fi

if [[ $1 == intel ]]; then
  COMPILERS=intel
  export FC=ifort
  export FCFLAGS="-convert big_endian"
  export CC=icc
  export CXX=icpp
  export ESMF_OS=Linux
  export ESMF_COMM=intelmpi
elif [[ $1 == intel.cray ]]; then
  COMPILERS=intel.cray
  export FC=ftn
  export FCFLAGS="-convert big_endian"
  export CC=cc
  export CXX=CC
  export ESMF_OS=Unicos
  export ESMF_COMM=mpi
else
  echo "Usage: $0 intel | intel.cray"
  exit 1
fi

echo "Installing 3rdparty libraries using ${COMPILERS} compilers"
date

MYDIR=${PWD}
LIBDIR=${NWPROD_LIB:=${MYDIR}/../lib}

#
# ESMF
#
####export ESMF_OPENMP=OFF

cd ${MYDIR}

ESMF=esmf_3_1_0rp5
rm -rf esmf ${ESMF}
tar zxvf ${ESMF}_src.tar.gz
mv esmf ${ESMF}
cd ${ESMF}

export ESMF_DIR=`pwd`
export ESMF_BOPT=O

export ESMF_COMPILER=intel

####export ESMF_COMM=mpich2

export ESMF_ABI=64


export ESMF_INSTALL_PREFIX=${LIBDIR}/esmf
rm -rf ${ESMF_INSTALL_PREFIX}
mkdir -p ${ESMF_INSTALL_PREFIX}

make info         > make_info.log         2>&1
make              > make.log              2>&1
#make all_tests    > make_test.log         2>&1
#make check        > make_check.log         2>&1
make install      > make_install.log      2>&1
make installcheck > make_installcheck.log 2>&1


date
echo "Done."
exit 0
