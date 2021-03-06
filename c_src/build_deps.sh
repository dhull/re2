#!/bin/sh

set -e

test `basename $PWD` != "c_src" && cd c_src

case "$1" in
  clean)
    rm -rf re2/obj/*
    ;;

  *)
    test -f re2/obj/libre2.a && exit 0

    (test -d re2 || hg clone https://re2.googlecode.com/hg/ re2)

    CXXFLAGS="-Wall -O3 -fPIC -pthread -m$ERLANG_ARCH"
    CXX="${CXX:-c++} -m$ERLANG_ARCH"
    which gmake 1>/dev/null 2>/dev/null && MAKE=gmake
    MAKE=${MAKE:-make}
    (cd re2 && $MAKE -j2 CXX="$CXX" CXXFLAGS="$CXXFLAGS")
    ;;
esac
