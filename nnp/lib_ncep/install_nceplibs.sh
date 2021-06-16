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
elif [[ $1 == intel.cray ]]; then
  COMPILERS=intel.cray
  export FC=ftn
  export FCFLAGS="-convert big_endian"
  export CC=cc
  export CXX=CC
else
  echo "Usage: $0 intel | intel.cray"
  exit 1
fi

echo "Installing ncep libraries using ${COMPILERS} compilers"
date

export MPIF90_F90=$FC
export MPICH_F90=$FC

MYDIR=${PWD}
LIBDIR=${NWPROD_LIB:=${MYDIR}/../lib}

mkdir -p ${LIBDIR}/incmod

#
# bacio
#
cd ${MYDIR}

export BACIO_VER=v2.0.2
export BACIO_PREC=4

rm -rf ${LIBDIR}/libbacio_${BACIO_PREC}.a

cd bacio_${BACIO_VER}/src
####./configure --prefix=${LIBDIR}
if [[ $COMPILERS == intel.cray ]]; then
export COMP=intel
makebacio_cray.sh
else
makebacio_wcoss.sh
fi

mv ../lib/libbacio_${BACIO_PREC}.a ${LIBDIR}/libbacio_${BACIO_PREC}.a

#
# nemsio
#
cd ${MYDIR}

NEMSIO_VER=v2.2.3

rm -rf ${LIBDIR}/libnemsio.a
rm -rf ${LIBDIR}/incmod/nemsio

cd nemsio_${NEMSIO_VER}
cp conf/configure.Linux.${COMPILERS} conf/configure
make

mv libnemsio.a ${LIBDIR}/libnemsio.a
mkdir -p ${LIBDIR}/incmod/nemsio
mv incmod/* ${LIBDIR}/incmod/nemsio

#
# sigio
#
cd ${MYDIR}

export SIGIO_VER=v2.0.1
export SIGIO_PREC=4

rm -rf ${LIBDIR}/libsigio_${SIGIO_PREC}.a ${LIBDIR}/incmod/sigio_${SIGIO_PREC}
cd sigio_${SIGIO_VER}/src

make clean
if [[ ${COMPILERS} == intel.cray ]]; then
make -f Makefile.intel.cray
else
make
fi

mv libsigio_${SIGIO_VER}_${SIGIO_PREC}.a ${LIBDIR}/libsigio_${SIGIO_PREC}.a 
mkdir -p ${LIBDIR}/incmod/sigio_${SIGIO_PREC}
mv sigio_r_module.mod ${LIBDIR}/incmod/sigio_${SIGIO_PREC}/.
mv sigio_module.mod ${LIBDIR}/incmod/sigio_${SIGIO_PREC}/.

#
# w3emc
#

cd ${MYDIR}

W3EMC_VER=v2.2.0
W3EMC_PREC=d

export SIGIO_INC4=${LIBDIR}/incmod/sigio_${SIGIO_PREC}
export SIGIO_LIB4=${LIBDIR}/libsigio_${SIGIO_PREC}.a

cd ${MYDIR}
###rm -rf ${LIBDIR}/libw3emc_${W3EMC_PREC}.a ${LIBDIR}/incmod/w3emc_${W3EMC_PREC}
###rm -rf ${LIBDIR}/w3emc_${W3EMC_VER}_${W3EMC_PREC}
rm -rf ${LIBDIR}/libw3emc_${W3EMC_PREC}.a
rm -rf ${LIBDIR}/incmod/w3emc_${W3EMC_PREC}
cd w3emc_${W3EMC_VER}

export COMP=intel
if [[ $COMPILERS == intel.cray ]]; then
make_w3emc_lib.sh ifort-cray.setup
else
make_w3emc_lib.sh ifort.setup
fi

mv w3emc/${W3EMC_VER}/libw3emc_${W3EMC_VER}_${W3EMC_PREC}.a ${LIBDIR}/libw3emc_${W3EMC_PREC}.a
mv w3emc/${W3EMC_VER}/incmod/w3emc_${W3EMC_VER}_${W3EMC_PREC} ${LIBDIR}/incmod/w3emc_${W3EMC_PREC}

rm -rf w3emc

#
# w3nco
#
cd ${MYDIR}

export W3NCO_VER=v2.0.6
cd w3nco_${W3NCO_VER}

if [[ $COMPILERS == intel.cray ]]; then
export COMP=intel.cray
else
export COMP=intel
fi

sh makelibw3_nco.sh
pwd
mv libw3nco_${W3NCO_VER}_d.a ${LIBDIR}/libw3nco_d.a

#
# sp
#
cd ${MYDIR}

export SP_VER=v2.0.2
cd sp_${SP_VER}


export COMP=intel
if [[ $COMPILERS == intel.cray ]]; then
sh makelibsp.sh_CrayLinux
else
sh makelibsp.sh_Linux
fi

mv libsp_${SP_VER}_d.a ${LIBDIR}/libsp_d.a
#mv libsp_4.a ${LIBDIR}
#mv libsp_8.a ${LIBDIR}

#
# sfcio
#
##cd ${MYDIR}
##export SFCIO_VER=v1.0.0
##rm -rf ${LIBDIR}/libsfcio_${SFCIO_VER}_4.a
##rm -rf ${LIBDIR}/incmod/sfcio_${SFCIO_VER}
##cd sfcio_${SFCIO_VER}
##sh make.sh
##mv libsfcio_4.a ${LIBDIR}
##mv include/sfcio_4  ${LIBDIR}/incmod/

date
echo "Done."
exit 0
