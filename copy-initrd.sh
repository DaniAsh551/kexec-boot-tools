#!/bin/bash

INITRD_OUT="out/initrd"

if [ -d $INITRD_OUT ]; then
    echo "Removing '$INITRD_OUT'"
    rm -rf $INITRD_OUT
fi

echo "Copying initrd to '$INITRD_OUT'"
cp -rp src/initrd out/