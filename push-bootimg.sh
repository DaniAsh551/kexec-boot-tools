#!/bin/bash

INREC="$(adb devices | grep recovery)"

echo "Pushing kexec_boot.img to device (/tmp or /data/tmp/tmp)"

PUSH_PATH="/tmp/kexec_boot.img"

if [ -z "${INREC}" ]; then
    ## Device is not in recovery (assumed in android), so create required stuff for push
    echo "WARN: Device is not in recovery mode, this will pollute /sdcard"
    PUSH_PATH="/sdcard/kexec_boot.img"
fi

adb shell "rm $PUSH_PATH" || true
adb push out/kexec_boot.img "$PUSH_PATH" || exit 1

echo "Would you like to flash the boot img?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit 1;;
    esac
done

echo "Flashing kexec_boot.img to device"
adb shell "su -c 'dd if=$PUSH_PATH of=/dev/block/by-name/boot'" || adb shell "sh -c 'dd if=$PUSH_PATH of=\$(ls /dev/block/platform/*/by-name/boot)'" || exit  1

echo "Flashing done. Would you like to reboot?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit 1;;
    esac
done

adb reboot
echo "Device reboot issued"