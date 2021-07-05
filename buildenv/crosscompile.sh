#! /bin/bash

ARCHITECTURES=( x86_64 i686 )
for ARCH in ${ARCHITECTURES[@]}
do
  echo $ARCH
  docker build -t cwbcross:$ARCH --build-arg TARGET=$ARCH .
  docker run -it --rm --env TARGET=$ARCH -v ~/Lab/github/libcl:/libcl cwbcross:$ARCH
done
