#! /bin/bash

ARCHITECTURES=( x86_64 i686 )
for ARCH in ${ARCHITECTURES[@]}
do
  echo $ARCH
  docker build \
    -t cwbcross:$ARCH \
    --build-arg TARGET=$ARCH \
    --build-arg MINGWDIR=/usr/lib/gcc/$ARCH-w64-mingw32/4.8/ \
    .
  docker run -it --rm \
    --env TARGET=$ARCH \
    --env MINGWDIR=/usr/lib/gcc/$ARCH-w64-mingw32/4.8/ \
    -v ~/Lab/github/libcl:/libcl \
    cwbcross:$ARCH
done
