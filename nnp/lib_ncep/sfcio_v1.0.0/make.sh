case ${COMP:?} in
  intel.cray)
    export FC=${1:-ftn}
  ;;
  cray)
    export FC=${1:-ftn}
  ;;
  intel)
    export FC=${1:-ifort}
  ;;
  ips)
    export FC=${1:-ifort}
  ;;
  *)
    >&2 echo "Don't know how to build lib under $COMP compiler"
    exit 1
  ;;
esac

export LIB=${SFCIO_LIB4:-libsfcio_${SFCIO_VER}_4.a}
export INCMOD=${SFCIO_INC4:-include/sfcio_${SFCIO_VER}_4}
mkdir -p $INCMOD

make -f makefile_4

