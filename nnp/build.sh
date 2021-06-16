#!/bin/sh
set -eux

module list

date

NNPDIR=${PWD}
export NWPROD_LIB=${NNPDIR}/lib

cd ${NNPDIR}/lib_3rdparty
./install_3rdparty.sh $1

cd ${NNPDIR}/lib_ncep
./install_nceplibs.sh $1

date
echo "Done."
