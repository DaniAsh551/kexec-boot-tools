#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd "$SCRIPT_DIR"

if [ -f ".env" ]; then
    export $(cat .env | xargs)
fi

mkdir -p out || true
rm -rf out/* || true

## Execute all build scripts
./copy-initrd.sh || exit 1
./build-init.sh || exit 1
./build-ramdisk.sh || exit 1
./build-bootimg.sh || exit 1
./push-bootimg.sh || exit 1