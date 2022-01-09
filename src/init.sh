#!/bin/bash

PRODUCT=/dev/sda27

BB=/bin/busybox
mount="$BB mount"
mkdir="$BB mkdir"
cat="$BB cat"
kexec="/bin/kexec"

CMDLINE=$($cat /proc/cmdline)

echo "KEXEC_TOOLS SH_TEST_SUCCESS" > /dev/kmsg
echo "KEXEC_TOOLS CMDLINE:" > /dev/kmsg
echo $CMDLINE > /dev/kmsg

echo "KEXEC_TOOLS Creating /tmp/product" > /dev/kmsg
$mkdir -p /tmp/product || true

echo "KEXEC_TOOLS Mounting $PRODUCT on /tmp/product" > /dev/kmsg
$mount $PRODUCT /tmp/product > /dev/kmsg

echo "KEXEC_TOOLS Executing kexec" > /dev/kmsg
$kexec -l /tmp/product/kernel --reuse-cmdline --initrd=/tmp/product/ramdisk > /dev/kmsg

echo "KEXEC_TOOLS kexec exited with: $?" > /dev/kmsg

if [ $? -eq 0 ]; then
    echo "KEXEC_TOOLS kexec status:" > /dev/kmsg
    $kexec --status > /dev/kmsg
fi