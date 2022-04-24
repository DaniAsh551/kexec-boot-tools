#!/bin/bash

echo "CC=${CC}"
if [ -z "${CC}" ]; then
    echo "Please set CC to clang from NDK"
    exit 1
fi

INIT_OUT="out/initrd"

echo "Building init with '$CC'"
$CC -pie -static -Wl,-s -UNDEBUG src/init.c -o $INIT_OUT/init

echo "Copying init.sh to $INIT_OUT/init.sh"
cp -p src/init.sh $INIT_OUT/init.sh