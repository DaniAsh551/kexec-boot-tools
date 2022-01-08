#!/bin/bash

CMDLINE="buildvariant=userdebug"

## Boot Image offsets
BOARD_BOOTIMG_HEADER_VERSION=1
BOARD_KERNEL_BASE=0x10000000
BOARD_KERNEL_OFFSET=0x00008000
BOARD_KERNEL_PAGESIZE=2048
BOARD_RAMDISK_OFFSET=0x01000000
BOARD_TAGS_OFFSET=0x00000100
BOARD="SRPRI28B009KU"

BOARD_MKBOOTIMG_ARGS=" --base $BOARD_KERNEL_BASE"
BOARD_MKBOOTIMG_ARGS+=" --pagesize $BOARD_KERNEL_PAGESIZE"
BOARD_MKBOOTIMG_ARGS+=" --kernel_offset $BOARD_KERNEL_OFFSET"
BOARD_MKBOOTIMG_ARGS+=" --ramdisk_offset $BOARD_RAMDISK_OFFSET"
BOARD_MKBOOTIMG_ARGS+=" --tags_offset $BOARD_TAGS_OFFSET"
BOARD_MKBOOTIMG_ARGS+=" --header_version $BOARD_BOOTIMG_HEADER_VERSION"

if [ ! -f kernel ]; then
    echo "kernel image not found."
    echo "Please copy a kexec compatible kernel image to './kernel'"
    exit 1
fi

BOOT_IMG="out/kexec_boot.img"
echo "Packing boot img to '$BOOT_IMG'"

mkbootimg --os_version "11.0.0" --os_patch_level "2021-10" \
 --board "$BOARD" --cmdline "$CMDLINE" $BOARD_MKBOOTIMG_ARGS \
 --kernel ./kernel --ramdisk ./out/ramdisk --output $BOOT_IMG